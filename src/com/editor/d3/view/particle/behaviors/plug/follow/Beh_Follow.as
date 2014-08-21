package com.editor.d3.view.particle.behaviors.plug.follow
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.sandy.asComponent.event.ASEvent;

	public class Beh_Follow extends ParticleAttriPlugBase
	{
		public function Beh_Follow()
		{
			super();
		}
		
		public var posCB:UICheckBox;
		public var ratCB:UICheckBox;
		
		override protected function create_init():void
		{
			super.create_init();
			
			var lb:UILabel = new UILabel();
			lb.height = 22;
			lb.text = "在时间动作里如果打勾loop,请delay也要打勾"
			addChild(lb);
			
			posCB = new UICheckBox();
			posCB.label = "position"
			posCB.addEventListener(ASEvent.CHANGE,onCBChange);
			addChild(posCB);
			
			ratCB = new UICheckBox();
			ratCB.label = "rotation"
			ratCB.addEventListener(ASEvent.CHANGE,onCBChange);
			addChild(ratCB);
		}
		
		private function onCBChange(e:ASEvent):void
		{
			saveBeh();
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("usesRotation",ratCB.selected);
			plusObj.putAttri("usesPosition",posCB.selected);
		}
		
		override public function reset():void
		{
			isReseting =true
			posCB.selected=false;
			ratCB.selected=false
			isReseting = false;
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("usesRotation") == null){
				reset();
				saveObject();
			}
			
			posCB.selected = plusObj.getAttri("usesPosition")
			ratCB.selected = plusObj.getAttri("usesRotation")
		}
		
		
	}
	
}