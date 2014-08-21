package com.editor.d3.editor.group
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
	import away3d.loaders.AssetLoader;
	import away3d.loaders.parsers.MD5AnimParser;
	import away3d.loaders.parsers.MD5MeshParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.lightpickers.StaticLightPicker;
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
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessBindBone;
	import com.editor.d3.process.D3ProccessMaterial;
	import com.editor.d3.tool.App3DAssetLoader;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.error.SandyError;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.URLRequest;

	public class D3MapItemMesh extends D3EditorMapItem
	{
		public function D3MapItemMesh()
		{
			super()
		}
		
		private var animator:SkeletonAnimator;
		private var animationSet:SkeletonAnimationSet;
		private var skeleton:Skeleton;
		private var mesh:Mesh;
		private var pLoader:AssetLoader;
		private var meshAssets:App3DAssetLoader;
		private var animAssets:App3DAssetLoader;
		
		override public function getMeshInfo():String
		{
			if(animator == null) return "";
			var s:String = "";
			s += "骨骼数:"+animator.globalPose.numJointPoses+"<br>"
			s += "每个骨骼连接最大数:"+SkeletonAnimationSet(animator.animationSet).jointsPerVertex+"<br>"
			s += "使用常量寄存器最大数:" + animator.numUsedVertexConstants_max+"<br>"
			if(SkeletonAnimationSet(animator.animationSet).usesCPU){
				s += ColorUtils.addColorTool("使用cpu计算，将影响性能",ColorUtils.red)+"<br>"
			}
			return s;
		}
		
		override public function getObject():ObjectContainer3D
		{
			return mesh;
		}
		
		protected function onAssetComplete(event:AssetEvent):void
		{
			if(event.asset.assetType == AssetType.ANIMATION_SET && pLoader == null)
			{
				//mesh - sort 3
				animationSet = event.asset as SkeletonAnimationSet;
				animator = new SkeletonAnimator(animationSet, skeleton);
				mesh.animator = animator;
				
				if(!D3ResChangeProxy.getInstance().checkFile(getMessFile())){
					D3ResChangeProxy.getInstance().addFile(getMessFile(),mesh.clone());
				}
				
				if(animationSet_create_complete_f!=null) animationSet_create_complete_f(this);
				animationSet_create_complete_f = null;
				dispatchEvent(new ASEvent(ANIMATIONSET_CREATE_COMPLETE));
			}
			else if(event.asset.assetType == AssetType.SKELETON && pLoader == null)
			{
				//mesh,一个mesh有很多skeletion , sort 2
				skeleton = event.asset as Skeleton;
			}
			else if(event.asset.assetType == AssetType.ANIMATION_NODE && pLoader == null)
			{
				//anim
				if(isAttriPreview) return ;
				
				var f:D3ObjectAnim = App3DAssetLoader(event.target).data as D3ObjectAnim;
				var node:SkeletonClipNode = event.asset as SkeletonClipNode;
				node.name = f.name
				animationSet.addAnimation(node);
				
				if(animation_create_complete_f!=null) animation_create_complete_f(node,this);
				animation_create_complete_f = null;
				dispatchEvent(new ASEvent(ANIMATION_CREATE_COMPLETE,node));
			}
			else if(event.asset.assetType == AssetType.MESH && pLoader == null)
			{
				//mesh -- sort 1
				var m:Mesh = event.asset as Mesh;
				mesh = m;
				addMesh(mesh);
				
				if(mesh_create_complete_f!=null) mesh_create_complete_f(this);
				mesh_create_complete_f = null;
				dispatchEvent(new ASEvent(MESH_CREATE_COMPLETE));
			}
		}
		
		//////////////////////////// mesh //////////////////////////////////
		
		
		override public function getMessFile():File
		{
			return meshAssets.data as File;
		}
		
		override public function loadMesh(f:File):void
		{
			removeMesh();
			
			if(D3ResChangeProxy.getInstance().checkFile(f)){
				var d:D3ResData = D3ResChangeProxy.getInstance().getFile(f.nativePath);
				if(d.content is Mesh){
					getMeshFromCache(f);
					return;
				}
			}
			
			meshAssets = new App3DAssetLoader();
			meshAssets.addEventListener(AssetEvent.ASSET_COMPLETE,onAssetComplete);
			meshAssets.addEventListener(LoaderEvent.LOAD_ERROR, onError);
			meshAssets.data = f;
			meshAssets.loadData(f,f.nativePath,null,null,new MD5MeshParser());
		}
		
		private function onError(e:LoaderEvent):void{	};
		
		private function getMeshFromCache(f:File):void
		{
			var d:D3ResData = D3ResChangeProxy.getInstance().getFile(f.nativePath);
			mesh = (d.content as Mesh).clone() as Mesh;
			addMesh(mesh);
		}
		
		private function addMesh(m:Mesh):void
		{
			mesh = m;
			mesh.pickingCollider = D3ViewManager.pickingCollider;
			mesh.mouseEnabled = true;
			mesh.data = comp;
			objectParent.addChild(mesh);
			_setMeshInited(mesh);
			reflashMeshInfo();
			addListener();
		}
		
		override public function setLight():void
		{
			if(mesh)_setMaterialInited(mesh.material);
		}
		
		override public function removeMesh():void
		{
			stopAnim();
			if(mesh!=null){
				mesh.dispose();
			}
			mesh = null;
			removeListener();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(meshAssets!=null){
				meshAssets.stop();
				meshAssets = null;
			}
			if(animAssets!=null){
				animAssets.stop();
				animAssets = null;
			}
			removeMesh();
			removeListener();
		}
		
		override public function onMeshDown(e:MouseEvent3D=null):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			if(comp!=null){
				comp.getD3ObjProccess().selectdMesh();
			}
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
		
		override public function removeMaterial():void
		{
			if(mesh == null) return ;
			mesh.material = null;
			mesh.resetToDefaultMaterial();
			_setMaterialInited(mesh.material);
			dispatchEvent(new ASEvent(MATERIAL_REMOVE));
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
		
		/////////////////////////////// anim ///////////////////////////////
		
		override public function loadAnim(d:D3ObjectAnim):void
		{
			if(animationSet == null) return ;
			if(animationSet.hasAnimation(d.name)){
				if(animation_create_complete_f!=null) animation_create_complete_f(animationSet.getAnimation(d.name) as SkeletonClipNode,this);
				animation_create_complete_f = null;
				return ;
			}
			
			animAssets = new App3DAssetLoader();
			animAssets.addEventListener(AssetEvent.ASSET_COMPLETE,onAssetComplete);
			animAssets.addEventListener(LoaderEvent.LOAD_ERROR, onError);
			
			animAssets.data = d;
			animAssets.loadData(d.getAnimFile(),d.getAnimFile().nativePath,null,null,new MD5AnimParser());
		}
		
		override public function playAnim(n:String):void
		{
			if(animationSet.hasAnimation(n)){
				animator.play(n);
			}
		}
		
		override public function get currPlayingAnim():String
		{
			return animator.activeAnimationName;
		}
		
		override public function stopAnim():void
		{
			if(animator!=null)animator.stop();
		}
		
		override public function removeAnim(d3:D3ObjectAnim):void
		{
			animationSet.removeAnimation(d3.name);
		}
		
		///////////////////////////////// bones /////////////////////////////////
		
		override public function getJointPoses():Vector.<JointPose>
		{
			if(animator == null) return null
			return animator.globalPose.jointPoses;
		}
		
		public function get usesCPU():Boolean
		{
			return animationSet.usesCPU;
		}
		
		override public function bindObject(d:D3ObjectBind):Boolean
		{
			if(!animator.checkBoneIsExist(d.boneName)){
				iManager.iPopupwin.showError("没有找到骨骼,"+d.boneName);
				return false;
			}
			
			var bindObj:D3Object = d.bindObject;
			if(bindObj == null) return false;
			if(bindObj.proccess.mapItem.getObject() == null) return false;
			
			var cont:ObjectContainer3D = bindObj.proccess.mapItem.getObject();
			
			var tag:BindingTag = animator.getBindingTag(d.boneName,cont);
			//已经有了
			if(tag!=null)return false;
			
			var bindingTag:BindingTag = animator.addBindingTagByName(d.boneName);
			if(bindingTag!=null){
				bindingTag.addChild(cont);
			}
			
			d.bindingTag = bindingTag;
			D3ProccessBindBone(d.proccess).reflashObjectAttri();
			return true;
		}
		
		override public function unBindObject(d:D3ObjectBind):void
		{
			if(d == null) return ;
			
			var bindObj:D3Object = d.bindObject;
			if(bindObj == null) return ;
			if(bindObj.proccess.mapItem.getObject() == null) return;
			
			var cont:ObjectContainer3D = bindObj.proccess.mapItem.getObject();
			
			var tag:BindingTag = animator.getBindingTag(d.boneName,cont);
			if(tag == null) return ;
			
			var n:int = tag.numChildren;
			for(var i:int=0;i<n;i++){
				if(tag.getChildAt(i) == cont){
					tag.removeChildAt(i);
					break;
				}
			}
			
			if(tag.numChildren == 0){
				animator.unBindingTag(tag);	
			}
		}
		
		override public function unPreBindObject(d:D3ObjectBind):void
		{
			if(d == null) return ;
			
			var bindObj:D3Object = d.pre_bindObject;
			if(bindObj == null) return ;
			if(bindObj.proccess.mapItem.getObject() == null) return;
			
			var cont:ObjectContainer3D = bindObj.proccess.mapItem.getObject();
			
			var tag:BindingTag = animator.getBindingTag(d.pre_boneName,cont);
			if(tag == null) return ;
			
			var n:int = tag.numChildren;
			for(var i:int=0;i<n;i++){
				if(tag.getChildAt(i) == cont){
					tag.removeChildAt(i);
					break;
				}
			}
		}
		
		
		
	}
}