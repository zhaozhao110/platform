package com.editor.d3.view.particle.behaviors.plug.velocity
{
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.three.ThreeConstComponent;
	import com.editor.d3.vo.particle.SubPropObj;

	public class Beh_velocity extends ParticleAttriPlugBase
	{
		public function Beh_velocity()
		{
			super();
		}
		
		public var startTimeOne:ThreeConstComponent;
		
		override protected function create_init():void
		{
			super.create_init();
			
			startTimeOne = new ThreeConstComponent();
			startTimeOne.label = "velocity"
			startTimeOne.reflash_f = _save
			addChild(startTimeOne);
			reset()
		}
		
		private function _save(obj:Object):void
		{
			saveBeh();
		}
		   
		override public function reset():void
		{
			isReseting = true
			startTimeOne.reset();
			
			startTimeOne.cb.selectedIndex = 2;
			Object(startTimeOne.sphereCell.ns1).value = 300
			Object(startTimeOne.sphereCell.ns2).value = 500
			isReseting = false
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("velocity",startTimeOne.getObject());
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
						
			if(plusObj.getAttri("velocity") == null){
				reset();
				saveObject()
			}
			
			startTimeOne.setValue(plusObj.getAttri("velocity"));
		}
		
	}
}