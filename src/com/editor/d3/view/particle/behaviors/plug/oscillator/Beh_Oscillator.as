package com.editor.d3.view.particle.behaviors.plug.oscillator
{
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;
	import com.editor.d3.view.particle.comp.three.ThreeConstComponent;

	public class Beh_Oscillator extends ParticleAttriPlugBase
	{
		public function Beh_Oscillator()
		{
			super();
		}
		
		public var axis:ThreeConstComponent;
		public var durationOne:OneConstCompent;
		
		override protected function create_init():void
		{
			super.create_init()
			height = 330;
			
			axis = new ThreeConstComponent();
			axis.reflash_f = saveObject2
			axis.label = "offset"
			addChild(axis);
						
			durationOne = new OneConstCompent();
			durationOne.save_f = saveObject2;
			durationOne.label = "duration"
			addChild(durationOne);
			
			reset();
		}
		
		private function saveObject2(obj:*=null):void
		{
			saveBeh();
		}
		
		override public function reset():void
		{
			isReseting = true;
			axis.reset();
			axis.cb.selectedIndex = 2;
			axis.sphereCell.ns2.value = 100;
			durationOne.reset();
			durationOne.cb.selectedIndex = 0;
			isReseting = false;
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			var obj:Object = {};
			obj.id = "FourDCompositeWithThreeDValueSubParser"
			obj.data = {};
			obj.data.x = axis.getObject();
			obj.data.w = durationOne.getCurrObject();
			plusObj.putAttri("oscillator",obj);
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("oscillator") == null){
				reset();
				saveObject()
			}
			
			axis.setValue(plusObj.getAttri("oscillator").data.x);
			
			durationOne.selectedObject = plusObj.getAttri("oscillator")
			durationOne.key = "w"
			durationOne.changeAnim();
		}
		
		
	}
}