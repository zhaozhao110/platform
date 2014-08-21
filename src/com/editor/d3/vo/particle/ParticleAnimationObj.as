package com.editor.d3.vo.particle
{
	import com.editor.d3.view.particle.behaviors.ParticleBehCache;
	import com.editor.d3.vo.particle.sub.InstanceDataObj;
	import com.editor.d3.vo.particle.sub.InstancePropertyObj;
	import com.sandy.common.lang.ClassUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;

	public class ParticleAnimationObj
	{
		public function ParticleAnimationObj()
		{
			
		}
		
		public var embed:Boolean = true;
		public var property:InstancePropertyObj = new InstancePropertyObj();
		
		public var enabled:Boolean = true;
		public var index:int;
		public var name:String;
		
		public function get particles():int
		{
			return data.geometry.assembler.data.num;
		}
		public function get behaviors():int
		{
			if(data.behaviors_ls == null) return 0;
			return data.behaviors_ls.length;
		}
		
		public var data:InstanceDataObj = new InstanceDataObj();
						
		public function getObject(force:Boolean=false):Object
		{
			if(!force){
				if(!enabled) return null;
			}
			
			var obj:Object = {};
			obj.embed = embed;
			obj.property = property.getObject();
			obj.data = data.getObject2(force);
			if(obj.data == null){
				obj.data = {};
			}
			obj.data.name = name;
			return obj;
		}
		
		public var orginiObj:Object;
		
		public function parser(obj:Object):void
		{
			orginiObj = ToolUtils.originalClone(obj);
			embed = obj.embed;
			if(!StringTWLUtil.isWhitespace(obj.data.name)){
				name = obj.data.name;
			}
			if(obj.property!=null){
				property.parser(obj.property);
			}
			if(obj.data!=null){
				data.parser(obj.data);
			}
		}
		
		
		
	}
}