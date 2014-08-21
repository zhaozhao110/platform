package com.editor.d3.view.particle.behaviors.plug.segmentedColor.comp
{
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;

	public class Beh_segColor_offset extends UIVBox
	{
		public function Beh_segColor_offset()
		{
			super();
			create_init();
		}
		
		public var redOne:OneConstCompent;
		public var greenOne:OneConstCompent;
		public var blueOne:OneConstCompent;
		public var alphaOne:OneConstCompent;
		public var beh_ui:ParticleAttriPlugBase;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			padding = 5
			enabledPercentSize = true;
			
			redOne = new OneConstCompent();
			redOne.label = "red:"
			addChild(redOne);
			redOne.minimum = -100000;
			redOne.maximum = 1000000;
			redOne.ns1.stepSize = 1;
			
			greenOne = new OneConstCompent();
			greenOne.label = "green:"
			addChild(greenOne);
			greenOne.minimum = -100000;
			greenOne.maximum = 1000000
			greenOne.ns1.stepSize = 1;
			
			blueOne = new OneConstCompent();
			blueOne.label = "blue:"
			addChild(blueOne);
			blueOne.minimum = -100000;
			blueOne.maximum = 1000000
			blueOne.ns1.stepSize = 1;
			
			alphaOne = new OneConstCompent();
			alphaOne.label = "alpha:"
			addChild(alphaOne);
			alphaOne.minimum = -100000;
			alphaOne.maximum = 1000000
			alphaOne.ns1.stepSize = 1;
		
			reset()
		}
		
		public function saveObject():void
		{
			if(isReseting) return ;
			if(beh_ui!=null)beh_ui.saveBeh();
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.or = redOne.ns1.value;
			obj.ob = blueOne.ns1.value;
			obj.og = greenOne.ns1.value;
			obj.oa = alphaOne.ns1.value;
			return obj;
		}
		
		public function changeAnim(obj:Object):void
		{
			redOne.ns1.value = obj.data.or;
			greenOne.ns1.value = obj.data.og;
			blueOne.ns1.value = obj.data.ob;
			alphaOne.ns1.value = obj.data.oa;
		}
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			redOne.reset();
			redOne.ns1.value = 0;
			redOne.cb.selectedIndex = 0;
			redOne.cb.mouseChildren = false;
			redOne.cb.mouseEnabled = false;
			
			greenOne.reset();
			greenOne.ns1.value = 0;
			greenOne.cb.selectedIndex = 0;
			greenOne.cb.mouseChildren = false;
			greenOne.cb.mouseEnabled = false;
			
			blueOne.reset();
			blueOne.ns1.value = 0;
			blueOne.cb.selectedIndex = 0;
			blueOne.cb.mouseChildren = false;
			blueOne.cb.mouseEnabled = false;
			
			alphaOne.reset();
			alphaOne.ns1.value = 0;
			alphaOne.cb.selectedIndex = 0;
			alphaOne.cb.mouseChildren = false;
			alphaOne.cb.mouseEnabled = false;
			isReseting = false
		}
	}
}