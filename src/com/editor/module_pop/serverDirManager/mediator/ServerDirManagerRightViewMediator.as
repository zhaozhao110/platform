package com.editor.module_pop.serverDirManager.mediator
{
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.component.expand.UIFileManagerToolBar;
	import com.editor.component.expand.UITextInputWithLabelWithSelectFile;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_pop.serverDirManager.itemRenderer.ServerDirManagerBottomUploadRenderer;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerRightView;
	import com.editor.popup.input.InputTextPopwinVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.asComponent.event.ASEvent;
	import com.air.io.WriteFile;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.ColorUtils;
	
	import flash.filesystem.File;
	import flash.net.URLVariables;

	/**
	 * 本地目录
	 */ 
	public class ServerDirManagerRightViewMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ServerDirManagerRightViewMediator"
		public function ServerDirManagerRightViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get rightView():ServerDirManagerRightView
		{
			return viewComponent as ServerDirManagerRightView
		}
		public function get toolBar():UIFileManagerToolBar
		{
			return rightView.toolBar;
		}
		public function get listCom():UIVlist
		{
			return rightView.listCom;
		}
		public function get pathTI():UITextInputWithLabelWithSelectFile
		{
			return rightView.pathTI;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			pathTI.openDirectory = true;
			pathTI.addEventListener(ASEvent.CHANGE,onPathSelect);
			
			listCom.addEventListener(ASEvent.CHANGE , onListChange)
				
			toolBar.backFun = on_back;
			toolBar.newFun = on_new;
			toolBar.delFun = on_del;
			toolBar.uploadFun = on_upload;
			toolBar.reflashFun = on_reflash;
			toolBar.downloadBtnVisible = false;
		}
		
		public function getPath():String
		{
			return pathTI.text;
		}
		
		private var selectFile:File;
		
		private function onPathSelect(e:ASEvent):void
		{
			reflashPathList(e.data as File);
		}
		
		private function reflashPathList(fl:File):void
		{
			if(fl == null) return ;
			selectFile = fl;
			listCom.dataProvider = selectFile.getDirectoryListing();
			pathTI.text = selectFile.nativePath;
		}
		
		private function openFile(fl:File):Boolean
		{
			fl.openWithDefaultApplication();
			get_ServerDirManagerBottomViewMediator().createLog("打开本地文件："+fl.nativePath);
			return true;
		}
		
		private function onListChange(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var fl:File = listCom.selectedItem as File;
				if(fl == null) return ;
				if(!fl.isDirectory){
					var m:OpenMessageData = new OpenMessageData();
					m.info = "您确定要打开"+ColorUtils.addColorTool(fl.name,ColorUtils.blue)+"这个文件？"
					m.okFunction = openFile;
					m.okFunArgs = fl;
					showConfirm(m);
					return ;
				}
				selectFile = fl;
				listCom.dataProvider = selectFile.getDirectoryListing();
				pathTI.text = selectFile.nativePath;
			}
		}
		
		private function on_back():void
		{
			if(selectFile == null) return ;
			reflashPathList(selectFile.parent);
		}
		
		private function on_reflash():void
		{
			if(selectFile == null) return ;
			reflashPathList(selectFile);
		}
		
		private function on_upload():void
		{
			var file:File = listCom.selectedItem as File;
			if(file!=null){
				if(!file.isDirectory){
					var ui:ServerDirManagerBottomUploadRenderer = new ServerDirManagerBottomUploadRenderer();
					var args:URLVariables = new URLVariables();
					args.url = get_ServerDirManagerLeftViewMediator().getPath();
					ui.upload(file.nativePath,AppGlobalConfig.instance.upload,args);
					get_ServerDirManagerBottomViewMediator().vbox.addChild(ui);
				}
			}
		}
		
		private function on_del():void
		{
			var file:File = listCom.selectedItem as File;
			if(file == null) return ;
			var m:OpenMessageData = new OpenMessageData();
			m.info = "您确定要删除?";
			m.okFunction = after_on_del;
			showConfirm(m);
		}	
		
		private function after_on_del():Boolean
		{
			var file:File = listCom.selectedItem as File;
			if(file!=null){
				if(file.isDirectory){
					file.deleteDirectory(true);
				}else{
					file.deleteFile();
				}
				get_ServerDirManagerBottomViewMediator().createLog("删除本地文件："+file.nativePath);
			}
			return true;
		}
		
		private function on_new():void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.InputTextPopwin_sign;
			var d:InputTextPopwinVO = new InputTextPopwinVO();
			d.title = "输入新建目录名"
			d.okButtonFun = after_on_new;
			open.data = d;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		private function after_on_new(nm:String):void
		{
			WriteFile.createDirectory(getPath()+File.separator+nm);
			get_ServerDirManagerBottomViewMediator().createLog("新建本地文件："+nm);
		}
		
		private function get_ServerDirManagerLeftViewMediator():ServerDirManagerLeftViewMediator
		{
			return retrieveMediator(ServerDirManagerLeftViewMediator.NAME) as ServerDirManagerLeftViewMediator
		}
		
		private function get_ServerDirManagerBottomViewMediator():ServerDirManagerBottomViewMediator
		{
			return retrieveMediator(ServerDirManagerBottomViewMediator.NAME) as ServerDirManagerBottomViewMediator
		}
	}
}