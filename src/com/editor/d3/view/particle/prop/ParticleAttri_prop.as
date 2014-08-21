package com.editor.d3.view.particle.prop
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.particle.ParticleAttriViewBase;
	import com.editor.d3.view.particle.prop.geometry.PropGeometryCell;
	import com.editor.d3.view.particle.prop.material.PropMaterialCell;
	import com.editor.d3.view.particle.prop.normal.PropNormalCell;

	public class ParticleAttri_prop extends ParticleAttriViewBase
	{
		public function ParticleAttri_prop()
		{
			super();
			
		}
		
		public var tabBar:UITabBarNav;
		public var propNormal:PropNormalCell;
		public var geometry:PropGeometryCell;
		public var material:PropMaterialCell;
		
		override protected function create_init():void
		{
			super.create_init();
			
			tabBar = new UITabBarNav();
			tabBar.tabOffset = 5;
			tabBar.enabledPercentSize = true;
			addChild(tabBar);
			
			propNormal = new PropNormalCell();
			propNormal.label = "normal"
			tabBar.addChild(propNormal);
			
			geometry = new PropGeometryCell();
			geometry.label = "geometry"
			tabBar.addChild(geometry);
			
			material = new PropMaterialCell();
			material.label = "material"
			tabBar.addChild(material);
			
			tabBar.selectedIndex = 0;
		}
		
		override public function changeComp(c:D3ObjectParticle):void
		{
			super.changeComp(c);
			propNormal.changeComp(c);
			geometry.changeComp(c);
			material.changeComp(c);
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			propNormal.changeAnim()
			geometry.changeAnim();
			material.changeAnim();
		}
		
	}
}