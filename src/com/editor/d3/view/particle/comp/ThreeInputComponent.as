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

	public class ThreeInputComponent extends UIVBox
	{
		public function ThreeInputComponent()
		{
			super();
			create_init();
		}
		
		override public function set label(value:String):void
		{
			super.label = value;
			if(enabledCB!=null) enabledCB.label = value;
		}
		
		public var xInput:UINumericStepperWidthLabel;
		public var yInput:UINumericStepperWidthLabel;
		public var zInput:UINumericStepperWidthLabel;
		public var enabledCB:UICheckBox;
		public var enabledChange_f:Function;
		
		private function create_init():void
		{
			percentWidth = 100;
			height = 90;
				
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			enabledCB = new UICheckBox();
			enabledCB.label = " "
			enabledCB.width = 100;
			enabledCB.addEventListener(ASEvent.CHANGE,onCBChange);
			h.addChild(enabledCB);
			
			xInput = new UINumericStepperWidthLabel();
			xInput.width = 150;
			xInput.label = "x:"
			xInput.minimum = -10000000
			xInput.maximum = 100000;
			xInput.stepSize = .1;
			xInput.enterKeyDown_proxy = enterKeyDown1
			xInput.addEventListener(ASEvent.CHANGE, onValueChange1)
			h.addChild(xInput);
						
			h = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.paddingLeft = enabledCB.width
			h.verticalAlignMiddle = true;
			addChild(h);
			
			yInput = new UINumericStepperWidthLabel();
			yInput.width = 150;
			yInput.label = "y:"
			yInput.minimum = -10000000
			yInput.maximum = 100000;
			yInput.stepSize = .1;
			yInput.enterKeyDown_proxy = enterKeyDown1
			yInput.addEventListener(ASEvent.CHANGE, onValueChange1)
			h.addChild(yInput);
						
			h = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.paddingLeft = enabledCB.width
			h.verticalAlignMiddle = true;
			addChild(h);
			
			zInput = new UINumericStepperWidthLabel();
			zInput.width = 150;
			zInput.label = "z:"
			zInput.minimum = -10000000
			zInput.maximum = 100000;
			zInput.stepSize = .1;
			zInput.enterKeyDown_proxy = enterKeyDown1
			zInput.addEventListener(ASEvent.CHANGE, onValueChange1)
			h.addChild(zInput);
						
			reset()
		}
		
		private function enterKeyDown1():void
		{
			saveObject();
		}
		
		private function onValueChange1(e:ASEvent):void
		{
			saveObject();	
		}
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			enabledCB.selected = false;
			xInput.value = 1;
			yInput.value =1;
			zInput.value = 1;
			onCBChange();
			isReseting = false
		}
		
		private function onCBChange(e:ASEvent=null):void
		{
			if(!isReseting){
				if(enabledChange_f!=null) enabledChange_f(enabledCB.selected);
			}
			mouseChildren = enabledCB.selected
			mouseEnabled = enabledCB.selected;
			saveObject();
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
		
		public function saveObject():void
		{
			if(isReseting) return ;
			if(save_f!=null)save_f();
		}
		
		public function changeAnim():void
		{
			xInput.value = selectedObject.data.x;
			yInput.value = selectedObject.data.y
			zInput.value = selectedObject.data.z;
		}
		
		override protected function setEnabledEffect():void
		{
			
		}
		
		override public function set mouseChildren(value:Boolean):void
		{
			super.mouseChildren = true;
			
			setMouseUI(value);
			if(value){
				setAlphaUI(1)
			}else{
				setAlphaUI(.5)
			}
		}
		
		override public function set mouseEnabled(value:Boolean):void
		{
			super.mouseEnabled = true
			
			setMouseUI(value);
			if(value){
				setAlphaUI(1)
			}else{
				setAlphaUI(.5)
			}
		}
		
		private function setAlphaUI(n:Number):void
		{
			if(xInput!=null)xInput.alpha=n;
			if(yInput!=null)yInput.alpha=n;
			if(zInput!=null)zInput.alpha=n;
		}
		
		private function setMouseUI(v:Boolean):void
		{
			if(xInput!=null){
				xInput.mouseChildren=v;
				xInput.mouseEnabled =v;
			}
			if(yInput!=null){
				yInput.mouseChildren=v;
				yInput.mouseEnabled = v;
			}
			if(zInput!=null){
				zInput.mouseChildren=v;
				zInput.mouseEnabled=v;
			}
		}
		
		
		
		
		
		
		
	}
}