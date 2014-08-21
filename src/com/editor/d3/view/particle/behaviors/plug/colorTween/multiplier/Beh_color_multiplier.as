package com.editor.d3.view.particle.behaviors.plug.colorTween.multiplier
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugVO;
	import com.editor.d3.view.particle.behaviors.plug.colorTween.multiplier.cell.Beh_color_mult_start;
	import com.sandy.asComponent.event.ASEvent;

	public class Beh_color_multiplier extends UIVBox
	{
		public function Beh_color_multiplier()
		{
			super();
			create_init();
		}
		
		public var tabBar:UITabBarNav;
		public var startV:Beh_color_mult_start;
		public var endV:Beh_color_mult_start;
		public var enCB:UICheckBox;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			padding = 5
			enabledPercentSize = true;
			
			enCB = new UICheckBox();
			enCB.label = "启用"
			enCB.addEventListener(ASEvent.CHANGE,enCBChange);
			addChild(enCB);
						
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			addChild(tabBar);
			
			startV = new Beh_color_mult_start();
			startV.label = "start multiplier"
			tabBar.addChild(startV);
			
			endV = new Beh_color_mult_start();
			endV.label = "end multiplier"
			tabBar.addChild(endV);
			
			tabBar.selectedIndex = 0
			reset()
		}
		
		public var beh_ui:ParticleAttriPlugBase;
		private var isReseting:Boolean;
		override public function reset():void
		{
			isReseting = true;
			enCB.selected = true
			enCBChange();
			startV.reset();
			endV.reset();
			isReseting = false;
		}
		
		private function enCBChange(e:ASEvent=null):void
		{
			tabBar.mouseChildren = enCB.selected;
			tabBar.mouseEnabled = enCB.selected;
			saveObject()
		}
		
		private function saveObject():void
		{
			if(isReseting) return ;
			if(beh_ui!=null)beh_ui.saveBeh();
		}
		
		public function changeAnim(obj:ParticleAttriPlugVO):void
		{
			startV.beh_ui = beh_ui;
			endV.beh_ui = beh_ui;
			if(obj == null){
				reset()
				return ;
			}
			var o:Object = obj.getAttri("startColor")
			if(o == null){
				enCB.selected = true
			}else{
				enCB.selected = o.data.hasOwnProperty("redMultiplierValue")
			}
			
			startV.changeAnim(obj.getAttri("startColor"));
			endV.changeAnim(obj.getAttri("endColor"));
		}
		
	}
}