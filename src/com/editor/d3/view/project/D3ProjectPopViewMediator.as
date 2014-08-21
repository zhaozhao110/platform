package com.editor.d3.view.project
{
	import com.air.io.WriteFile;
	import com.editor.component.containers.UITile;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIPopupButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITree;
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.outline.D3OutlinePopViewMediator;
	import com.editor.d3.view.project.component.D3ProjectPopHBox;
	import com.editor.d3.view.project.component.D3ProjectPopListCell;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.event.App3DEvent;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.asComponent.vo.IASTreeData;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class D3ProjectPopViewMediator extends AppMediator
	{
		public static const NAME:String = "D3ProjectPopViewMediator"
		public function D3ProjectPopViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get projectPop():D3ProjectPopView
		{
			return viewComponent as D3ProjectPopView;
		}
		public function get ti():UITextInput
		{
			return projectPop.ti;
		}
		public function get infoTxt():UILabel
		{
			return projectPop.infoTxt;
		}
		public function get hbox():D3ProjectPopHBox
		{
			return projectPop.hbox;
		}
		
		override public function onRegister():void
		{
			super.onRegister();

			projectPop.reflashBtn.addEventListener(MouseEvent.CLICK,on_reflashBtn_handle)
		}
		
		public function popButtonChange(d:D3CompItemVO):void
		{
			if(D3ProjectFilesCache.getInstance().getProjectFold() == null) return ;
			
			var dd:D3ObjectBase = d.getObject(D3ComponentConst.from_project);
			dd.compItem = d.clone();
			dd.name = d.en+(getNames(d.en).length+1)+"."+dd.proccess.suffix;
			dd.file = new File(hbox.getSelectedDirectory().nativePath+File.separator+dd.name);
			dd.proccess.beForeCreateComp(laterAddObject);
		}
		
		private function getNames(n:String):Array
		{
			var b:Array = [];
			var f:File = hbox.getSelectedDirectory();
			if(f!=null){
				var a:Array = f.getDirectoryListing();
				for(var i:int=0;i<a.length;i++){
					var fl:File = a[i] as File;
					if(String(fl.name.split(".")[0]).indexOf(n)!=-1){
						b.push(fl);
					}
				}
			}
			return b;
		}
		
		private function laterAddObject(p:D3CompProcessBase=null):void
		{
			p.createComp();
			p.afterCreateComp();
			reflashTree();
			if(!D3ProjectPopListCell.selectedCell.selectContTileByName(p.comp.name)){
				if(D3ProjectPopListCell.selectedCell.nextNode){
					D3ProjectPopListCell.selectedCell.nextNode.reflashDataProvider();
					D3ProjectPopListCell.selectedCell.nextNode.selectContTileByName(p.comp.name)
				}
			}
		}
		
		public function reflashTree():void
		{
			hbox.reflashCurrentDirectory();
		}
		
		public function on_reflashBtn_handle(e:MouseEvent):void
		{
			reflashTree();
		}
		
		public function respondToChange3DProjectEvent(noti:Notification):void
		{
			if(noti.getBody() == null){
				hbox.hideAllCells();
				return ;
			}
			hbox.setTopDataProvider(D3ProjectFilesCache.getInstance().getProjectFold());
			
			if(!StringTWLUtil.isWhitespace(AppMainModel.getInstance().applicationStorageFile.curr_3dprojectFold)){
				if(D3SceneManager.getInstance().displayList.selectedComp != null) return ;
				var f:File = new File(AppMainModel.getInstance().applicationStorageFile.curr_3dprojectFold);
				if(f.exists) hbox.setSelectedItem(f);
			}
		}
		
		public function delFile(f:File):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "确定要删除"+D3ProjectFilesCache.getInstance().getProjectResPath(f)+"文件？"
			m.okFunction = confirm_del;
			m.okFunArgs = f;
			showConfirm(m);
		}
		
		private function confirm_del(f:File):Boolean
		{
			if(infoTxt.text.indexOf(f.nativePath)!=-1){
				infoTxt.text = "";
			}
			f.deleteFile();
			reflashTree();
			sendAppNotification(D3Event.delFile_in3D_event,f);
			sendAppNotification(D3Event.select3DComp_event,null);
			return true
		}
		
		private function get_D3OutlinePopViewMediator():D3OutlinePopViewMediator
		{
			return retrieveMediator(D3OutlinePopViewMediator.NAME) as D3OutlinePopViewMediator;
		}
	}
}