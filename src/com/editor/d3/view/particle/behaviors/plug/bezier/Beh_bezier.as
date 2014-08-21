package com.editor.d3.view.particle.behaviors.plug.bezier
{
	import com.editor.component.controls.UILabel;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.three.ThreeConstComponent;

	public class Beh_bezier extends ParticleAttriPlugBase
	{
		public function Beh_bezier()
		{
			super();
		}
		
		public var axis:ThreeConstComponent;
		public var durationOne:ThreeConstComponent;
		
		override protected function create_init():void
		{
			super.create_init()
			height = 500;
			
			var lb:UILabel = new UILabel();
			lb.height = 22;
			lb.text = "时间动作里的duration必须打勾";
			addChild(lb);
			
			axis = new ThreeConstComponent();
			axis.reflash_f = saveObject2;
			axis.label = "end point"
			addChild(axis);
						
			durationOne = new ThreeConstComponent();
			durationOne.reflash_f = saveObject2;
			durationOne.label = "control point"
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
			axis.cb.selectedIndex = 0
			durationOne.reset();
			durationOne.cb.selectedIndex = 2;
			isReseting = false
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("control",axis.getObject());
			plusObj.putAttri("end",durationOne.getObject());
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("control") == null){
				reset();
				saveObject()
			}
			
			axis.setValue(plusObj.getAttri("control"));
			durationOne.setValue(plusObj.getAttri("end"));
		}
		
		
	}
}