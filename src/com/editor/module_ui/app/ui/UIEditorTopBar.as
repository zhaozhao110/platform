package com.editor.module_ui.app.ui
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.events.MouseEvent;
	
	public class UIEditorTopBar extends UIHBox
	{
		public function UIEditorTopBar()
		{
			super()
			create_init();
		}
		
		public var colorBtn:UIButton;
		public var colorTI:UITextInput;
		public var colorCont:UICanvas;
		public var screenBtn:UIButton;
		
		private function create_init():void
		{
			height = 30;
			percentWidth = 100;
			paddingLeft = 10;
			styleName = "uicanvas"
			horizontalGap = 5;
			verticalAlign = ASComponentConst.verticalAlign_middle;
			
			colorBtn = new UIButton();
			colorBtn.label = "取颜色"
			//colorBtn.bold = true
			addChild(colorBtn);
			
			colorTI = new UITextInput();
			colorTI.width = 100;
			//colorTI.selectable = false;
			colorTI.editable = false;
			addChild(colorTI);
			
			colorCont = new UICanvas();
			colorCont.width = 25;
			colorCont.height = 25;
			addChild(colorCont);
			
			screenBtn = new UIButton();
			screenBtn.label = "截屏取大小"
			screenBtn.addEventListener(MouseEvent.CLICK , onScreen);
			addChild(screenBtn);
		}
		
		private function onScreen(e:MouseEvent):void
		{
			Object(SandyEngineGlobal.application).systrayBackFun();
		}
	}
}