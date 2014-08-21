package com.editor.d3.view.particle.behaviors.plug.initialColor.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;
	import com.sandy.asComponent.event.ASEvent;

	public class Beh_initColor_multiplier extends UIVBox
	{
		public function Beh_initColor_multiplier()
		{
			super();
			create_init();
		}
		
		public var redOne:OneConstCompent;
		public var greenOne:OneConstCompent;
		public var blueOne:OneConstCompent;
		public var alphaOne:OneConstCompent;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			padding = 5
			enabledPercentSize = true;
			
			addEnabledButton()
			
			redOne = new OneConstCompent();
			redOne.save_f = saveObject;
			redOne.label = "red:"
			addChild(redOne);
			redOne.minimum = 0;
			redOne.maximum = 1;
						
			greenOne = new OneConstCompent();
			greenOne.save_f = saveObject;
			greenOne.label = "green:"
			addChild(greenOne);
			greenOne.minimum = 0;
			greenOne.maximum = 1;
						
			blueOne = new OneConstCompent();
			blueOne.save_f = saveObject;
			blueOne.label = "blue:"
			addChild(blueOne);
			blueOne.minimum = 0;
			blueOne.maximum = 1;
						
			alphaOne = new OneConstCompent();
			alphaOne.save_f = saveObject;
			alphaOne.label = "alpha:"
			addChild(alphaOne);
			alphaOne.minimum = 0;
			alphaOne.maximum = 1;
						
			reset()
		}
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true;
			redOne.reset();
			redOne.ns1.value = 1;
			greenOne.reset();
			greenOne.ns1.value = 1;
			blueOne.reset();
			blueOne.ns1.value = 1;
			alphaOne.reset();
			alphaOne.ns1.value = 1;
			enabledCB.selected = false;
			onCBChange11();
			isReseting = false;
		}
		
		private function saveObject():void
		{
			if(isReseting) return ;
			if(beh_ui!=null)beh_ui.saveBeh();
		}
		
		public var beh_ui:ParticleAttriPlugBase;
		public var enabledCB:UICheckBox;
		protected function addEnabledButton():void
		{
			if(enabledCB == null){
				enabledCB = new UICheckBox();
				enabledCB.label = "启用"
				enabledCB.selected = true;
				enabledCB.addEventListener(ASEvent.CHANGE,onCBChange11);
				addChild(enabledCB);
			}
			enabledCB.selected = false;
		}
		
		private function onCBChange11(e:ASEvent=null):void
		{
			if(redOne == null) return ;
			redOne.mouseChildren = enabledCB.selected;
			redOne.mouseEnabled = enabledCB.selected;
			
			greenOne.mouseChildren = enabledCB.selected;
			greenOne.mouseEnabled = enabledCB.selected;
			
			blueOne.mouseChildren = enabledCB.selected;
			blueOne.mouseEnabled = enabledCB.selected;
			
			alphaOne.mouseChildren = enabledCB.selected;
			alphaOne.mouseEnabled = enabledCB.selected;
			
			saveObject()
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.redMultiplierValue = redOne.getCurrObject();
			obj.blueMultiplierValue = blueOne.getCurrObject();
			obj.greenMultiplierValue = greenOne.getCurrObject();
			obj.alphaMultiplierValue = alphaOne.getCurrObject();
			return obj;
		}
		
		public function changeAnim(obj:Object):void
		{
			enabledCB.selected = Object(obj.data).hasOwnProperty("redMultiplierValue"); 
			
			redOne.selectedObject = obj;
			redOne.key = "redMultiplierValue"
			redOne.changeAnim();
			
			greenOne.selectedObject = obj;
			greenOne.key = "greenMultiplierValue"
			greenOne.changeAnim();
			
			blueOne.selectedObject = obj;
			blueOne.key = "blueMultiplierValue"
			blueOne.changeAnim();
			
			alphaOne.selectedObject = obj;
			alphaOne.key = "alphaMultiplierValue"
			alphaOne.changeAnim();
		}
		
		
	}
}