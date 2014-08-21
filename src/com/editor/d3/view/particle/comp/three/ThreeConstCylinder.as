package com.editor.d3.view.particle.comp.three
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.expand.UINumericStepperWidthLabel;
	import com.editor.d3.view.particle.comp.UIH3NumericStepperWidthLabel;
	import com.sandy.asComponent.event.ASEvent;

	public class ThreeConstCylinder extends UIVBox
	{
		public function ThreeConstCylinder(c:ThreeConstComponent)
		{
			super();
			comp = c;
			create_init();
		}
		
		private var comp:ThreeConstComponent;
		public var ns1:UINumericStepperWidthLabel;
		public var ns2:UINumericStepperWidthLabel;
		public var ns6:UINumericStepperWidthLabel;
		public var ns3:UIH3NumericStepperWidthLabel;
		public var ns4:UIH3NumericStepperWidthLabel;
		
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
			
			ns6 = new UINumericStepperWidthLabel();
			ns6.label = "height:"
			ns6.enterKeyDown_proxy = enterKeyDown1
			ns6.addEventListener(ASEvent.CHANGE, onValueChange1)
			ns6.width = 200;
			ns6.minimum = -10000000
			ns6.maximum = 1000000;
			ns6.stepSize = .1;
			addChild(ns6);
			
			ns3 = new UIH3NumericStepperWidthLabel();
			ns3.label = "center:"
			ns3.save_f = saveObject;
			addChild(ns3);
			
			ns4 = new UIH3NumericStepperWidthLabel();
			ns4.label = "direction:"
			ns4.save_f = saveObject;
			addChild(ns4);
			
			reset()
		}
		
		override public function reset():void
		{
			ns1.value = 0;
			ns2.value = 100;
			ns6.value = 100;
			ns3.reset();
			ns4.reset();
			ns4.ns2.value = 1;
		}
		
		private function enterKeyDown1():void
		{
			saveObject();
		}
		
		private function onValueChange1(e:ASEvent):void
		{
			saveObject();
		}
		
		public function saveObject():void
		{
			comp.selectedObject = getObject()
			comp.callReflash();
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "ThreeDCylinderValueSubParser"
			obj.data = {};
			obj.data.innerRadius = ns1.value;
			obj.data.outerRadius = ns2.value;
			obj.data.height  = ns6.value;
			obj.data.centerX = ns3.ns1.value;
			obj.data.centerY = ns3.ns2.value;
			obj.data.centerZ = ns3.ns3.value;
			obj.data.dX = ns4.ns1.value;
			obj.data.dY = ns4.ns2.value;
			obj.data.dZ = ns4.ns3.value;
			return obj;
		}
		
		public function setValue():void
		{
			if(comp.selectedObject.data!=null){
				ns1.value = comp.selectedObject.data.innerRadius;
				ns2.value = comp.selectedObject.data.outerRadius
				ns6.value = comp.selectedObject.data.height
				ns3.ns1.value = comp.selectedObject.data.centerX
				ns3.ns2.value = comp.selectedObject.data.centerY
				ns3.ns3.value = comp.selectedObject.data.centerZ
				ns4.ns1.value = comp.selectedObject.data.dX
				ns4.ns2.value = comp.selectedObject.data.dY
				ns4.ns3.value = comp.selectedObject.data.dZ
			}else{
				reset();
			}
		}
		
		
	}
}