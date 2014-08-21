package com.editor.d3.view.particle.behaviors.plug.segmentedScale.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugBase;
	import com.editor.d3.view.particle.behaviors.ParticleAttriPlugVO;
	import com.editor.d3.view.particle.comp.ThreeInputComponent;
	import com.editor.d3.view.particle.comp.ThreeInputComponent2;

	public class Beh_segScale_start extends UIVBox
	{ 
		public function Beh_segScale_start()
		{
			super();
			
			styleName = "uicanvas"
			padding = 5
			enabledPercentSize = true;
			
			input = new ThreeInputComponent2();
			input.save_f = saveObject;
			addChild(input);
			
			reset()
		}
		
		private function saveObject():void
		{
			if(isReseting) return ;
			if(beh_ui!=null) beh_ui.saveBeh()
		}
		
		public var input:ThreeInputComponent2;
		public var type:String;
		public var beh_ui:ParticleAttriPlugBase;
		
		public function getObject():Object
		{
			return input.getObject();
		}
				
		public function changeAnim(obj:ParticleAttriPlugVO):void
		{
			if(type == "start"){
				input.selectedObject = obj.getAttri("startScale");
				input.changeAnim();
			}else if(type == "end"){
				input.selectedObject = obj.getAttri("endScale");
				input.changeAnim();
			}
		}	
		
		public var isReseting:Boolean;
		
		override public function reset():void
		{
			isReseting = true
			input.reset();
			isReseting = false;
		}
	}
}