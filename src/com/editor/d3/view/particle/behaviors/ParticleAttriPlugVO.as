package com.editor.d3.view.particle.behaviors
{
	import com.editor.d3.vo.particle.SubPropObj;

	public class ParticleAttriPlugVO extends SubPropObj
	{
		public function ParticleAttriPlugVO(obj:Object = null)
		{
			super();
			if(obj == null) return ;
			
			name = obj.label;
			index = obj.i;
			id = obj.data;
		}
				
		
	}
}