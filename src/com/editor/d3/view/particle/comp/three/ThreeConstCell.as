package com.editor.d3.view.particle.comp.three
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.expand.UINumericStepperWidthLabel;
	import com.sandy.asComponent.event.ASEvent;

	public class ThreeConstCell extends UIVBox
	{
		public function ThreeConstCell(c:ThreeConstComponent)
		{
			super();
			comp = c;
			create_init();
		}
		
		private var comp:ThreeConstComponent;
		public var xNS:UINumericStepperWidthLabel;
		public var yNS:UINumericStepperWidthLabel;
		public var zNS:UINumericStepperWidthLabel;
		
		
		private function create_init():void
		{
			enabledPercentSize = true
			
			xNS = new UINumericStepperWidthLabel();
			xNS.label = "x:"
			xNS.enterKeyDown_proxy = enterKeyDown1
			xNS.addEventListener(ASEvent.CHANGE, onValueChange1)
			xNS.width = 200;
			xNS.minimum = -10000000
			xNS.maximum = 1000000;
			xNS.stepSize = .1;
			addChild(xNS);
			
			yNS = new UINumericStepperWidthLabel();
			yNS.label = "y:"
			yNS.enterKeyDown_proxy = enterKeyDown1
			yNS.addEventListener(ASEvent.CHANGE, onValueChange1)
			yNS.width = 200;
			yNS.minimum = -10000000
			yNS.maximum = 1000000;
			yNS.stepSize = .1;
			addChild(yNS);
			
			zNS = new UINumericStepperWidthLabel();
			zNS.label = "z:"
			zNS.enterKeyDown_proxy = enterKeyDown1
			zNS.addEventListener(ASEvent.CHANGE, onValueChange1)
			zNS.width = 200;
			zNS.minimum = -10000000
			zNS.maximum = 1000000;
			zNS.stepSize = .1;
			addChild(zNS);
			
			reset()
		}
		
		override public function reset():void
		{
			xNS.value = 0;
			yNS.value = 0;
			zNS.value = 0;
		}
		
		private function enterKeyDown1():void
		{
			saveObject()
		}
		
		private function onValueChange1(e:ASEvent):void
		{
			saveObject();
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "ThreeDConstValueSubParser"
			obj.data = {};
			obj.data.x = xNS.value;
			obj.data.y = yNS.value;
			obj.data.z = zNS.value;
			return obj;
		}
		
		public function setValue():void
		{
			if(comp.selectedObject.data!=null){
				xNS.value = comp.selectedObject.data.x
				yNS.value = comp.selectedObject.data.y
				zNS.value = comp.selectedObject.data.z
			}else{
				reset();
			}
		}
		
		public function saveObject():void
		{
			comp.selectedObject = getObject()
			comp.callReflash();
		}
	}
}