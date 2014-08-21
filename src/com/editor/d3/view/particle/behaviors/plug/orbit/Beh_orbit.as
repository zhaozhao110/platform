package com.editor.d3.view.particle.behaviors.plug.orbit
{
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.comp.OneConstCompent;
	import com.editor.d3.view.particle.comp.OneConstCompent2;
	import com.editor.d3.view.particle.comp.ThreeInputComponent;

	public class Beh_orbit extends ParticleAttriPlugBase
	{
		public function Beh_orbit()
		{
			super();
		}
		
		public var radius:OneConstCompent;
		public var phaseOne:OneConstCompent2;
		public var durationOne:OneConstCompent2;
		public var eulersOne:ThreeInputComponent;
		
		override protected function create_init():void
		{
			super.create_init()
			height = 250;
			
			radius = new OneConstCompent();
			radius.save_f = saveBeh;
			radius.label = "radius"
			addChild(radius);
						
			durationOne = new OneConstCompent2();
			durationOne.save_f = saveBeh;
			durationOne.label = "duration"
			addChild(durationOne);
						
			phaseOne = new OneConstCompent2();
			phaseOne.save_f = saveBeh;
			phaseOne.label = "phase"
			addChild(phaseOne);
						
			eulersOne = new ThreeInputComponent();
			eulersOne.save_f = saveBeh;
			eulersOne.label = "eulers"
			addChild(eulersOne);
			
			reset();
		}
		
		override public function reset():void
		{
			isReseting = true;
			radius.reset();
			radius.cb.selectedIndex = 1;
			radius.ns2.value = 200;
			radius.ns3.value = 300
			durationOne.reset();
			durationOne.enabledCB.selected = true;
			durationOne.cb.selectedIndex = 0;
			phaseOne.reset();
			phaseOne.enabledCB.selected = false;
			phaseOne.cb.selectedIndex = 0;
			eulersOne.reset();
			isReseting = false;
		}
		
		override public function saveObject():void
		{
			if(isReseting) return ;
			plusObj.clear();
			plusObj.putAttri("usesCycle",durationOne.enabledCB.selected);
			plusObj.putAttri("usesPhase",phaseOne.enabledCB.selected);
			var obj:Object = {};
			obj.id = "FourDCompositeWithOneDValueSubParser"
			obj.data = {};
			obj.data.x = radius.getCurrObject();
			if(durationOne.enabledCB.selected){
				obj.data.y = durationOne.getCurrObject();
			}
			if(phaseOne.enabledCB.selected){
				obj.data.z = phaseOne.getCurrObject();
			}
			plusObj.putAttri("orbit",obj);
			if(eulersOne.enabledCB.selected){
				plusObj.putAttri("eulers",eulersOne.getObject());
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
				saveObject()
			}
			
			durationOne.enabledCB.selected = plusObj.getAttri("usesCycle")
			phaseOne.enabledCB.selected = plusObj.getAttri("usesPhase")
				
			radius.selectedObject = plusObj.getAttri("orbit")
			radius.key = "x"
			radius.changeAnim();
			
			durationOne.selectedObject = plusObj.getAttri("orbit")
			durationOne.key = "y"
			durationOne.changeAnim();
			
			phaseOne.selectedObject = plusObj.getAttri("orbit")
			phaseOne.key = "z"
			phaseOne.changeAnim();
			
			eulersOne.selectedObject = plusObj.getAttri("eulers")
			if(eulersOne.selectedObject != null){
				eulersOne.enabledCB.selected = true;
				eulersOne.changeAnim();
			}else{
				eulersOne.enabledCB.selected = false
				eulersOne.reset();
			}
		}
		
		
	}
}