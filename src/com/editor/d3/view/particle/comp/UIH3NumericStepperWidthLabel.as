package com.editor.d3.view.particle.comp
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UINumericStepper;
	import com.sandy.asComponent.event.ASEvent;
	
	public class UIH3NumericStepperWidthLabel extends UIHBox
	{
		public function UIH3NumericStepperWidthLabel()
		{
			super();
			
			verticalAlignMiddle = true;
			horizontalGap = 3;
			height = 25;
			
			lb = new UILabel();
			lb.text = label
			lb.width = 50;
			addChild(lb);
			
			ns1 = new UINumericStepper();
			ns1.enterKeyDown_proxy = enterKeyDown1
			ns1.addEventListener(ASEvent.CHANGE, onValueChange1)
			ns1.width = 60;
			ns1.minimum = -10000000
			ns1.maximum = 1000000;
			ns1.stepSize = .1;
			addChild(ns1);
			
			ns2 = new UINumericStepper();
			ns2.enterKeyDown_proxy = enterKeyDown1
			ns2.addEventListener(ASEvent.CHANGE, onValueChange1)
			ns2.width = 60;
			ns2.minimum = -10000000
			ns2.maximum = 1000000;
			ns2.stepSize = .1;
			addChild(ns2);
			
			ns3 = new UINumericStepper();
			ns3.enterKeyDown_proxy = enterKeyDown1
			ns3.addEventListener(ASEvent.CHANGE, onValueChange1)
			ns3.width = 60;
			ns3.minimum = -10000000
			ns3.maximum = 1000000;
			ns3.stepSize = .1;
			addChild(ns3);
			
			reset()
		}
		
		override public function reset():void
		{
			ns1.value = 0;	
			ns2.value = 0;
			ns3.value = 0;
		}
		
		override public function set label(value:String):void
		{
			super.label = value;
			if(lb!=null) lb.text = value;
		}
		
		public var lb:UILabel;
		public var ns1:UINumericStepper;
		public var ns2:UINumericStepper;
		public var ns3:UINumericStepper;
		
		public var save_f:Function;
		
		public function enterKeyDown1():void
		{
			if(save_f!=null) save_f();
		}
		
		public function onValueChange1(e:ASEvent):void
		{
			if(save_f!=null) save_f();
		}
		
	}
}