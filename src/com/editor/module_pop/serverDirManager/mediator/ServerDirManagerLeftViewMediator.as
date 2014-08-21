package com.editor.module_pop.serverDirManager.mediator
{
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.component.expand.UIFileManagerToolBar;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_pop.serverDirManager.ServerDirManagerPopwinMediator;
	import com.editor.module_pop.serverDirManager.itemRenderer.ServerDirManagerBottomDownRenderer;
	import com.editor.module_pop.serverDirManager.view.ServerDirManagerLeftView;
	import com.editor.module_pop.serverDirManager.vo.ServerDirManagerServerFileVO;
	import com.editor.popup.input.InputTextPopwinVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.core.SandyEngineConst;
	import com.air.io.DownloadFile;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.net.json.SandyJSON;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.net.URLVariables;

	/**
	 * 远程目录
	 */ 
	public class ServerDirManagerLeftViewMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ServerDirManagerLeftViewMediator"
		public function ServerDirManagerLeftViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get leftView():ServerDirManagerLeftView
		{
			return viewComponent as ServerDirManagerLeftView
		}
		public function get toolBar():UIFileManagerToolBar
		{
			return leftView.toolBar;
		}
		public function get listCom():UIVlist
		{
			return leftView.listCom;
		}
		public function get pathTI():UITextInputWidthLabel
		{
			return leftView.pathTI;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			listCom.addEventListener(ASEvent.CHANGE , onListChange)
			http.sucResult_f = httpResult;
			
			toolBar.backFun = on_back;
			toolBar.newFun = on_new;
			toolBar.delFun = on_del;
			toolBar.downloadFun = on_download;
			toolBar.reflashFun = on_reflash;
			toolBar.uploadBtnVisible = false;			
		}
		
		public function getPath():String
		{
			return pathTI.text;
		}
		
		public function reflashPathList(a:Array):void
		{
			var out:Array = []
			for(var i:int=0;i<a.length;i++){
				if(!StringTWLUtil.isWhitespace(a[i])){
					var b:Array = String(a[i]).split("|");
					var d:ServerDirManagerServerFileVO = new ServerDirManagerServerFileVO();
					d.fileName = String(b[0]).split(".")[0];
					d.extension = String(b[0]).split(".")[1];
					d.isDirectory = int(b[1])==1?true:false;
					d.size = b[2];
					d.path = b[3];
					d.serverURL = b[4];
					out.push(d);
				}
			}
			listCom.dataProvider = out;
		}
		
		private function onListChange(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var file:ServerDirManagerServerFileVO = e.addData as ServerDirManagerServerFileVO;
				if(file.isDirectory){
					conn(file.path);
				}
			}else{
				
			}
		}
		
		private function on_back():void
		{
			conn(pathTI.text,"back");
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
			conn("","new",nm);
			get_ServerDirManagerBottomViewMediator().createLog("新建服务器目录："+nm);
		}
		
		private function on_del():void
		{
			var file:ServerDirManagerServerFileVO = listCom.selectedItem as ServerDirManagerServerFileVO;
			if(file==null) return;
			var m:OpenMessageData = new OpenMessageData();
			m.info = "您确定要删除?";
			m.okFunction = after_on_del;
			showConfirm(m);
		}	
		
		private function after_on_del():Boolean
		{
			var file:ServerDirManagerServerFileVO = listCom.selectedItem as ServerDirManagerServerFileVO;
			if(file!=null){
				conn("","del",file.path);
				get_ServerDirManagerBottomViewMediator().createLog("删除服务器目录："+file.path);
			}
			return true;
		}
		
		private function on_download():void
		{
			var file:ServerDirManagerServerFileVO = listCom.selectedItem as ServerDirManagerServerFileVO;
			if(file!=null){
				if(!file.isDirectory){
					var ui:ServerDirManagerBottomDownRenderer = new ServerDirManagerBottomDownRenderer();
					ui.download("http://"+file.serverURL,get_ServerDirManagerRightViewMediator().getPath());
					get_ServerDirManagerBottomViewMediator().vbox.addChild(ui);
				}
			}
		}
				
		private function on_reflash():void
		{
			conn("","reflash");
		}
		
		private var http:AS3HTTPServiceLocator = new AS3HTTPServiceLocator();
		
		public function conn(path:String="",action:String="",d:String=null):void
		{
			if(path == ""){
				path = pathTI.text;
			}
			var args:URLVariables = new URLVariables();
			args.url 	= path;
			args.action = action;
			args.data 	= d;
			
			http.args = args;
			
			http.conn(get_ServerDirManagerPopwinMediator().getServerURL(),SandyEngineConst.HTTP_POST,SandyEngineConst.resultFor_obj_type);
		}
		
		private function httpResult(d:*):void
		{
			var obj:Object = SandyJSON.parser(d);
			pathTI.text = obj.url;
			var fileList:String = obj.list;
			reflashPathList(fileList.split("*"));
		}
		
		private function get_ServerDirManagerPopwinMediator():ServerDirManagerPopwinMediator
		{
			return retrieveMediator(ServerDirManagerPopwinMediator.NAME) as ServerDirManagerPopwinMediator
		}
		
		private function get_ServerDirManagerRightViewMediator():ServerDirManagerRightViewMediator
		{
			return retrieveMediator(ServerDirManagerRightViewMediator.NAME) as ServerDirManagerRightViewMediator
		}
		
		private function get_ServerDirManagerBottomViewMediator():ServerDirManagerBottomViewMediator
		{
			return retrieveMediator(ServerDirManagerBottomViewMediator.NAME) as ServerDirManagerBottomViewMediator
		}
	}
}