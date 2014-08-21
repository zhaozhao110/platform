package com.editor.d3.view.particle.comp
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.expand.UINumericStepperWidthLabel;
	import com.sandy.asComponent.event.ASEvent;

	public class ThreeInputComponent2 extends UIVBox
	{
		public function ThreeInputComponent2()
		{
			super();
			create_init();
		}
		
		public var xInput:UINumericStepperWidthLabel;
		public var yInput:UINumericStepperWidthLabel;
		public var zInput:UINumericStepperWidthLabel;
		
		private function create_init():void
		{
			percentWidth = 100;
			height = 90;
				
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			xInput = new UINumericStepperWidthLabel();
			xInput.enterKeyDown_proxy = enterKeyDown
			xInput.addEventListener(ASEvent.CHANGE, onValueChange)
			xInput.width = 150;
			xInput.label = "x:"
			xInput.minimum = -10000000
			xInput.maximum = 100000;
			xInput.stepSize = .1;
			h.addChild(xInput);
			
			h = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			yInput = new UINumericStepperWidthLabel();
			yInput.enterKeyDown_proxy = enterKeyDown
			yInput.addEventListener(ASEvent.CHANGE, onValueChange)
			yInput.width = 150;
			yInput.label = "y:"
			yInput.minimum = -10000000
			yInput.maximum = 100000;
			yInput.stepSize = .1;
			h.addChild(yInput);
			
			h = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			zInput = new UINumericStepperWidthLabel();
			zInput.enterKeyDown_proxy = enterKeyDown
			zInput.addEventListener(ASEvent.CHANGE, onValueChange)
			zInput.width = 150;
			zInput.label = "z:"
			zInput.minimum = -10000000
			zInput.maximum = 100000;
			zInput.stepSize = .1;
			h.addChild(zInput);
			
			reset()
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "ThreeDConstValueSubParser"
			obj.data = {};
			obj.data.x = xInput.value;
			obj.data.y = yInput.value;
			obj.data.z = zInput.value;
			return obj;
		}
		
		public var selectedObject:Object;
		public var save_f:Function;
		
		public function changeAnim():void
		{
			xInput.value = selectedObject.data.x;
			yInput.value = selectedObject.data.y
			zInput.value = selectedObject.data.z;
		}
		
		private function enterKeyDown():void
		{
			saveObject()
		}
		
		private function onValueChange(e:ASEvent):void
		{
			saveObject()
		}
		
		private function saveObject():void
		{
			if(isReseting) return ;
			if(save_f!=null) save_f();
		}
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			xInput.value = 1;
			yInput.value = 1;
			zInput.value = 1;
			isReseting = false
		}
		
	}
}