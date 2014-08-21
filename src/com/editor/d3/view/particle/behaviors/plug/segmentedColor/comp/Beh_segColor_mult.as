package com.editor.d3.view.particle.behaviors.plug.segmentedColor.comp
{
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;

	public class Beh_segColor_mult extends UIVBox
	{
		public function Beh_segColor_mult()
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
		
		public function saveObject():void
		{
			if(isReseting) return ;
			if(beh_ui!=null)beh_ui.saveBeh();
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.mr = redOne.ns1.value;
			obj.mb = blueOne.ns1.value;
			obj.mg = greenOne.ns1.value;
			obj.ma = alphaOne.ns1.value;
			return obj;
		}
		
		public function changeAnim(obj:Object):void
		{
			redOne.ns1.value = obj.data.mr;
			greenOne.ns1.value = obj.data.mg;
			blueOne.ns1.value = obj.data.mb;
			alphaOne.ns1.value = obj.data.ma;
		}
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			redOne.reset();
			redOne.ns1.value = 1;
			redOne.cb.selectedIndex = 0;
			redOne.cb.mouseChildren = false;
			redOne.cb.mouseEnabled = false;
			
			greenOne.reset();
			greenOne.ns1.value = 1;
			greenOne.cb.selectedIndex = 0;
			greenOne.cb.mouseChildren = false;
			greenOne.cb.mouseEnabled = false;
			
			blueOne.reset();
			blueOne.ns1.value = 1;
			blueOne.cb.selectedIndex = 0;
			blueOne.cb.mouseChildren = false;
			blueOne.cb.mouseEnabled = false;
			
			alphaOne.reset();
			alphaOne.ns1.value = 1;
			alphaOne.cb.selectedIndex = 0;
			alphaOne.cb.mouseChildren = false;
			alphaOne.cb.mouseEnabled = false;
			isReseting = false
		}
		
		
		
	}
}