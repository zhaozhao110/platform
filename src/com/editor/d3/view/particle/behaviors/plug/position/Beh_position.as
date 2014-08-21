package com.editor.d3.view.particle.behaviors.plug.position
{
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.three.ThreeConstComponent;

	public class Beh_position extends ParticleAttriPlugBase
	{
		public function Beh_position()
		{
			super();
		}
		
		public var startTimeOne:ThreeConstComponent;
		
		override protected function create_init():void
		{
			super.create_init();
			
			startTimeOne = new ThreeConstComponent();
			startTimeOne.label = "position"
			startTimeOne.reflash_f = _save;
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
			
			startTimeOne.cb.selectedIndex = 1;
			startTimeOne.compositeCell.xOne.cb.selectedIndex = 1
			startTimeOne.compositeCell.yOne.cb.selectedIndex = 1
			startTimeOne.compositeCell.zOne.cb.selectedIndex = 1
			isReseting = false
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("position",startTimeOne.getObject());
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("position") == null){
				reset();
				saveObject()
			}
			
			startTimeOne.behType = plusObj.id;
			startTimeOne.setValue(plusObj.getAttri("position"));
		}
		
		
	}
}