package com.editor.d3.view.particle.behaviors.plug.segmentedColor.cell
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UIHSlider;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.Beh_segmentedColor;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.comp.Beh_segColor_mult;
	import com.editor.d3.view.particle.behaviors.plug.segmentedColor.comp.Beh_segColor_offset;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ToolUtils;

	public class Beh_segmentedColor_middle extends UIVBox
	{ 
		public function Beh_segmentedColor_middle()
		{
			super();
			
			styleName = "uicanvas"
			padding = 5
			enabledPercentSize = true;
			
			addEnabledButton()
			
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			h.horizontalGap = 15;
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "life value"
			h.addChild(lb);
			
			bar = new UIHSlider();
			bar.width = 150;
			bar.minimum = 0;
			bar.maximum = 1;
			bar.addEventListener(ASEvent.CHANGE,onBarChange);
			h.addChild(bar);
						
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
			reset()
		}
		
		public var beh_ui:ParticleAttriPlugBase;
		public var bar:UIHSlider;
		public var multV:Beh_segColor_mult;
		public var offsetV:Beh_segColor_offset;
		public var tabBar:UITabBarNav;
		public var type:String;
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			bar.value = .5;
			multV.reset();
			offsetV.reset();
			enabledCB.selected = false;
			onCBChange11();
			isReseting = false;
		}
				
		public var enabledCB:UICheckBox;
		protected function addEnabledButton():void
		{
			if(enabledCB == null){
				enabledCB = new UICheckBox();
				enabledCB.label = "启用"
				enabledCB.selected = true;
				enabledCB.addEventListener(ASEvent.CHANGE,onCBChange11);
				addChild(enabledCB);
			}
			enabledCB.selected = false;
		}
		
		private function onCBChange11(e:ASEvent=null):void
		{
			if(multV!=null){
				multV.mouseChildren = enabledCB.selected;
				multV.mouseEnabled = enabledCB.selected
			}
			if(offsetV!=null){
				offsetV.mouseChildren = enabledCB.selected;
				offsetV.mouseEnabled = enabledCB.selected
			}
			saveObject()
		}
		
		private function saveObject():void
		{
			if(isReseting) return ;
			if(beh_ui!=null)beh_ui.saveBeh();
		}
		
		private function onBarChange(e:ASEvent):void
		{
			saveObject()
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.life = bar.value;
			obj.color = {};
			obj.color.id = "CompositeColorValueSubParser"
			obj.color.data = {};
			obj.color.data = ToolUtils.mergeObject(multV.getObject(),obj.color.data);
			obj.color.data = ToolUtils.mergeObject(offsetV.getObject(),obj.color.data);
			return obj;
		}
		
		public function changeAnim(obj:Object):void
		{
			multV.beh_ui = beh_ui;
			offsetV.beh_ui = beh_ui;
			
			if(obj == null){
				reset();
				return ;
			}
			
			enabledCB.selected = true;
			
			bar.value = obj.life;
			multV.changeAnim(obj.color);
			offsetV.changeAnim(obj.color);
		}	
		
	}
}