package com.editor.d3.view.particle.behaviors.plug.toHead
{
	import com.editor.component.controls.UILabel;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;

	public class Beh_toHead extends ParticleAttriPlugBase
	{
		public function Beh_toHead()
		{
			super();
		}
		
		override protected function create_init():void
		{
			super.create_init();
			
			var lb:UILabel = new UILabel();
			lb.text = "不需要设置"
			addChild(lb);
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
		}
		
		override public function reset():void
		{
			isReseting =true
			
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
		}
		
		
	}
	
}