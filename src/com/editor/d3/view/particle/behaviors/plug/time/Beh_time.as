package com.editor.d3.view.particle.behaviors.plug.time
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;
	import com.editor.d3.view.particle.comp.OneConstCompent2;

	public class Beh_time extends ParticleAttriPlugBase
	{
		public function Beh_time()
		{
			super();
		}
		
		public var startTimeOne:OneConstCompent;
		public var durationOne:OneConstCompent2;
		public var loopCB:UICheckBox;
		public var delayOne:OneConstCompent2;
		
		override protected function addEnabledButton():void{}
		override protected function addDelButton():void{};
		
		override public function get enabled2():Boolean
		{
			return true;
		}
		
		override protected function create_init():void
		{
			super.create_init();
				
			startTimeOne = new OneConstCompent();
			startTimeOne.label = "startTime"
			addChild(startTimeOne);
			startTimeOne.save_f = saveBeh;
									
			durationOne = new OneConstCompent2();
			durationOne.label = "duration"
			addChild(durationOne);
			durationOne.enabledChange_f = setDurationEnabled
			durationOne.save_f = saveBeh;
			
			loopCB = new UICheckBox();
			loopCB.label = "loop"
			addChild(loopCB);
			
			delayOne = new OneConstCompent2();
			delayOne.label = "delay"
			addChild(delayOne);
			delayOne.save_f = saveBeh;
			
			reset();
		}
				
		public function setDurationEnabled(value:Boolean):void
		{
			durationOne.mouseChildren = value;
			durationOne.mouseEnabled = value;
			loopCB.mouseChildren = value;
			loopCB.mouseEnabled = value;
			delayOne.mouseChildren = value;
			delayOne.mouseEnabled = value;
		}
		
		override public function reset():void
		{
			isReseting = true
			startTimeOne.reset();
			startTimeOne.cb.selectedIndex =1;
			durationOne.reset();
			durationOne.cb.selectedIndex =1;
			loopCB.selected = true;
			delayOne.reset();
			delayOne.mouseChildren = false;
			delayOne.mouseEnabled = false;
			durationOne.enabledCB.selected = true;
			isReseting = false
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("startTime",startTimeOne.getCurrObject());
			plusObj.putAttri("usesLooping",loopCB.selected)
			plusObj.putAttri("usesDuration",durationOne.enabledCB.selected)
			if(durationOne.enabledCB.selected){
				plusObj.putAttri("duration",durationOne.getCurrObject());
			}
			plusObj.putAttri("usesDelay",delayOne.enabledCB.selected)
			if(delayOne.enabledCB.selected){
				plusObj.putAttri("delay",delayOne.getCurrObject());
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
			
			if(plusObj.getAttri("startTime") == null){
				reset()
				saveObject()
			}
			//isReseting = true
			loopCB.selected = plusObj.getAttri("usesLooping");
			durationOne.enabledCB.selected = plusObj.getAttri("usesDuration");
			delayOne.enabledCB.selected = plusObj.getAttri("usesDelay");
						
			startTimeOne.selectedObject = plusObj;
			startTimeOne.key = "startTime"
			startTimeOne.changeAnim();
			
			durationOne.selectedObject = plusObj;
			durationOne.key = "duration"
			durationOne.changeAnim();
			
			delayOne.selectedObject = plusObj;
			delayOne.key = "delay"
			delayOne.changeAnim();
			//isReseting = false
		}
		
	}
}