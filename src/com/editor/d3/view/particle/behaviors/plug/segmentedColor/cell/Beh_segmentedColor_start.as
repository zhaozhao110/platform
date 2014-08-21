package com.editor.d3.view.particle.behaviors.plug.segmentedColor.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugVO;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.Beh_segmentedColor;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.comp.Beh_segColor_mult;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.comp.Beh_segColor_offset;
	import com.sandy.utils.ToolUtils;

	public class Beh_segmentedColor_start extends UIVBox
	{ 
		public function Beh_segmentedColor_start()
		{
			super();
			
			styleName = "uicanvas"
			padding = 5
			enabledPercentSize = true;
			
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			addChild(tabBar);
			
			multV = new Beh_segColor_mult();
			multV.label = "multiplier"
			tabBar.addChild(multV);
			
			offsetV = new Beh_segColor_offset();
			offsetV.label = "offset"
			tabBar.addChild(offsetV);
			
			tabBar.selectedIndex = 0;
			reset();
		}
		
		public var beh_ui:ParticleAttriPlugBase;
		public var multV:Beh_segColor_mult;
		public var offsetV:Beh_segColor_offset;
		public var tabBar:UITabBarNav;
		public var type:String;
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "CompositeColorValueSubParser"
			obj.data = {};
			obj.data = ToolUtils.mergeObject(multV.getObject(),obj.data);
			obj.data = ToolUtils.mergeObject(offsetV.getObject(),obj.data);
			return obj;
		}
		
		public function changeAnim(obj:ParticleAttriPlugVO):void
		{
			multV.beh_ui = beh_ui;
			offsetV.beh_ui = beh_ui;
			if(type == "start"){
				multV.changeAnim(obj.getAttri("startColor"));
				offsetV.changeAnim(obj.getAttri("startColor"));
			}else if(type == "end"){
				multV.changeAnim(obj.getAttri("endColor"));
				offsetV.changeAnim(obj.getAttri("endColor"));
			}
		}	
		
		override public function reset():void
		{
			multV.reset();
			offsetV.reset();
		}
		
	}
}