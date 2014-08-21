package com.editor.module_ui.app.ui
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	
	import flash.events.MouseEvent;
		
	public class UIEditorTopBarMediator extends AppMediator
	{
		public static const NAME:String = 'UIEditorTopBarMediator'
		public function UIEditorTopBarMediator( viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get topBar():UIEditorTopBar
		{
			return viewComponent as UIEditorTopBar;
		}
		public function get colorBtn():UIButton
		{
			return topBar.colorBtn;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			colorBtn.addEventListener(MouseEvent.CLICK , onColor);
			topBar.stage.addEventListener(MouseEvent.RIGHT_CLICK , onRightClick)
		}
		
		private var mouseStatus:int;
		
		public function isInPickColor():Boolean
		{
			return mouseStatus == 3;
		}
		
		private function onColor(e:MouseEvent):void
		{
			/*topBar.addChild(colorBtn.clone())
			return ;*/
			mouseStatus = 3;
			iCursor.setCursorBySign("color2_a",0,-22);
		}
		
		private function onRightClick(e:*=null):void
		{
			if(mouseStatus == 3){
				iCursor.setDefaultCursor();
			}
			mouseStatus = 0;
		}
		
		public function pickBackgroundColor(c:uint):void
		{
			if(mouseStatus == 3){
				topBar.colorTI.text = "0x"+c.toString(16);
				topBar.colorCont.backgroundColor = c;
			}
		}
		
	}
}