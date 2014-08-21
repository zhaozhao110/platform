package com.editor.module_avg.popview.attri.com
{
	import com.editor.component.controls.UINumericStepper;
	import com.editor.module_avg.popview.attri.AVGAttriComBaseVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;

	public class AVGComNumericStepper extends AVGComBase
	{
		public function AVGComNumericStepper()
		{
			super();
		}
		
		private var ns:UINumericStepper;
		
		override protected function create_init():void
		{
			super.create_init();
			
			ns = new UINumericStepper();
			ns.enterKeyDown_proxy = enterKeyDown
			ns.percentWidth = 100;
			ns.editable = true;
			ns.maximum = 10000000;
			ns.minimum = -10000000
			ns.addEventListener(ASEvent.CHANGE, onValueChange)
			ns.height = 22;
			addChild(ns);			
		}
		
		private function enterKeyDown():void
		{
			callUIRender();
		}
		
		override public function setValue(obj:AVGAttriComBaseVO):void
		{
			super.setValue(obj);
			
			if(!StringTWLUtil.isWhitespace(item.expand)){
				var a:Array = item.expand.split("-");
				ns.minimum = Number(a[0]);
				ns.maximum = Number(a[1]);
				if(ns.maximum == 1){
					ns.stepSize = .1;
				}else{
					ns.stepSize = 1;
				}
				ns.value = ns.maximum;
			}
			
			if(!StringTWLUtil.isWhitespace(item.defaultValue)){
				ns.value = int(item.defaultValue);
			}
			
			var v:* = getCompValue();
			if(v!=null) ns.value = v; 
		}
		
		private function onValueChange(e:ASEvent):void
		{
			callUIRender();
		}
		
		override public function getValue():AVGAttriComBaseVO
		{
			var d:AVGAttriComBaseVO = createComBaseVO();
			d.data = ns.value;
			return d
		}
	}
}