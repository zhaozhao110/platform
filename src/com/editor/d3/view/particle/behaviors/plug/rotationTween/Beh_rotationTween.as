package com.editor.d3.view.particle.behaviors.plug.rotationTween
{
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;
	import com.editor.d3.view.particle.comp.three.ThreeConstComponent;

	public class Beh_rotationTween extends ParticleAttriPlugBase
	{
		public function Beh_rotationTween()
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
			axis.reflash_f = saveObject2;
			axis.label = "axis"
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
			axis.cb.selectedIndex = 0;
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
			plusObj.putAttri("rotation",obj);
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("rotation") == null){
				reset();
				saveObject()
			}
			
			axis.setValue(plusObj.getAttri("rotation").data.x);
			
			durationOne.selectedObject = plusObj.getAttri("rotation")
			durationOne.key = "w"
			durationOne.changeAnim();
		}
		
		
	}
}