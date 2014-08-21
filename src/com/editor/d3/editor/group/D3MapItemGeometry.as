package com.editor.d3.editor.group
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.methods.SimpleWaterNormalMethod;
	import away3d.primitives.CapsuleGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.PrimitiveBase;
	import away3d.primitives.SkyBox;
	import away3d.primitives.SphereGeometry;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessGeometry;
	import com.editor.d3.process.D3ProccessMaterial;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.sandy.asComponent.event.ASEvent;

	public class D3MapItemGeometry extends D3EditorMapItem
	{
		public function D3MapItemGeometry()
		{
			super();	
		}
		
		override public function getObject():ObjectContainer3D
		{
			return mesh
		}
		
		/////////////////////////////////////////////  Geometry ///////////////////////////////////
		
		private var geometry:PrimitiveBase;
		protected var tmp_mat:ColorMaterial = new ColorMaterial(0xcccccc, 1);
		private var mesh:Mesh;
		private var skyBox:SkyBox;
		
		override public function createGeometry():void
		{
			if(comp.compItem.isSkyBox){
				if(comp.configData.checkAttri("cubeTexture")){
					_createSkyBox();
					skyBox.cubeTexture = D3ProccessGeometry(comp.proccess).create_skyCubeTextureBase();
				}
			}else{
				_createGeometry();
			}
		}
		
		private function _createSkyBox():void
		{
			if(skyBox!=null) return ;
			removeGeometry()
			
			skyBox = new SkyBox();
			D3SceneManager.getInstance().currScene.sceneContianer.addChild(skyBox);
		}
		
		private function _createGeometry():void
		{
			removeGeometry();
			
			geometry = getGeometry();
			mesh = new Mesh(geometry,tmp_mat);
			mesh.pickingCollider = D3ViewManager.pickingCollider;;
			mesh.mouseEnabled = true;
			objectParent.addChild(mesh);
			_setMeshInited(mesh);
			reflashMeshInfo();
			addListener();
			_setMaterialInited(mesh.material);
		}
		
		public function scaleUV(scaleU:Number = 1, scaleV:Number = 1):void
		{
			if(geometry){
				if(isNaN(scaleU)) return ;
				if(isNaN(scaleV)) return ;
				if(scaleU == 0) return ;
				if(scaleV == 0) return ;
				geometry.scaleUV(scaleU,scaleV);
			}
		}
		
		override public function removeGeometry():void
		{
			if(geometry)geometry.dispose();
			geometry=null;
			if(skyBox!=null){
				D3SceneManager.getInstance().currScene.sceneContianer.removeChild(skyBox);
			}
			skyBox = null;
			if(mesh)mesh.dispose();
			mesh = null;
			removeListener();
		}
				
		override public function setMaterial():void
		{
			if(mesh!=null){
				mesh.material = D3ProccessMaterial((comp as D3ObjectBase).materialComp.proccess).getMaterial();
				_setMaterialInited(mesh.material);
				dispatchEvent(new ASEvent(MATERIAL_ADD));
			}
		}
		
		override public function getMaterial():*
		{
			if(mesh){
				return mesh.material;
			}
			return null;
		}
		
		override public function addMethod(d:D3ObjectMethod):void
		{
			if(getMaterial() is SinglePassMaterialBase){
				(getMaterial() as SinglePassMaterialBase).addMethod(d.medthodProccess.getMethod());
			}
		}
		
		override public function removeMethod(d:D3ObjectMethod):void
		{
			if(getMaterial() is SinglePassMaterialBase){
				(getMaterial() as SinglePassMaterialBase).removeMethod(d.medthodProccess.methodBase);
			}
		}
		
		private function getGeometry():PrimitiveBase
		{
			if(comp.compItem.id == 6){
				return new CylinderGeometry();
			}else if(comp.compItem.id == 7){
				return new SphereGeometry();
			}else if(comp.compItem.id == 8){
				return new PlaneGeometry();
			}else if(comp.compItem.id == 18){
				return new CapsuleGeometry();
			}else if(comp.compItem.id == 19){
				return new CubeGeometry();
			}
			return null;
		}
		
		override public function setAttri(k:String,v:*):void
		{
			if(comp.compItem.isSkyBox){
				if(k == "cubeTexture"){
					_createSkyBox();
					skyBox.cubeTexture = D3ProccessGeometry(comp.proccess).create_skyCubeTextureBase();
					return ;
				}
			}
			
			if(geometry == null) return ;
			if(k == "color"){
				if(!comp.configData.checkAttri("material")){
					if(mesh.material is ColorMaterial){
					}else{
						mesh.material = tmp_mat;
						_setMaterialInited(mesh.material);
					}
					tmp_mat.color = v;
				}
			}else{
				if(geometry.hasOwnProperty(k)){
					geometry[k] = v;
				}else if(mesh.hasOwnProperty(k)){
					mesh[k] = v;
				}else{
					setNoOwnProp(mesh,k,v);
				}
			}
		}
		
		override protected function setNoOwnProp(b:*,k:String,v:*):void
		{
			super.setNoOwnProp(b,k,v);
			if(k == "repeat"){
				mesh.material.repeat = v;
			}else if(k == "tilingX"){
				scaleUV2();
			}else if(k == "tilingY"){
				scaleUV2();
			}
		}
		
		private function scaleUV2():void
		{
			var xv:* = comp.configData.getAttriById(68)
			var yv:* = comp.configData.getAttriById(69)
			if(xv > 0 && yv > 0){
				geometry.scaleUV(xv,yv);
			}else{
				geometry.scaleUV(1,1);
			}
		}
		
		override public function removeMaterial():void
		{
			if(mesh == null) return ;
			mesh.material = null;
			mesh.resetToDefaultMaterial();
			_setMaterialInited(mesh.material);
			dispatchEvent(new ASEvent(MATERIAL_REMOVE));
		}
		
		override public function setLight():void
		{
			if(mesh)_setMaterialInited(mesh.material);
		}
		
	}
}