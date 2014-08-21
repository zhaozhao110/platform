package com.editor.d3.view.particle
{
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.particle.behaviors.ParticleBehCache;
	import com.editor.d3.vo.particle.ParticleAnimationObj;

	public class ParticleAttriViewBase extends UIVBox
	{
		public function ParticleAttriViewBase()
		{
			super();
			create_init();
		}
		
		protected function create_init():void
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			paddingTop = 5;	
		}
		
		public var comp:D3ObjectParticle;
				
		public function changeComp(c:D3ObjectParticle):void
		{
			comp = c;
		}
		
		public function changeAnim():void
		{
			
		}
		
		protected function get currAnimationData():ParticleAnimationObj
		{
			if(comp == null) return null;
			return comp.configData.particleObj.currAnimationData;
		}
		
		protected function get behaviors_obj():ParticleBehCache
		{
			return currAnimationData.data.behaviors_obj;
		}
	}
}