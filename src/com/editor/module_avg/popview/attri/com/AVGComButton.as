package com.editor.module_avg.popview.attri.com
{
	import com.editor.component.controls.UIButton;
	import com.editor.module_avg.popview.attri.AVGAttriComBaseVO;
	
	import flash.events.MouseEvent;

	public class AVGComButton extends AVGComBase
	{
		public function AVGComButton()
		{
			super();
		}
		
		private var btn:UIButton;
		
		override protected function create_init():void
		{
			super.create_init();
			
			btn = new UIButton();
			btn.addEventListener(MouseEvent.CLICK,onClickHandle)
			addChild(btn);
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			callUIRender();
		}
		
		override public function setValue(obj:AVGAttriComBaseVO):void
		{
			super.setValue(obj);
			
			btn.label = item.key;
		}
		
	}
}