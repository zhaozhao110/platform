package com.editor.popup.systemSet.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.controls.ASColorPickerBar;
	import com.sandy.asComponent.event.ASEvent;
	
	public class SystemSetPopwinColorBar extends UIHBox
	{
		public function SystemSetPopwinColorBar()
		{
			super();
			create_init();
		}
		
		private var lb:UILabel;
		public var colorBar:ASColorPickerBar;
		public var colorChange_f:Function;
		
		private function create_init():void
		{
			width = 500
			lb = new UILabel();
			lb.width = 100;
			addChild(lb);
			
			colorBar = new ASColorPickerBar();
			colorBar.width = 120;
			colorBar.height = 22;
			colorBar.addEventListener(ASEvent.CHANGE,onChangeHandle);
			addChild(colorBar);
		}
		
		public function setItem(c:String):void
		{
			lb.text = c;
		}
		
		private function onChangeHandle(e:ASEvent):void
		{
			if(colorChange_f!=null) colorChange_f();
		}
	}
}