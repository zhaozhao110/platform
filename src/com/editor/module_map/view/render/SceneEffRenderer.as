package com.editor.module_map.view.render
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.modules.mapEditor.event.MapEditorEvent;
	import com.editor.modules.mapEditor.manager.MapEditorDataManager;
	import com.editor.modules.mapEditor.mediator.AppMainPopupwinMediator;
	import com.editor.modules.mapEditor.vo.SceneEffVO;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	
	import flash.events.MouseEvent;

	public class SceneEffRenderer extends SandyBoxItemRenderer
	{
		public function SceneEffRenderer()
		{
			super();
			create_init();
		}
		
		private var nameTxt:UILabel;
		private var editorBtn:UIButton;
		private var deleteBtn:UIButton;
		private function create_init():void
		{
			width = 240; height = 30;
			backgroundColor = 0xE0E0E0;
			borderColor = 0xB3B3B3;
			borderThickness = 1;
			borderStyle = "solid";
			
			nameTxt = new UILabel();
			nameTxt.x = 5; nameTxt.y = 8;
			nameTxt.height = 20;
			addChild(nameTxt);
			
			editorBtn = new UIButton();
			editorBtn.x = 150; editorBtn.y = 5;
			editorBtn.label = "修改";
			addChild(editorBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.x = 195; deleteBtn.y = 5;
			deleteBtn.label = "删除";
			addChild(deleteBtn);
			
			editorBtn.addEventListener(MouseEvent.CLICK, onEditorBtnClickHandle);
			deleteBtn.addEventListener(MouseEvent.CLICK, onDeleteBtnClickHandle);
		}
		
		private var vo:SceneEffVO;
		override public function poolChange(dat:*):void
		{
			super.poolChange(dat);
			if(dat == null){
				return;
			}
			vo = dat as SceneEffVO;
			nameTxt.text = vo.id;
		}
		
		override public function poolDispose():void
		{
			super.poolDispose();
		}
		
		override public function select():void
		{
			super.select();
		}
		override public function noSelect():void
		{
			super.noSelect();
		}
		override public function checkSelect():Boolean
		{
			super.checkSelect();
			return false;
		}
		
		private function onItemClick():void{
			
		}
		
		override public function getSelectValue():Object
		{
			return {};
		}
		
		private function onEditorBtnClickHandle(e:MouseEvent):void
		{
			(iManager.getAppFacade().retrieveMediator(AppMainPopupwinMediator.NAME) as AppMainPopupwinMediator).openSceneEffEditorPopupwin(vo);
		}
		
		private function onDeleteBtnClickHandle(e:MouseEvent):void
		{
			MapEditorDataManager.getInstance().removeSceneEff(vo.id);
			iManager.getAppFacade().sendNotification(MapEditorEvent.mapEditor_updateSceneEffList_event);
		}
		
		
		
		
		
		
	}
}

