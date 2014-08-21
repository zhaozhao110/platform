package com.editor.module_avg.view.right
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.mediator.AVGModuleMediator;
	import com.editor.module_avg.vo.frame.AVGFrameItemVO;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.events.MouseEvent;
	
	public class AVGModRightTopBar extends UIHBox
	{
		public function AVGModRightTopBar()
		{
			super();
			create_init();
		}
		
		public var txtBtn:UIButton
		public var optionsBtn:UIButton;
		public var shakeCB:UICheckBox;
		
		private function create_init():void
		{
			height = 30;
			percentWidth = 100;
			verticalAlignMiddle = true;
			paddingLeft =10;
			horizontalGap =10;
			
			txtBtn = new UIButton();
			txtBtn.label = "编辑文本"
			txtBtn.addEventListener(MouseEvent.CLICK , onTxtBtnClick);
			addChild(txtBtn);
			
			optionsBtn = new UIButton();
			optionsBtn.label = "添加选项"
			optionsBtn.addEventListener(MouseEvent.CLICK , onOptClick);
			addChild(optionsBtn);
			
			shakeCB = new UICheckBox();
			shakeCB.label = "是否抖动"
			shakeCB.addEventListener(ASEvent.CHANGE,onShakeChange)
			addChild(shakeCB);
		}
		
		public function setFrame(d:AVGFrameItemVO):void
		{
			shakeCB.selected = d.shake;
		}
		
		private function onShakeChange(e:ASEvent):void
		{
			if(AVGManager.currFrame == null){
				shakeCB.setSelect(false,false);
			}else{
				AVGManager.currFrame.shake = shakeCB.selected;
			}
		}
		
		private function onTxtBtnClick(e:MouseEvent):void
		{
			get_AVGModuleMediator().openEditTxt();
		}
		
		private function onOptClick(e:MouseEvent):void
		{
			get_AVGModuleMediator().openOptionPop();	
		}
				
		private function get_AVGModuleMediator():AVGModuleMediator
		{
			return iManager.retrieveMediator(AVGModuleMediator.NAME) as AVGModuleMediator;
		}
	}
}