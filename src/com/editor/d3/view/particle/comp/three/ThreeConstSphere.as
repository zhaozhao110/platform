package com.editor.d3.view.particle.comp.three
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.expand.UINumericStepperWidthLabel;
	import com.editor.d3.view.particle.comp.UIH3NumericStepperWidthLabel;
	import com.sandy.asComponent.event.ASEvent;

	public class ThreeConstSphere extends UIVBox
	{
		public function ThreeConstSphere(c:ThreeConstComponent)
		{
			super();
			comp = c;
			create_init();
		}
		
		private var comp:ThreeConstComponent;
		public var ns1:UINumericStepperWidthLabel;
		public var ns2:UINumericStepperWidthLabel;
		public var ns3:UIH3NumericStepperWidthLabel;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			
			ns1 = new UINumericStepperWidthLabel();
			ns1.label = "inner radius:"
			ns1.enterKeyDown_proxy = enterKeyDown1
			ns1.addEventListener(ASEvent.CHANGE, onValueChange1)
			ns1.width = 200;
			ns1.minimum = -10000000
			ns1.maximum = 1000000;
			ns1.stepSize = .1;
			addChild(ns1);
			
			ns2 = new UINumericStepperWidthLabel();
			ns2.label = "outer radius:"
			ns2.enterKeyDown_proxy = enterKeyDown1
			ns2.addEventListener(ASEvent.CHANGE, onValueChange1)
			ns2.width = 200;
			ns2.minimum = -10000000
			ns2.maximum = 1000000;
			ns2.stepSize = .1;
			addChild(ns2);
			
			ns3 = new UIH3NumericStepperWidthLabel();
			ns3.save_f = saveObject;
			ns3.percentWidth = 100;
			ns3.label = "center:"
			addChild(ns3);
			
			reset();
		}
		
		override public function reset():void
		{
			ns1.value = 0;
			ns2.value = 100;
			ns3.reset();
		}
		
		private function enterKeyDown1():void
		{
			saveObject()
		}
		
		private function onValueChange1(e:ASEvent):void
		{
			saveObject()
		}
		
		public function saveObject():void
		{
			comp.selectedObject = getObject()
			comp.callReflash();
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "ThreeDSphereValueSubParser"
			obj.data = {};
			obj.data.innerRadius = ns1.value;
			obj.data.outerRadius = ns2.value;
			obj.data.centerX = ns3.ns1.value;
			obj.data.centerY = ns3.ns2.value;
			obj.data.centerZ = ns3.ns3.value;
			return obj;
		}
		
		public function setValue():void
		{
			if(comp.selectedObject.data!=null){
				ns1.value = comp.selectedObject.data.innerRadius
				ns2.value = comp.selectedObject.data.outerRadius
				ns3.ns1.value = comp.selectedObject.data.centerX
				ns3.ns2.value = comp.selectedObject.data.centerY
				ns3.ns3.value = comp.selectedObject.data.centerZ
			}else{
				reset();
			}
		}
		
	}
}