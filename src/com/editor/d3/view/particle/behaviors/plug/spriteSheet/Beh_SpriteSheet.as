package com.editor.d3.view.particle.behaviors.plug.spriteSheet
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.expand.UINumericStepperWidthLabel;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent2;
	import com.sandy.asComponent.event.ASEvent;

	public class Beh_SpriteSheet extends ParticleAttriPlugBase
	{
		public function Beh_SpriteSheet()
		{
			super();
		}
		
		public var rowsNS:UINumericStepperWidthLabel
		public var colNS:UINumericStepperWidthLabel
		public var totalCB:UICheckBox
		public var totalNS:UINumericStepper
		public var phaseOne:OneConstCompent2;
		public var durationOne:OneConstCompent2;
		
		override protected function create_init():void
		{
			super.create_init()
			
			var lb:UILabel = new UILabel();
			lb.height = 25;
			lb.text = "需要在material里使用TextureMaterial"
			addChild(lb);
				
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			h.horizontalGap = 5;
			addChild(h);
			
			rowsNS = new UINumericStepperWidthLabel();
			rowsNS.label = "rows:"
			rowsNS.enterKeyDown_proxy = enterKeyDown1
			rowsNS.addEventListener(ASEvent.CHANGE, onValueChange1)
			rowsNS.width = 100;
			rowsNS.minimum = 1;
			rowsNS.maximum = 1000000;
			rowsNS.stepSize = 1;
			h.addChild(rowsNS);
			
			colNS = new UINumericStepperWidthLabel();
			colNS.label = "columns:"
			colNS.enterKeyDown_proxy = enterKeyDown1
			colNS.addEventListener(ASEvent.CHANGE, onValueChange1)
			colNS.width = 100;
			colNS.minimum = 1;
			colNS.maximum = 1000000;
			colNS.stepSize = 1
			h.addChild(colNS);
			
			h = new UIHBox();
			h.height = 25;
			h.percentWidth =100;
			h.verticalAlignMiddle = true;
			h.horizontalGap = 5;
			addChild(h);
			
			totalCB = new UICheckBox();
			totalCB.label = "total:"
			totalCB.addEventListener(ASEvent.CHANGE,onCBChange);
			h.addChild(totalCB);
			
			totalNS = new UINumericStepper();
			totalNS.enterKeyDown_proxy = enterKeyDown1
			totalNS.addEventListener(ASEvent.CHANGE, onValueChange1)
			totalNS.width = 100;
			totalNS.minimum = 1;
			totalNS.maximum = 1000000;
			totalNS.stepSize = 1
			h.addChild(totalNS);
			
			durationOne = new OneConstCompent2();
			durationOne.save_f = saveBeh;
			durationOne.label = "duration"
			addChild(durationOne);
						
			phaseOne = new OneConstCompent2();
			phaseOne.save_f = saveBeh;
			phaseOne.label = "phase"
			addChild(phaseOne);
			
			reset();
		}
		
		override public function reset():void
		{
			isReseting = true
			rowsNS.value = 1;
			colNS.value = 4;
			totalCB.selected = false;
			totalNS.value = 999;
			onCBChange()
			durationOne.reset();
			durationOne.enabledCB.selected = true;
			durationOne.cb.selectedIndex = 0;
			phaseOne.reset();
			phaseOne.enabledCB.selected = false;
			phaseOne.cb.selectedIndex = 0;
			isReseting = false
		}
		
		private function onCBChange(e:ASEvent=null):void
		{
			if(totalCB.selected){
				totalNS.alpha = 1;
			}else{
				totalNS.alpha = .5;
			}
			saveBeh();
		}
		
		private function enterKeyDown1():void
		{
			saveBeh();
		}
		
		private function onValueChange1(e:ASEvent):void
		{
			saveBeh();
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("numColumns",colNS.value);
			plusObj.putAttri("numRows",rowsNS.value);
			if(totalCB.selected){
				plusObj.putAttri("total",totalNS.value);
			}
			plusObj.putAttri("usesCycle",durationOne.enabledCB.selected);
			plusObj.putAttri("usesPhase",phaseOne.enabledCB.selected);
			var obj:Object = {};
			obj.id = "FourDCompositeWithOneDValueSubParser"
			obj.data = {};
			if(durationOne.enabledCB.selected){
				obj.data.x = durationOne.getCurrObject();
			}
			if(phaseOne.enabledCB.selected){
				obj.data.y = phaseOne.getCurrObject();
			}
			plusObj.putAttri("scale",obj);
		}
		
		override public function parserObject(obj:Object):void
		{
			super.parserObject(obj);
			changeAnim()
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			
			if(plusObj.getAttri("scale") == null){
				reset();
				saveObject()
			}
			
			durationOne.enabledCB.selected = plusObj.getAttri("usesCycle")
			phaseOne.enabledCB.selected = plusObj.getAttri("usesPhase")
			colNS.value = plusObj.getAttri("numColumns");
			rowsNS.value = plusObj.getAttri("numRows");
			
			if(plusObj.checkAttri("total")){
				totalNS.value = plusObj.getAttri("total");
				totalCB.enabled = true
			}else{
				totalCB.enabled = false;
			}
			
			durationOne.selectedObject = plusObj.getAttri("scale")
			durationOne.key = "x"
			durationOne.changeAnim();
			
			phaseOne.selectedObject = plusObj.getAttri("scale")
			phaseOne.key = "y"
			phaseOne.changeAnim();
		}
		
		
	}
}