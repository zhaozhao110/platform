package com.editor.d3.editor
{
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.data.JointPose;
	import away3d.animators.data.Skeleton;
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.BindingTag;
	import away3d.entities.Mesh;
	import away3d.entities.ParticleGroup;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.events.Object3DEvent;
	import away3d.library.assets.AssetType;
	import away3d.lights.DirectionalLight;
	import away3d.loaders.AssetLoader;
	import away3d.loaders.parsers.MD5AnimParser;
	import away3d.loaders.parsers.MD5MeshParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.FilteredShadowMapMethod;
	import away3d.materials.methods.HardShadowMapMethod;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.primitives.CapsuleGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.PrimitiveBase;
	import away3d.primitives.SphereGeometry;
	import away3d.tools.utils.Drag3D;
	
	import com.d3.component.core.DisplayObject3D;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.editor.group.D3MapItemCamera;
	import com.editor.d3.editor.group.D3MapItemGeometry;
	import com.editor.d3.editor.group.D3MapItemLight;
	import com.editor.d3.editor.group.D3MapItemMesh;
	import com.editor.d3.editor.group.D3MapItemParticle;
	import com.editor.d3.editor.group.D3MapItemWireframe;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessBindBone;
	import com.editor.d3.process.D3ProccessMaterial;
	import com.editor.d3.tool.App3DAssetLoader;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.error.SandyError;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	public class D3EditorMapItem extends EventDispatcher 
	{
		public function D3EditorMapItem()
		{
			super();
		}
		
		public static const MESH_CREATE_COMPLETE:String 			= "mesh_create_complete"
		public static const ANIMATIONSET_CREATE_COMPLETE:String 	= "animationSet_create_complete"
		public static const ANIMATION_CREATE_COMPLETE:String 		= "animation_create_complete"
		public static const MATERIAL_ADD:String					= "material_add";
		public static const MATERIAL_REMOVE:String				= "material_remove"
			
			
		public var comp:D3ObjectBase;
		public var view:View3D;
		//Scene3D or ObjectContainer3D
		public var objectParent:*;
		//在预览窗口里的对象
		public var isAttriPreview:Boolean;
		
		
		private var _mesh_create_complete_f:Function;
		public function get mesh_create_complete_f():Function
		{
			return _mesh_create_complete_f;
		}
		public function set mesh_create_complete_f(value:Function):void
		{
			_mesh_create_complete_f = value;
			if(mesh)mesh.mesh_create_complete_f = value;
		}

		private var _animationSet_create_complete_f:Function;
		public function get animationSet_create_complete_f():Function
		{
			return _animationSet_create_complete_f;
		}
		public function set animationSet_create_complete_f(value:Function):void
		{
			_animationSet_create_complete_f = value;
			if(mesh)mesh.animationSet_create_complete_f = value;
		}

		private var _animation_create_complete_f:Function;
		public function get animation_create_complete_f():Function
		{
			return _animation_create_complete_f;
		}
		public function set animation_create_complete_f(value:Function):void
		{
			_animation_create_complete_f = value;
			if(mesh)mesh.animation_create_complete_f = value;
		}
		
		
		
		
		private var mesh:D3MapItemMesh;
		private var particle:D3MapItemParticle;
		private var geometry:D3MapItemGeometry;
		private var wireframe:D3MapItemWireframe;
		private var light:D3MapItemLight;
		
		public function getObject():ObjectContainer3D
		{
			SandyError.error("mapItem getObject is null");
			return null;
		}
		
		public function setAttri(k:String,v:*):void
		{
			if(getObject() == null) return ;
			if(getObject().hasOwnProperty(k)){
				getObject()[k] = v;
			}else{
				setNoOwnProp(getObject(),k,v);
			}
		}
		
		protected function setNoOwnProp(b:*,k:String,v:*):void
		{
			if(k == "rendering"){
				b.visible = v;
			}
		}
		
		protected function getValidObject():D3EditorMapItem
		{
			if(mesh) return mesh;
			if(particle) return particle;
			if(geometry) return geometry;
			if(wireframe) return wireframe;
			if(light) return light;
			return null;
		}
		
		///////////////////////////////////// mesh /////////////////////////////////////
		
		public function reflashMeshInfo():void
		{
			if(comp!=null && !isAttriPreview){
				comp.getD3ObjProccess().reflashObjectAttri();
			}
		}
		
		public function getMessFile():File
		{
			if(mesh) return mesh.getMessFile();
			return null;
		}
		
		public function get currPlayingAnim():String
		{
			if(mesh) return mesh.currPlayingAnim;
			return "";
		}
		
		public function removeMesh():void
		{
			if(mesh!=null)mesh.removeMesh();
			mesh = null
		}
		
		public function loadMesh(f:File):void
		{
			if(mesh == null){
				mesh = new D3MapItemMesh();
				mesh.objectParent = getObject();
				mesh.mesh_create_complete_f 		= mesh_create_complete_f;
				mesh.animation_create_complete_f 	= animation_create_complete_f;
				mesh.animationSet_create_complete_f = animationSet_create_complete_f;
				mesh.addEventListener(D3EditorMapItem.ANIMATIONSET_CREATE_COMPLETE	, animationSet_create_complete);
				mesh.addEventListener(D3EditorMapItem.ANIMATION_CREATE_COMPLETE		, animation_create_complete);
				mesh.addEventListener(D3EditorMapItem.MESH_CREATE_COMPLETE			, meshCreated);
			}
			mesh.loadMesh(f);
		}
		
		private function animationSet_create_complete(e:ASEvent):void
		{
			dispatchEvent(e);
		}
		
		private function animation_create_complete(e:ASEvent):void
		{
			dispatchEvent(e);
		}
		
		private function meshCreated(e:ASEvent):void
		{
			dispatchEvent(e);
		}
		
		public function setMaterial():void
		{
			if(mesh){
				mesh.setMaterial();
				dispatchEvent(new ASEvent(MATERIAL_ADD));
			}
		}
		
		public function getMaterial():*
		{
			if(mesh) return mesh.getMaterial();
		}
		
		public function removeMaterial():void
		{
			if(mesh!=null){
				mesh.removeMaterial();
				dispatchEvent(new ASEvent(MATERIAL_REMOVE));
			}
		}
		
		public function stopAnim():void
		{
			if(mesh)mesh.stopAnim();	
		}
		
		public function playAnim(n:String):void
		{
			if(mesh) mesh.playAnim(n);
		}
		
		public function bindObject(d:D3ObjectBind):Boolean
		{
			if(mesh) return mesh.bindObject(d);
			return false;
		}
		
		public function unBindObject(d:D3ObjectBind):void
		{
			if(mesh) mesh.unBindObject(d);
		}
		
		public function unPreBindObject(d:D3ObjectBind):void
		{
			if(mesh) mesh.unPreBindObject(d);
		}
		
		public function getMeshInfo():String
		{
			if(mesh) return mesh.getMeshInfo();
			return "";
		}
		
		public function getJointPoses():Vector.<JointPose>
		{
			if(mesh) return mesh.getJointPoses();
			return null;
		}
		
		public function removeAnim(d3:D3ObjectAnim):void
		{
			if(mesh) mesh.removeAnim(d3);
		}
		
		public function loadAnim(d:D3ObjectAnim):void
		{
			if(mesh)mesh.loadAnim(d)
		}
		
		protected function _setMeshInited(m:Mesh):void
		{
			m.castsShadows = true;
			m.resetToDefaultMaterial();
		}
		
		protected function _setMaterialInited(m:MaterialBase):void
		{
			if(D3Object(comp).lightPicker==null){
				m.lightPicker = D3SceneManager.getInstance().displayList.lightPicker;
			}else{
				m.lightPicker = D3Object(comp).lightPicker;
			}
			if(m is SinglePassMaterialBase){
				var dl:DirectionalLight = D3SceneManager.getInstance().displayList.getDirectionalLight();
				if(dl != null){
					(m as SinglePassMaterialBase).shadowMethod = new SoftShadowMapMethod(dl);
				}else{
					(m as SinglePassMaterialBase).shadowMethod = null;
				}
				
				if(comp is D3Object){
					D3Object(comp).reflashAllMethod()
				}
			}
		}
		
		////////////////////////////////// particle ////////////////////////////
		
		public function loadParticle(b:File):void
		{
			if(particle == null){
				particle = new D3MapItemParticle();
				particle.objectParent = getObject();
				particle.addEventListener(D3EditorMapItem.ANIMATIONSET_CREATE_COMPLETE	, animationSet_create_complete);
			}
			particle.loadParticle(b);
		}
		
		public function removeParticle():void
		{
			if(particle)particle.removeParticle();
		}
		
		
		//////////////////////////////// geometry ////////////////////////////////
		
		public function createGeometry():void
		{
			if(geometry == null){
				geometry = new D3MapItemGeometry();
				geometry.objectParent = getObject();
			}
			geometry.createGeometry();
		}
		
		public function removeGeometry():void
		{
			if(geometry)geometry.removeGeometry();
			geometry = null;
		}
		
		//////////////////////////////// wireframe ////////////////////////////////
		
		public function createWireframe():void
		{
			if(wireframe == null){
				wireframe = new D3MapItemWireframe();
				wireframe.objectParent = getObject();
			}
			wireframe.createWireframe();
		}
		
		public function removeWireframe():void
		{
			if(wireframe) wireframe.removeWireframe();
		}
		
		
		///////////////////////////// camera ////////////////////////////////
		private var camera:D3MapItemCamera;
		
		public function createCamera():void
		{
			if(camera == null){
				camera = new D3MapItemCamera();
				camera.objectParent = getObject();
			}
			camera.createCamera();
		}
		
		public function removeCamera():void
		{
			if(camera) camera.removeCamera();
			camera = null;
		}
		
		///////////////////////////// light ////////////////////////////////
		
		public function createLight():void
		{
			if(light == null){
				light = new D3MapItemLight();
				light.objectParent = getObject();
			}
			light.createLight();
		}
		
		public function removeLight():void
		{
			if(light) light.removeLight();
			light = null;
		}
		
		public function setLight():void
		{
			if(mesh)mesh.setLight();
		}
		
		
		///////////////////////////// method ////////////////////////////////
		
		public function addMethod(d:D3ObjectMethod):void
		{
			if(mesh)mesh.addMethod(d);
		}
		
		public function removeMethod(d:D3ObjectMethod):void
		{
			if(mesh)mesh.removeMethod(d);
		}
		
		//////////////////////////////////////////////////////////////////////
		
		protected function addListener():void
		{
			if(isAttriPreview) return ;
			if(getObject() == null) return ;
			removeListener();
			getObject().addEventListener(MouseEvent3D.MOUSE_DOWN		, onMeshDown);
			getObject().addEventListener(Object3DEvent.POSITION_CHANGED , onPositionChange);
			getObject().addEventListener(Object3DEvent.ROTATION_CHANGED , onRotationChange);
			getObject().addEventListener(Object3DEvent.SCALE_CHANGED 	, onSceleChange);
			getObject().addEventListener(Object3DEvent.ATTRI_CHANGED	, onAttriChange);
		}
		
		protected function removeListener():void
		{
			if(getObject() == null) return ;
			getObject().removeEventListener(MouseEvent3D.MOUSE_DOWN			, onMeshDown);
			getObject().removeEventListener(Object3DEvent.POSITION_CHANGED 	, onPositionChange);
			getObject().removeEventListener(Object3DEvent.ROTATION_CHANGED 	, onRotationChange);
			getObject().removeEventListener(Object3DEvent.SCALE_CHANGED 	, onSceleChange);
			getObject().removeEventListener(Object3DEvent.ATTRI_CHANGED	, onAttriChange);
		}
		
		protected function onAttriChange(e:ASEvent):void
		{
			if(comp)comp.d3ObjectToRefOneAttri(e.data,e.addData);
		}
		
		private var onMeshDown_time:Number;
		public function onMeshDown(e:MouseEvent3D=null):void
		{
			if(isNaN(onMeshDown_time)){
				onMeshDown_time = getTimer();
			}else{
				if((getTimer()-onMeshDown_time)<10) return ;
			}
			onMeshDown_time = getTimer();
			if(e!=null){
				e.stopImmediatePropagation();
				e.preventDefault();
			}
			if(getValidObject()){
				getValidObject().onMeshDown(e);
			}else{
				if(comp!=null){
					comp.getD3ObjProccess().selectdMesh();
				}
			}
		}
		
		protected function onPositionChange(e:Object3DEvent):void
		{
			if(comp)comp.d3ObjectToReflashAttri(getObject());
		}
		
		protected function onSceleChange(e:Object3DEvent):void
		{
			if(comp)comp.d3ObjectToReflashAttri(getObject());
		}
		
		protected function onRotationChange(e:Object3DEvent):void
		{
			if(comp)comp.d3ObjectToReflashAttri(getObject());
		}
		
		public function render():void
		{
			
		}
		
		public function setMapItemVisible(b:*=null):void
		{
			if(b == null){
				getObject().visible = !getObject().visible;
			}else{
				getObject().visible = b;
			}
		}
		
		public function dispose():void
		{
			removeGeometry();
			removeLight();
			removeMaterial();
			removeMesh();
			removeParticle();
			removeWireframe();
			removeListener();
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
		
		
		
		
		
		
		
		
		
	}
}