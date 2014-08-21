package com.editor.d3.view.particle.behaviors.plug.colorTween
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.behaviors.plug.colorTween.multiplier.Beh_color_multiplier;
	import com.editor.d3.view.particle.behaviors.plug.colorTween.offset.Beh_color_offset;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ToolUtils;

	public class Beh_colorTween extends ParticleAttriPlugBase
	{
		public function Beh_colorTween()
		{
			super();
		}
		
		public var tabBar:UITabBarNav;
		public var multV:Beh_color_multiplier;
		public var offsetV:Beh_color_offset;
		public var cycleCB:UICheckBox;
		public var numNS:UINumericStepper;
		public var phaseHB:UIHBox;
		public var phaseCB:UICheckBox;
		public var phaseNS:UINumericStepper;
		
		override protected function create_init():void
		{
			super.create_init()
			height = 340
			
			var h:UIHBox = new UIHBox();
			h.percentWidth = 100;
			h.height = 25;
			h.verticalAlignMiddle = true;
			addChild(h);
			
			cycleCB = new UICheckBox();
			cycleCB.label = "cycle"
			cycleCB.width = 60
			cycleCB.addEventListener(ASEvent.CHANGE,cycleCBChange);
			h.addChild(cycleCB);
			
			numNS = new UINumericStepper();
			numNS.minimum = 0;
			numNS.maximum = 1000000;
			numNS.stepSize = .1;
			numNS.enterKeyDown_proxy = enterKeyDown1
			numNS.addEventListener(ASEvent.CHANGE, onValueChange1)
			h.addChild(numNS);
			numNS.width = 70;
						
			phaseHB = new UIHBox();
			phaseHB.width = 160;
			phaseHB.height = 25;
			phaseHB.verticalAlignMiddle = true;
			h.addChild(phaseHB);
			
			phaseCB = new UICheckBox();
			phaseCB.label = "phase"
			phaseCB.width = 60
			phaseCB.addEventListener(ASEvent.CHANGE,phaseCBChange);
			phaseHB.addChild(phaseCB);
			
			phaseNS = new UINumericStepper();
			phaseNS.minimum = 0;
			phaseNS.maximum = 1000000;
			phaseNS.stepSize = .1;
			phaseNS.enterKeyDown_proxy = enterKeyDown1
			phaseNS.addEventListener(ASEvent.CHANGE, onValueChange1)
			phaseHB.addChild(phaseNS);
			phaseNS.width = 70;
						
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			addChild(tabBar);
			
			multV = new Beh_color_multiplier();
			multV.beh_ui = this;
			multV.label = "multiplier"
			tabBar.addChild(multV);
			
			offsetV = new Beh_color_offset();
			offsetV.beh_ui = this;
			offsetV.label = "offset"
			tabBar.addChild(offsetV);
			
			tabBar.selectedIndex = 0;
			reset()
		}
		
		private function enterKeyDown1():void
		{
			saveBeh();
		}
		
		private function onValueChange1(e:ASEvent):void
		{
			saveBeh();	
		}
		
		override public function reset():void
		{
			isReseting = true;
			cycleCB.selected = false;
			numNS.value = 1;
			phaseCB.selected = false;
			phaseNS.value = 1;
			multV.reset();
			offsetV.reset();
			cycleCBChange();
			isReseting = false;
		}
		
		private function cycleCBChange(e:ASEvent=null):void
		{
			phaseHB.mouseChildren = cycleCB.selected;
			phaseHB.mouseEnabled = cycleCB.selected;
			saveBeh();
		}
		
		private function phaseCBChange(e:ASEvent):void
		{
			saveBeh();
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("usesCycle",cycleCB.selected);
			plusObj.putAttri("usesPhase",phaseCB.selected);
			if(cycleCB.selected){
				var obj:Object = {};
				obj.id = "OneDConstValueSubParser"
				obj.data = {};
				obj.data.value = numNS.value;
				plusObj.putAttri("cycleDuration",obj);
			}
			if(phaseCB.selected){
				obj = {};
				obj.id = "OneDConstValueSubParser"
				obj.data = {};
				obj.data.value = numNS.value;
				plusObj.putAttri("cyclePhase",obj);	
			}
			
			var startObj:Object = {};
			startObj.id = "CompositeColorValueSubParser"
			startObj.data = {};
			var haveValue:Boolean=false;
			if(multV.enCB.selected){
				var o:Object = multV.startV.getObject();
				startObj.data = ToolUtils.mergeObject(o,startObj.data)
				haveValue = true
			}
			if(offsetV.enCB.selected){
				o = offsetV.startV.getObject();
				startObj.data = ToolUtils.mergeObject(o,startObj.data)
				haveValue = true
			}
			if(haveValue){
				plusObj.putAttri("startColor",startObj);
			}
			
			haveValue = false
			startObj = {};
			startObj.id = "CompositeColorValueSubParser"
			startObj.data = {};
			if(multV.enCB.selected){
				o = multV.endV.getObject();
				startObj.data = ToolUtils.mergeObject(o,startObj.data)
				haveValue = true
			}
			if(offsetV.enCB.selected){
				o = offsetV.endV.getObject();
				startObj.data = ToolUtils.mergeObject(o,startObj.data)
				haveValue = true
			}
			if(haveValue){
				plusObj.putAttri("endColor",startObj);
			}
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("usesCycle") == null){
				reset();
				saveObject();
			}
			
			multV.changeAnim(plusObj);
			offsetV.changeAnim(plusObj);
		}
		
	}
}