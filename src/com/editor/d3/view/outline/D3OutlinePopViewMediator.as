package com.editor.d3.view.outline
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIPopupButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITree;
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3ObjectGroup;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessObject;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.outline.component.D3OutlinePopHBox;
	import com.editor.d3.view.outline.component.D3OutlinePopListCell;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.event.App3DEvent;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class D3OutlinePopViewMediator extends AppMediator
	{
		public static const NAME:String = "D3OutlinePopViewMediator"
		public function D3OutlinePopViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get projectPop():D3OutlinePopView
		{
			return viewComponent as D3OutlinePopView;
		}
		public function get ti():UITextInput
		{
			return projectPop.ti;
		}
		public function get infoTxt():UILabel
		{
			return projectPop.infoTxt;
		}
		public function get hbox():D3OutlinePopHBox
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
			
			var dd:D3ObjectBase = d.getObject(D3ComponentConst.from_outline);
			dd.compItem = d.clone();
			dd.name = d.en+(getNames(d.en).length+1);
			dd.proccess.beForeCreateComp(laterAddObject);
		}
		
		private function getNames(n:String):Array
		{
			var b:Array = [];
			var f:D3TreeNode = hbox.getSelectedDirectory();
			if(f!=null){
				var a:Array = f.getList();
				for(var i:int=0;i<a.length;i++){
					var fl:D3TreeNode = a[i] as D3TreeNode;
					if(String(fl.name.split(".")[0]).indexOf(n)!=-1){
						b.push(fl);
					}
				}
			}
			return b;
		}
		      
		private function laterAddObject(p:D3CompProcessBase=null):void
		{
			D3SceneManager.getInstance().displayList.addObject(p.comp);
			p.comp.selected();
			reflashTree();
			
			if(!D3OutlinePopListCell.selectedCell.selectContTileByName(p.comp.name)){
				if(!D3OutlinePopListCell.selectedCell.nextNode){
					D3OutlinePopListCell.selectedCell.selectContTileByName(p.comp.node.branch.name)
				}
				if(D3OutlinePopListCell.selectedCell.nextNode){
					D3OutlinePopListCell.selectedCell.nextNode.reflashDataProvider();
					D3OutlinePopListCell.selectedCell.nextNode.selectContTileByName(p.comp.name);
				}
			}
		}
		
		public function respondToReflashOutlineIn3DEvent(noti:Notification):void
		{
			reflashTree();
		}
		
		public function reflashTree():void
		{
			hbox.reflashCurrentDirectory();
		}
		
		public function hideAfterCurrDirectory():void
		{
			hbox.hideAfterCurrDirectory();
		}
		
		public function on_reflashBtn_handle(e:MouseEvent):void
		{
			reflashTree();
		}
		
		public function respondToChange3DProjectEvent(noti:Notification=null):void
		{
			if(noti&&noti.getBody() == null){
				hbox.hideAllCells();
				return ;
			}
			hbox.setTopDataProvider(D3SceneManager.getInstance().displayList.rootNode);
			
			if(!StringTWLUtil.isWhitespace(AppMainModel.getInstance().applicationStorageFile.curr_3dOutlineUID)){
				var f:String = AppMainModel.getInstance().applicationStorageFile.curr_3dOutlineUID;
				if(!StringTWLUtil.isWhitespace(f)){
					hbox.setSelectedItem(f);
				}
			}
		}
		
		public function delFile(f:D3TreeNode):void
		{
			if(f.object.isGlobal){
				return ;
			}
			var m:OpenMessageData = new OpenMessageData();
			m.info = "确定要删除"+f.name+"？"
			m.okFunction = confirm_del;
			m.okFunArgs = f;
			showConfirm(m);
		}
		
		private function confirm_del(f:D3TreeNode):Boolean
		{
			if(infoTxt.text.indexOf(f.path)!=-1){
				infoTxt.text = "";
			}
			f.del();
			return true;
		}
		
		public function respondToDelFileIn3DEvent(noti:Notification):void
		{
			reflashTree();
			hideAfterCurrDirectory();
		}
		
		public function respondToParse3DObjectEvent(noti:Notification):void
		{
			reflashTree();
		}
		
		public function respondToBeforeSelect3DCompEvent(noti:Notification):void
		{
			var comp:D3ObjectBase = noti.getBody() as D3ObjectBase;
			if(comp != null){
				if(!StringTWLUtil.isWhitespace(comp.node.path)) hbox.setSelectedItem(comp.node.path);
			}
		}
		
		private function get_D3OutlinePopViewMediator():D3OutlinePopViewMediator
		{
			return retrieveMediator(D3OutlinePopViewMediator.NAME) as D3OutlinePopViewMediator;
		}
	}
}