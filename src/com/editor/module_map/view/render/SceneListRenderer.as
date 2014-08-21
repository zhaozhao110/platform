package com.editor.module_map.view.render
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.mediator.left.MapEditorLeftContainerMediator;
	import com.editor.module_map.vo.map.MapSceneItemVO;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class SceneListRenderer extends SandyBoxItemRenderer
	{
		private var vo:MapSceneItemVO;
		
		public function SceneListRenderer()
		{
			super();
			create_init();
		}
		
		private var nameTxt:UILabel;
		private var editorBtn:UIButton;
		private var deleteBtn:UIButton;
		private function create_init():void
		{
			mouseEnabled = true;
			
			width = 185; height = 24;
			borderColor = 0xB3B3B3;
			borderThickness = 1;
			borderStyle = "solid";
			backgroundColor = 0xE0E0E0;
			
			nameTxt = new UILabel();
			nameTxt.x = 5; nameTxt.y = 2;
			nameTxt.width = 112;
			nameTxt.height = 20;
			addChild(nameTxt);
			
			editorBtn = new UIButton();
//			editorBtn.x = 115; editorBtn.y = 2;
			editorBtn.top = 3; editorBtn.right = 36;
			editorBtn.width = 30; editorBtn.height = 20;
			editorBtn.label = "编辑";
			addChild(editorBtn);
			
			deleteBtn = new UIButton();
//			deleteBtn.x = 150; deleteBtn.y = 2;
			deleteBtn.top = 3; deleteBtn.right = 3;
			deleteBtn.width = 30; deleteBtn.height = 20;
			deleteBtn.label = "删除";
			addChild(deleteBtn);
			
			addEventListener(MouseEvent.CLICK, onItemClick);
			editorBtn.addEventListener(MouseEvent.CLICK, onEditorBtnClickHandle);
			deleteBtn.addEventListener(MouseEvent.CLICK, onDeleteBtnClickHandle);
		}
		
		override public function poolChange(dat:*):void
		{
			super.poolChange(dat);
			if(dat == null){
				return;
			}
			vo = dat as MapSceneItemVO;
			
			if(vo)
			{
				nameTxt.text = vo.sourceId + " / " + vo.sourceName;
				nameTxt.toolTip = vo.sourceId + " / " + vo.sourceName;
				checkIsDefault();
			}
						
		}
		
		
		override public function poolDispose():void
		{
			super.poolDispose();
		}
		
		override public function select():void
		{
			super.select();
			backgroundColor = 0xFFFFFF;
			checkIsDefault();
		}
		override public function noSelect():void
		{
			super.noSelect();
			backgroundColor = 0xE0E0E0;
			checkIsDefault();			
		}
		private function checkIsDefault():void
		{
			if(vo.isDefault > 0)
			{
				nameTxt.color = 0x1C9900;
			}else
			{
				nameTxt.color = 0x595959;
			}
		}
		override public function checkSelect():Boolean
		{
			super.checkSelect();
			return false;
		}
		
		private function onItemClick(e:MouseEvent):void{
			dispatchSelect(true);
		}
		
		override public function getSelectValue():Object
		{	
			return vo;
		}
		
		
		
		
		private function onEditorBtnClickHandle(e:MouseEvent):void
		{
			if(vo)
			{
				iManager.getAppFacade().sendNotification(MapEditorEvent.mapEditor_editPripertiesDate_event, {vo:vo});
			}
		}
		
		private function onDeleteBtnClickHandle(e:MouseEvent):void
		{
			if(vo)
			{
				MapEditorDataManager.getInstance().removeScene(vo.id);
				iManager.getAppFacade().sendNotification(MapEditorEvent.mapEditor_updateSceneList_event);
			}
			
		}
		
		private function get_MapEditorLeftContainerMediator():MapEditorLeftContainerMediator
		{
			return iManager.getAppFacade().retrieveMediator(MapEditorLeftContainerMediator.NAME) as MapEditorLeftContainerMediator;
		}
		
		
	}
}