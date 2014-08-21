package com.editor.moudule_drama.view.render
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.mediator.left.MapEditorLeftContainerMediator;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.view.right.layout.component.DLayoutSprite;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameResRecordVO;
	import com.editor.moudule_drama.vo.drama.properties.Drama_PropertiesBaseVO;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class FrameResRecordListRenderer extends SandyBoxItemRenderer
	{
		private var vo:Drama_PropertiesBaseVO;
		
		public function FrameResRecordListRenderer()
		{
			super();
			create_init();
		}
		
		private var nameTxt:UILabel;
		private var typeTxt:UILabel;
		private var editorBtn:UIButton;
		private var deleteBtn:UIButton;
		private function create_init():void
		{
			mouseEnabled = true;
			
			width = 160; height = 24;
			borderColor = 0xB3B3B3;
			borderThickness = 1;
			borderStyle = "solid";
			backgroundColor = 0xE0E0E0;
			
			nameTxt = new UILabel();
			nameTxt.x = 5; nameTxt.y = 2;
			nameTxt.width = 50;
			nameTxt.height = 20;
			addChild(nameTxt);
			
			typeTxt = new UILabel();
			typeTxt.top = 2; typeTxt.right = 30;
			typeTxt.width = 50;
			typeTxt.height = 20;
			addChild(typeTxt);
			
			editorBtn = new UIButton();
			editorBtn.top = 3; editorBtn.right = 36;
			editorBtn.width = 30; editorBtn.height = 20;
			editorBtn.label = "编辑";
			addChild(editorBtn);
			
			deleteBtn = new UIButton();
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
			vo = dat as Drama_PropertiesBaseVO;
			
			if(vo)
			{
				nameTxt.text = vo.name;
				nameTxt.toolTip = vo.name;
				typeTxt.text = vo.resType + "";
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
		}
		override public function noSelect():void
		{
			super.noSelect();
			backgroundColor = 0xE0E0E0;		
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
				var target:DLayoutSprite = DramaManager.getInstance().getLayoutViewById(vo.targetId) as DLayoutSprite;
				if(target)
				{
					sendAppNotification(DramaEvent.drama_selectedView_event, {target:target, vo:target.vo});					
				}
			}
		}
		
		private function onDeleteBtnClickHandle(e:MouseEvent):void
		{
			if(vo)
			{
				if(vo.placeFrameVO)
				{
					vo.placeFrameVO.removePropertyVO(vo);
					DramaManager.getInstance().get_DramaAttributeEditor_resRecordMediator().updataResListVbox();
					sendAppNotification(DramaEvent.drama_updataLayoutViewList_event);
				}
				
			}
			
		}
		
		
		
		
	}
}