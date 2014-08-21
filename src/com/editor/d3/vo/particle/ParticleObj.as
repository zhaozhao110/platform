package com.editor.d3.vo.particle
{
	import com.sandy.utils.StringTWLUtil;

	public class ParticleObj 
	{
		public function ParticleObj()
		{
		}
		
		public var animationDatas:Array = [];
		public var particleEvents:Array = []
		public var customParameters:Array = []
		
		public function createAnimationData():ParticleAnimationObj
		{
			var d:ParticleAnimationObj = new ParticleAnimationObj();
			d.index = animationDatas.length + 1;
			d.name = "anim" + d.index;
			animationDatas.push(d);
			return d;
		}
		
		public var currAnimationData:ParticleAnimationObj;
		
		public function getObject(force:Boolean=false):Object
		{
			var obj:Object = {};
			obj.animationDatas = [];
			for(var i:int=0;i<animationDatas.length;i++){
				var o:Object = (animationDatas[i] as ParticleAnimationObj).getObject(force);
				if(o!=null){
					(obj.animationDatas as Array).push(o);
				}
			}
			obj.particleEvents = particleEvents;
			obj.customParameters = customParameters;
			return obj;
		}
		
		public function parser(s:String):void
		{
			if(StringTWLUtil.isWhitespace(s)) return ;
			var obj:Object = JSON.parse(s);
			
			var a:Array = obj.animationDatas;
			for(var i:int=0;i<a.length;i++){
				var o:Object = Object(a[i]);
				var ob:ParticleAnimationObj = createAnimationData();
				ob.parser(o);
			}
		}
		
		public function removeAnim(n:String):void
		{
			for(var i:int=0;i<animationDatas.length;i++){
				if(ParticleAnimationObj(animationDatas[i]).name == n){
					animationDatas.splice(i,1);
					break
				}
			}
		}
		
		public function getAnim(n:String):ParticleAnimationObj
		{
			for(var i:int=0;i<animationDatas.length;i++){
				if(ParticleAnimationObj(animationDatas[i]).name == n){
					return animationDatas[i]
				}
			}
			return null;
		}
		
	}
}