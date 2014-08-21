package com.editor.d3.vo.particle.sub
{
	import com.editor.d3.view.particle.behaviors.ParticleBehCache;
	import com.editor.d3.vo.particle.SubPropObj;

	public class InstanceDataObj extends SubPropObj
	{
		public function InstanceDataObj()
		{
			material.id = "ColorMaterialSubParser"
			material.putAttri("alpha",1);
			material.putAttri("color",16711680);
			material.putAttri("blendMode","normal");
			material.putAttri("bothSide",false);
			
			globalValues = new SubPropObj();
			globalValues.id = "LuaGeneratorSubParser"
			globalValues.putAttri("code","");
			globalValues.enabled = false;
		}
		
		public static var isReseting:Boolean;		
		
		public var shareAnimationGeometry:Boolean = true;
		public var bounds:Number = 100;
		
		public var geometry:GeometryObj = new GeometryObj();
		public var material:SubPropObj = new SubPropObj();
		public var globalValues:SubPropObj;
		public var behaviors_obj:ParticleBehCache = new ParticleBehCache();
		public var behaviors_ls:Array;
		public var enabledChange:Boolean;
		
		override public function getObject():Object
		{
			return getObject2();
		}
		
		public function getObject2(force:Boolean=false):Object
		{
			var obj:Object = super.getObject();
			obj.shareAnimationGeometry = shareAnimationGeometry;
			obj.bounds = bounds;
			obj.geometry = geometry.getObject(); 
			obj.material = material.getObject();
			obj.globalValues = [globalValues.getObject()];
			if(enabledChange){
				obj.nodes = behaviors_obj.saveObject()
			}else{
				obj.nodes = behaviors_ls;
			}
			return obj;	
		}
		
		override public function parser(obj:Object):void
		{
			shareAnimationGeometry = obj.shareAnimationGeometry
			bounds = obj.bounds
			geometry.parser(obj.geometry);
			material.parser(obj.material);
			if(obj.globalValues!=null){
				globalValues.parser(obj.globalValues[0]);
			}
			behaviors_ls = obj.nodes;
		}
		
		public function reflashBehObj(key:String,obj:Object):void
		{
			if(behaviors_ls == null) return ;
			if(isReseting) return ;
			for(var i:int=0;i<behaviors_ls.length;i++){
				if(Object(behaviors_ls[i]).id == key){
					behaviors_ls[i] = obj;
					break;
				}
			}
		}
		
		public function delBehObj(key:String):void
		{
			if(behaviors_ls == null) return ;
			for(var i:int=0;i<behaviors_ls.length;i++){
				if(Object(behaviors_ls[i]).id == key){
					behaviors_ls.splice(i,1);
					behaviors_obj.delBehObj(key);
					break;
				}
			}
		}
		
		public function saveAllBeh():void
		{
			if(isReseting) return ;
			behaviors_ls = behaviors_obj.saveObject();
		}
		
	}	
}