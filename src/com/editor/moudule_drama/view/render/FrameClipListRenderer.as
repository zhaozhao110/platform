package com.editor.moudule_drama.view.render
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.vo.drama.Drama_FrameClipVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	public class FrameClipListRenderer extends SandyBoxItemRenderer
	{
		private var vo:Drama_FrameClipVO;
		
		public function FrameClipListRenderer()
		{
			super();
			create_init();
		}
		
		private var nameTxt:UILabel;
		private var editorBtn:UIButton;
		private var deleteBtn:UIButton;
		private var editTxtInput:UITextInput;
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
			nameTxt.width = 100;
			nameTxt.height = 20;
			addChild(nameTxt);
			
			editTxtInput = new UITextInput();
			editTxtInput.x = 5; editTxtInput.y = 2;
			editTxtInput.width = 100; editTxtInput.height = 22;
			editTxtInput.visible = false;
			addChild(editTxtInput);
						
			editorBtn = new UIButton();
			editorBtn.top = 3; editorBtn.right = 36;
			editorBtn.width = 30; editorBtn.height = 20;
			editorBtn.label = "编辑";
			editorBtn.visible = false;
			addChild(editorBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.top = 3; deleteBtn.right = 3;
			deleteBtn.width = 30; deleteBtn.height = 20;
			deleteBtn.label = "删除";
			addChild(deleteBtn);
			
			addEventListener(MouseEvent.CLICK, onItemClick);
			editorBtn.addEventListener(MouseEvent.CLICK, onEditorBtnClickHandle);
			deleteBtn.addEventListener(MouseEvent.CLICK, onDeleteBtnClickHandle);
			
			nameTxt.mouseEnabled = true;
			nameTxt.mouseChildren = false;
			nameTxt.$doubleClickEnabled = true;
			nameTxt.addEventListener(MouseEvent.DOUBLE_CLICK, onItemDoubleClick);
			nameTxt.addEventListener(MouseEvent.CLICK, onItemClick);
		}
		
		override public function poolChange(dat:*):void
		{
			super.poolChange(dat);
			if(dat == null){
				return;
			}
			vo = dat as Drama_FrameClipVO;
			
			if(vo)
			{
				nameTxt.text = vo.name;
				nameTxt.toolTip = "双击改名：" + vo.name;
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
		
		private function onItemDoubleClick(e:MouseEvent):void
		{
			if(vo)
			{
				nameTxt.removeEventListener(ASEvent.DOUBLE_CLICK, onItemDoubleClick);
				editTxtInput.text = vo.name;
				editTxtInput.visible = true;
				nameTxt.visible = false;
				editTxtInput.addEventListener(FocusEvent.FOCUS_OUT, onEditTxtInputFocusHandle);
			}			
		}
		private function onEditTxtInputFocusHandle(e:FocusEvent):void
		{
			editTxtInput.removeEventListener(FocusEvent.FOCUS_OUT, onEditTxtInputFocusHandle);
			nameTxt.addEventListener(ASEvent.DOUBLE_CLICK, onItemDoubleClick);
			editTxtInput.visible = false;
			nameTxt.visible = true;
			if(vo)
			{
				vo.name = editTxtInput.text;
				nameTxt.text = vo.name;
			}
		}
		
		override public function getSelectValue():Object
		{	
			return vo;
		}
		
		private function onEditorBtnClickHandle(e:MouseEvent):void
		{
			if(vo)
			{
								
			}
		}
		
		private function onDeleteBtnClickHandle(e:MouseEvent):void
		{
			if(vo)
			{
				var confirmData:OpenMessageData = new OpenMessageData();
				confirmData.info = "将删除该片段所有资源，\<br\>是否确定删除？";
				confirmData.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				confirmData.okFunction = okFunction;
				DramaManager.getInstance().get_DramaModuleMediator().showConfirm(confirmData);
				
				function okFunction():Boolean
				{
					DramaDataManager.getInstance().removeFrameClip(vo.id);
					DramaManager.getInstance().get_DramaLeftContainerMediator().updataFrameClipList();
					return true;
				}
				
			}
			
		}
		
		
				
	}
}