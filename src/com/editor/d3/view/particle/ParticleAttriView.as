package com.editor.d3.view.particle
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.view.particle.anim.ParticleAttri_anim;
	import com.editor.d3.view.particle.behaviors.ParticleAttri_beh;
	import com.editor.d3.view.particle.prop.ParticleAttri_prop;
	import com.editor.d3.vo.particle.ParticleAnimationObj;
	import com.editor.manager.DataManager;

	public class ParticleAttriView extends UICanvas
	{
		public function ParticleAttriView()
		{
			super();
			create_init()
		}
		
		public var tabBar:UITabBarNav;
		public var anim:ParticleAttri_anim;
		public var prop:ParticleAttri_prop;
		public var beh:ParticleAttri_beh;
		public var infoTxt:UILabel;
		public var infoTxt2:UILabel;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			padding = 2;
			
			var v:UIVBox = new UIVBox();
			v.padding = 2;
			//v.paddingRight = 2;
			v.enabledPercentSize = true;
			addChild(v);
			
			infoTxt2 = new UILabel();
			v.addChild(infoTxt2);
			
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth = 100;
			h.verticalAlignMiddle = true;
			v.addChild(h);
			
			infoTxt = new UILabel();
			//infoTxt.text = "123123123";
			h.addChild(infoTxt);
			
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			tabBar.y = 1;
			tabBar.tabHeight = 25;
			v.addChild(tabBar);
			 
			anim = new ParticleAttri_anim();
			anim.label = "animations"
			tabBar.addChild(anim);
			
			prop = new ParticleAttri_prop();
			prop.label = "properties"
			tabBar.addChild(prop);
			
			beh = new ParticleAttri_beh();
			beh.label = "behaviors"
			tabBar.addChild(beh);
			
			tabBar.selectedIndex = 0;
		}
		
		public function changeAnim():void
		{
			prop.changeAnim();
			beh.changeAnim();
		}
	}
}