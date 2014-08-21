package com.editor.d3.view.particle.behaviors.plug.initialColor
{
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.behaviors.plug.initialColor.cell.Beh_initColor_multiplier;
	import com.editor.d3.view.particle.behaviors.plug.initialColor.cell.Beh_initColor_offset;
	import com.sandy.utils.ToolUtils;

	public class Beh_initialColor extends ParticleAttriPlugBase
	{
		public function Beh_initialColor()
		{
			super();
		}
		
		public var tabBar:UITabBarNav;
		public var multV:Beh_initColor_multiplier;
		public var offsetV:Beh_initColor_offset;
		
		override protected function create_init():void
		{
			super.create_init()
			height = 300
			
			var lb:UILabel = new UILabel();
			lb.height = 25;
			lb.text = "需要在material里使用TextureMaterial"
			addChild(lb);
			
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			addChild(tabBar);
			
			multV = new Beh_initColor_multiplier();
			multV.beh_ui = this;
			multV.label = "multiplier"
			tabBar.addChild(multV);
			
			offsetV = new Beh_initColor_offset();
			offsetV.beh_ui = this;
			offsetV.label = "offset"
			tabBar.addChild(offsetV);
			
			tabBar.selectedIndex = 0;
		}
		
		override public function reset():void
		{
			isReseting = true
			multV.reset();
			offsetV.reset();
			isReseting = false;
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			var obj:Object = {};
			obj.id = "CompositeColorValueSubParser"
			obj.data = {};
			if(multV.enabledCB.selected){
				var o:Object = multV.getObject();
				obj.data = ToolUtils.mergeObject(o,obj.data);
			}
			if(offsetV.enabledCB.selected){
				o = offsetV.getObject();
				obj.data = ToolUtils.mergeObject(o,obj.data);
			}
			plusObj.putAttri("color",obj);
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("color") == null){
				reset();
				saveObject();
			}
			
			multV.changeAnim(plusObj.getAttri("color"));
			offsetV.changeAnim(plusObj.getAttri("color"));
		}
		
	}
}