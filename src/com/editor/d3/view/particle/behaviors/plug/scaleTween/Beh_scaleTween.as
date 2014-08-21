package com.editor.d3.view.particle.behaviors.plug.scaleTween
{
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;
	import com.editor.d3.view.particle.comp.OneConstCompent2;

	public class Beh_scaleTween extends ParticleAttriPlugBase
	{
		public function Beh_scaleTween()
		{
			super();
		}
		
		public var startScaleOne:OneConstCompent;
		public var endScaleOne:OneConstCompent;
		public var durationOne:OneConstCompent2;
		public var phaseOne:OneConstCompent2;
		
		override protected function create_init():void
		{
			super.create_init()
			height = 230;
				
			startScaleOne = new OneConstCompent();
			startScaleOne.save_f = saveBeh
			startScaleOne.label = "start scale"
			addChild(startScaleOne);
						
			endScaleOne = new OneConstCompent();
			endScaleOne.save_f = saveBeh
			endScaleOne.label = "end scale"
			addChild(endScaleOne);
						
			durationOne = new OneConstCompent2();
			durationOne.save_f = saveBeh;
			durationOne.label = "duration"
			durationOne.enabledChange_f = durationEnabledChange
			addChild(durationOne);
						
			phaseOne = new OneConstCompent2();
			phaseOne.save_f = saveBeh;
			phaseOne.label = "phase"
			addChild(phaseOne);
			
			reset()
		}
		
		private function durationEnabledChange(b:Boolean):void
		{
			phaseOne.mouseChildren = b;
			phaseOne.mouseEnabled = b;
		}
		
		override public function reset():void
		{
			isReseting = true
			startScaleOne.reset();
			startScaleOne.ns1.value = 1;
			endScaleOne.reset();
			endScaleOne.ns1.value = 1;
			durationOne.reset();
			durationOne.enabledCB.selected = false;
			isReseting = false;
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("usesCycle",durationOne.enabledCB.selected);
			plusObj.putAttri("usesPhase",phaseOne.enabledCB.selected);
			var obj:Object = {};
			obj.id = "FourDCompositeWithOneDValueSubParser";
			obj.data = {};
			obj.data.x = startScaleOne.getCurrObject();
			obj.data.y = endScaleOne.getCurrObject();
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
				
			if(plusObj.getAttri("usesCycle") == null){
				reset();
				saveObject()
			}
			
			durationOne.enabledCB.selected = plusObj.getAttri("usesCycle")
			phaseOne.enabledCB.selected = plusObj.getAttri("usesPhase")
				
			startScaleOne.selectedObject = plusObj.getAttri("scale")
			startScaleOne.key = "x"
			startScaleOne.changeAnim();
			
			endScaleOne.selectedObject = plusObj.getAttri("scale")
			endScaleOne.key = "y"
			endScaleOne.changeAnim();
		}
		
		
	}
}