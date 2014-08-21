package com.editor.d3.view.particle.behaviors.plug.colorTween.offset.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;

	public class Beh_color_offset_start extends UIVBox
	{
		public function Beh_color_offset_start()
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
			
			redOne = new OneConstCompent();
			redOne.save_f = saveObject;
			redOne.label = "red:"
			addChild(redOne);
			redOne.minimum = -100000;
			redOne.maximum = 1000000;
			redOne.ns1.stepSize = 1;
			
			greenOne = new OneConstCompent();
			greenOne.save_f = saveObject;
			greenOne.label = "green:"
			addChild(greenOne);
			greenOne.minimum = -100000;
			greenOne.maximum = 1000000
			greenOne.ns1.stepSize = 1;
			
			blueOne = new OneConstCompent();
			blueOne.save_f = saveObject;
			blueOne.label = "blue:"
			addChild(blueOne);
			blueOne.minimum = -1000000
			blueOne.maximum = 1000000
			blueOne.ns1.stepSize = 1;
			
			alphaOne = new OneConstCompent();
			alphaOne.save_f = saveObject;
			alphaOne.label = "alpha:"
			addChild(alphaOne);
			alphaOne.minimum = -1000000
			alphaOne.maximum = 1000000
			alphaOne.ns1.stepSize = 1;
			
			reset();
		}
		
		public var beh_ui:ParticleAttriPlugBase;
		private var isReseting:Boolean;
		override public function reset():void
		{
			isReseting = true;
			redOne.reset();
			redOne.ns1.value = 0;
			greenOne.reset();
			greenOne.ns1.value = 0;
			blueOne.reset();
			blueOne.ns1.value = 0;
			alphaOne.reset();
			alphaOne.ns1.value = 0;
			isReseting = false;
		}
		
		private function saveObject():void
		{
			if(isReseting) return ;
			if(beh_ui!=null)beh_ui.saveBeh();
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.redOffsetValue = redOne.getCurrObject();
			obj.blueOffsetValue = blueOne.getCurrObject();
			obj.greenOffsetValue = greenOne.getCurrObject();
			obj.alphaOffsetValue = alphaOne.getCurrObject();
			return obj;
		}
		
		public function changeAnim(obj:Object):void
		{
			redOne.selectedObject = obj;
			redOne.key = "redOffsetValue"
			redOne.changeAnim();
			
			greenOne.selectedObject = obj;
			greenOne.key = "blueOffsetValue"
			greenOne.changeAnim();
			
			blueOne.selectedObject = obj;
			blueOne.key = "greenOffsetValue"
			blueOne.changeAnim();
			
			alphaOne.selectedObject = obj;
			alphaOne.key = "alphaOffsetValue"
			alphaOne.changeAnim();
		}
		
		
	}
}