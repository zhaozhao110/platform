package com.editor.d3.process
{
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.controllers.FirstPersonController;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.EnvMapMethod;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.FresnelSpecularMethod;
	import away3d.materials.methods.SimpleWaterNormalMethod;
	import away3d.textures.CubeTextureBase;
	import away3d.textures.Texture2DBase;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectCamera;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.D3ObjectTexture;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	
	import flash.filesystem.File;

	public class D3ProccessMethod extends D3CompProcessBase
	{
		public function D3ProccessMethod(d:D3ObjectMethod)
		{
			super(d);
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			saveAttri(d,dd);
		}
		
		override protected function saveAttri(d:ID3ComBase,v:D3ComBaseVO):void
		{
			super.saveAttri(d,v);
			
			if(d.item.id == 101){
				//envMap
				D3ObjectMethod(comp).removeMethodToMaterial();
				methodBase = create_EnvMapMethod();
				D3Object(D3ObjectMethod(comp).parentObject).reflashAllMethod();
				return ;
			}
			
			if(d.item.id == 15 || d.item.id == 103){
				D3ObjectMethod(comp).removeMethodToMaterial();
				methodBase = create_SimpleWaterNormalMethod();
				if(comp.parentObject == null) return ;
				if(comp.parentObject is D3Object){
					D3Object(comp.parentObject).reflashAllMethod();
				}
				return ;
			}
			
			if(methodBase&&methodBase.hasOwnProperty(d.key)){
				methodBase[d.key] = v.data;
			}
			
			reflashMethod(d.key);
		}
		
		override public function reflashMethod(k:String,v:D3ProccessMethod=null):void
		{
			comp.parentObject.proccess.reflashMethod(k,this);
		}
		
		
		
		
		/////////////////////////////////////////////////////////////////
		
		public var methodBase:*;
		
		public function getMethod():*
		{
			if(methodBase!=null){
				//_reflashMethodAttri(methodBase);
				return methodBase;
			}
			if(comp.compItem.id == 9){
				methodBase = create_FogMethod();
			}else if(comp.compItem.id == 8){
				methodBase = create_EnvMapMethod();
			}else if(comp.compItem.id == 6){
				methodBase = create_SimpleWaterNormalMethod();
			}else if(comp.compItem.id == 7){
				methodBase = create_FresnelSpecularMethod();
			}if(comp.compItem.id == 11){
				methodBase = create_PerspectiveLens();
			}else if(comp.compItem.id == 12){
				methodBase = create_OrthographicLens();
			}else if(comp.compItem.id == 13){
				methodBase = create_FirstPersonController();
			}
			if(methodBase)methodBase.data = comp;
			return methodBase;
		}
		
		private function create_FirstPersonController():FirstPersonController
		{
			var f:FirstPersonController = new FirstPersonController();
			_reflashMethodAttri(f);
			return f;
		}
		
		private function create_FresnelSpecularMethod():FresnelSpecularMethod
		{
			var m:FresnelSpecularMethod = new FresnelSpecularMethod();
			_reflashMethodAttri(m);
			return m;
		}
		
		private function create_SimpleWaterNormalMethod():SimpleWaterNormalMethod
		{
			if(comp.configData.checkAttri("normalMap") && comp.configData.checkAttri("secondaryNormalMap")){
				var normalMap:Texture2DBase = create_Texture2DBase("normalMap");
				if(normalMap == null) return null;
				var secondaryNormalMap:Texture2DBase = create_Texture2DBase("secondaryNormalMap");
				if(secondaryNormalMap == null) return null;
				var m:SimpleWaterNormalMethod = new SimpleWaterNormalMethod(normalMap,secondaryNormalMap);
				_reflashMethodAttri(m);
				return m;
			}
			return null;
		}
		
		private function create_EnvMapMethod():EnvMapMethod
		{
			if(comp.configData.checkAttri("envMap")){
				var cube:CubeTextureBase = create_CubeTextureBase();
				if(cube){
					var m:EnvMapMethod = new EnvMapMethod(cube);
					_reflashMethodAttri(m);
					return m;
				}
			}
			return null;
		}
		
		private function create_FogMethod():FogMethod
		{
			var m:FogMethod = new FogMethod();
			_reflashMethodAttri(m);
			return m;
		}
		
		private function _reflashMethodAttri(e:Object):void
		{
			if(e == null) return ;
			var obj:Object = comp.configData.getAttriObj();
			for(var key:String in obj){
				if(e.hasOwnProperty(key)){
					var setA:Boolean=true
					var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemByKey(key);
					if(d!=null){
						if(d.value == "file"){
							setA = false;
						}
						if(d.value == "texture"){
							setA = false;
						}
					}
					if(setA){
						e[key] = obj[key];
					}
				}
			}
		}
		
		//////////////////// camera //////////////////////////
		
		private function create_PerspectiveLens():PerspectiveLens
		{
			var d:PerspectiveLens = new PerspectiveLens();
			_reflashMethodAttri(d);
			return d;
		}
		
		private function create_OrthographicLens():OrthographicLens
		{
			var d:OrthographicLens = new OrthographicLens();
			_reflashMethodAttri(d);
			return d;
		}
		
		override public function getPreList(c:D3ComFile):Array
		{
			if(c.item.expand == "texture"){
				return D3ProjectFilesCache.getInstance().getAllTexture2();
			}
			return D3ProjectFilesCache.getInstance().getAllMaterial();
		}
		
		private function create_CubeTextureBase():CubeTextureBase
		{
			var s1:String = comp.configData.getAttri("envMap");
			var f:File = new File(D3ProjectFilesCache.getInstance().addProjectResPath(s1));
			if(!f.exists) return null;
			if(f.extension == D3ComponentConst.sign_8){
				var d:D3ObjectTexture = D3SceneManager.getInstance().displayList.convertObject(f,false) 
				return D3ProccessTexture(d.proccess).getTexture();
			}
			return null;
		}
		
		private function create_Texture2DBase(key:String):Texture2DBase
		{
			var s1:String = comp.configData.getAttri(key);
			var f:File = new File(D3ProjectFilesCache.getInstance().addProjectResPath(s1));
			if(!f.exists) return null;
			if(f.extension == D3ComponentConst.sign_8){
				var d:D3ObjectTexture = D3SceneManager.getInstance().displayList.convertObject(f,false) 
				return D3ProccessTexture(d.proccess).getTexture();
			}
			return null;
		}
		
		
	}
}