package com.editor.d3.view.particle.behaviors.plug.segmentedScale.cell
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UIHSlider;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugVO;
	import com.editor.d3.view.particle.comp.ThreeInputComponent;
	import com.editor.d3.view.particle.comp.ThreeInputComponent2;
	import com.sandy.asComponent.event.ASEvent;

	public class Beh_segScale_middle extends UIVBox
	{ 
		public function Beh_segScale_middle()
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
			
			input = new ThreeInputComponent2();
			addChild(input);
			
			reset()
		}
				
		public var beh_ui:ParticleAttriPlugBase;
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			bar.value = .5;
			input.reset();
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
			if(bar!=null){
				bar.mouseChildren = enabledCB.selected;
				bar.mouseEnabled = enabledCB.selected
			}
			if(input!=null){
				input.mouseChildren = enabledCB.selected;
				input.mouseEnabled = enabledCB.selected
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
		
		public var bar:UIHSlider
		public var input:ThreeInputComponent2;
		public var type:String;
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.life = bar.value;
			obj.scale = input.getObject();
			return obj;
		}
		
		public function changeAnim(obj:Object):void
		{
			if(obj == null){
				reset();
				return ;
			}
			
			enabledCB.selected = true;
			
			bar.value = obj.life;
			input.selectedObject = obj.scale;
			input.changeAnim();
		}	
		
		
	}
}