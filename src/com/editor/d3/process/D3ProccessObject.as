package com.editor.d3.process
{
	import away3d.animators.nodes.SkeletonClipNode;
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import com.d3.component.core.DisplayObject3D;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.scene.grid.vo.GizmoMode;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.editor.D3EditorMapItem;
	import com.editor.d3.editor.group.D3MapItemObject;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMesh;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.pop.preMaterial.App3DPreMaterialWin;
	import com.editor.d3.pop.preMesh.App3DPreMeshWin;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.preview.MeshInfoPreview;
	import com.editor.d3.view.outline.component.D3OutlinePopListCell;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.editor.event.App3DEvent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.error.SandyError;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.ClassFactory;
	
	import flash.filesystem.File;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;

	//空对象
	public class D3ProccessObject extends D3CompProcessBase
	{
		public function D3ProccessObject(d:D3Object)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group1
		}
		
		//////////////////////////////////////// attri ////////////////////////////////
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			if(d.attriId == 5){
				if(comp.configData.checkAttri("mesh")){
					deleteGroup(7)
					deleteGroup(8)
				}
				//mesh
				createMesh(dd.data as File);
				saveAttri(d,dd);
			}else if(d.attriId == 7){
				//material
				createMaterial(dd.data as File);
				saveAttri(d,dd);
			}else if(d.attriId == 29){
				//meshInfo
				D3ViewManager.getInstance().openView_meshInfo(comp);
			}else if(d.key == "name"){
				if(D3SceneManager.getInstance().displayList.findNodeByUID(dd.data)!=null){
					iManager.iPopupwin.showError(dd.data+"已经存在");
					return ;
				}
				saveAttri(d,dd);
				changeName(d,dd);
			}else if(d.attriId == 34){
				//delete
				deleteObject()
			}else if(d.attriId == -1){
				//mainMesh
				
			}else if(d.attriId == 39){
				//刷新缓存
				
			}else{
				if(d.item.value == "button") return ;
				if(d.key == "visible"){
					reflashPreview(d,dd)
					saveAttri(d,dd)
				}else if(d.item.value == "vector3D"){
					var vec:Vector3D = dd.data as Vector3D;
					if(d.attriId == 114){
						if(!isNaN(vec.x)){
							setAttri("x",vec.x)
						}
						if(!isNaN(vec.y)){
							setAttri("y",vec.y)
						}
						if(!isNaN(vec.z)){
							setAttri("z",vec.z)
						}
					}else if(d.attriId == 115){
						if(!isNaN(vec.x)){
							setAttri("rotationX",vec.x)
						}
						if(!isNaN(vec.y)){
							setAttri("rotationY",vec.y)
						}
						if(!isNaN(vec.z)){
							setAttri("rotationZ",vec.z)
						}
					}else if(d.attriId == 116){
						if(!isNaN(vec.x)){
							setAttri("scaleX",vec.x)
						}
						if(!isNaN(vec.y)){
							setAttri("scaleY",vec.y)
						}
						if(!isNaN(vec.z)){
							setAttri("scaleZ",vec.z)
						}
					}else{
						saveAttri(d,dd)
						reflashPreview(d,dd)
					}
				}else{
					saveAttri(d,dd)
					reflashPreview(d,dd)
				}
				if(d.attriId == 51){
					//mainMesh
					if(D3OutlinePopListCell.selectedCell.nextNode!=null){
						D3OutlinePopListCell.selectedCell.nextNode.reflashDataProvider();
					}
				}
			}
		}
		
		///////////////////////////////// create ////////////////////////////////////
				
		override public function afterCreateComp():void
		{
			super.afterCreateComp();
			
			if(comp.checkIsInProject()) return ;
			
			D3Object(comp).parserAnimFromXML();
			D3Object(comp).parserBoneFromXML();
			_createMapItem();
			createMesh();
			createParticle()
			D3Object(comp).playLastAnim();
			D3Object(comp).parserLights();
			D3Object(comp).parserMethods();
		}
		
		public function reflashObjectAttri():void
		{
			if(mapItem == null) return ;
			var obj:Object = comp.configData.getAttriObj();
			for(var key:String in obj) {
				var element:* = obj[key];
				if(key == "material"){
					var mf:File = (comp as D3Object).getMaterialFile();
					if(mf!=null&&mf.exists){
						if(mapItem!=null){
							createMaterial(mf);
						}
					}
				}else{
					if(key == "坐标"){
						var v:Vector3D = comp.configData.getAttri("坐标");
						if(!isNaN(v.x)) mapItem.setAttri("x",v.x);
						if(!isNaN(v.y)) mapItem.setAttri("y",v.y);
						if(!isNaN(v.z)) mapItem.setAttri("z",v.z);
					}
					else if(key == "旋转"){
						v = comp.configData.getAttri("旋转");
						if(!isNaN(v.x)) mapItem.setAttri("rotationX",v.x);
						if(!isNaN(v.y)) mapItem.setAttri("rotationY",v.y);
						if(!isNaN(v.z)) mapItem.setAttri("rotationZ",v.z);
					}
					else if(key == "缩放"){
						v = comp.configData.getAttri("缩放");
						if(!isNaN(v.x)) mapItem.setAttri("scaleX",v.x);
						if(!isNaN(v.y)) mapItem.setAttri("scaleY",v.y);
						if(!isNaN(v.z)) mapItem.setAttri("scaleZ",v.z);
					}else{
						mapItem.setAttri(key,obj[key]);
					}
				}
			}
		}
		
		public function selectdMesh():void
		{
			iManager.sendAppNotification(D3Event.before_select3DComp_event,comp);
		}
		
		override public function openSource():void
		{
			get_D3SourcePopViewMediator().openText(comp.configData.content);
		}
		
		override public function deleteAttriGroup(d:D3GroupItemVO):void
		{
			if(d.id == 3){
				//material
				mapItem.removeMaterial();
			}else if(d.id == 2){
				//mesh
				mapItem.removeMesh();
			}else if(d.id == 8){
				//bones
				D3Object(comp).unAllBindObject();
			}else if(d.id == 7){
				//anims 
				D3Object(comp).removeAllAnim();
			}else if(d.id == 38){
				//lights
				D3Object(comp).removeAllLights();
			}else if(d.id == 39){
				//method
				D3Object(comp).removeAllMethod();
			}
			super.deleteAttriGroup(d);
		}
		
		
		/////////////////////////////////mesh ////////////////////////////////////
		
		public function checkMapItemExisted():Boolean
		{
			return mapItem != null;
		}
		
		protected function _createMapItem_cls():Class
		{
			return D3MapItemObject;
		}
		
		protected function _createMapItem():void
		{
			if(comp.group == D3ComponentConst.comp_group5) return ;
			if(mapItem == null){
				var f:ClassFactory = new ClassFactory(_createMapItem_cls());
				mapItem = f.newInstance();
				mapItem.addEventListener(D3EditorMapItem.ANIMATIONSET_CREATE_COMPLETE	, animationSet_create_complete);
				mapItem.addEventListener(D3EditorMapItem.ANIMATION_CREATE_COMPLETE		, animation_create_complete);
				mapItem.addEventListener(D3EditorMapItem.MESH_CREATE_COMPLETE			, meshCreated);
				mapItem.addEventListener(D3EditorMapItem.MATERIAL_ADD					, material_add_handle);
				mapItem.addEventListener(D3EditorMapItem.MATERIAL_REMOVE				, material_remove_handle);
				mapItem.objectParent = getParentContainer();
				if(mapItem.objectParent == null){
					SandyError.error("objectParent is null");
				}
				mapItem.comp = comp;
			}
		}
		
		protected function material_add_handle(e:ASEvent):void
		{
			
		}
		
		protected function material_remove_handle(e:ASEvent):void
		{
			
		}
		
		//在解除绑定后，添加到舞台上
		public function resteAddMapItem():void
		{
			getParentContainer().addChild(mapItem.getObject());
		}
		
		protected function getParentContainer():ObjectContainer3D
		{
			if(comp.node.branch!=null){
				if(D3TreeNode(comp.node.branch).object != null){
					if(D3TreeNode(comp.node.branch).object.proccess is D3ProccessObject){
						return (D3TreeNode(comp.node.branch).object.proccess as D3ProccessObject).mapItem.getObject();
					}
				}
			}
			return D3SceneManager.getInstance().currScene.sceneContianer;
		}
		
		private function createMesh(f:File=null):void
		{
			var mf:File;
			if(f!=null){
				mf = f;
			}else{
				mf = (comp as D3Object).getMeshFile();
			}
			if(mf!=null&&mf.exists){
				if(mapItem!=null){
					var d:D3ObjectMesh = D3SceneManager.getInstance().displayList.convertObject(mf,false) as D3ObjectMesh;
					(comp as D3Object).meshComp = d;
					mapItem.loadMesh(mf);
				}
			}
		}
		
		protected function meshCreated(e:ASEvent):void
		{
		}
		
		private function createMaterial(f:File):void
		{
			if(f == null) return ;
			if(!f.exists) return ;
			var d:D3ObjectMaterial = D3SceneManager.getInstance().displayList.convertObject(f,false) as D3ObjectMaterial;
			(comp as D3Object).materialComp = d;
			setMaterial()
		}
		
		public function editMaterial():void
		{
			var mf:File = (comp as D3Object).getMaterialFile();
			if(mf!=null&&mf.exists){
				if(mapItem!=null){
					iManager.sendAppNotification(D3Event.select3DComp_event,D3SceneManager.getInstance().displayList.convertObject(mf));
				}
			}
		}
		
		public function setMaterial():void
		{
			if(mapItem!=null)mapItem.setMaterial();
		}
				
		public function removeMesh():void
		{
			if(mapItem!=null){
				mapItem.dispose();
			}
			mapItem = null;
		}
		
		public function setLight():void
		{
			if(mapItem!=null)mapItem.setLight();
		}
		
		///////////////////////////////// binding ////////////////////////////////////
		
		
		protected function animation_create_complete(e:ASEvent):void
		{
			
		}
		
		protected function animationSet_create_complete(e:ASEvent):void
		{
			D3Object(comp).playDefaultAnim();
			D3Object(comp).bindAllBones();
			D3SceneManager.getInstance().displayList.laterBindCreated(comp as D3Object);
		}
		
		public function playAnim(n:String):void
		{
			mapItem.playAnim(n);
		}
		
		public function stopAnim():void
		{
			mapItem.stopAnim();
		}
		
		public function selectObject():void
		{
			if(mapItem!=null){
				D3SceneManager.getInstance().currScene.selectObject(mapItem.getObject());
			}
		}
		
		public function translate():void
		{
			D3SceneManager.getInstance().currScene.selectObject(mapItem.getObject(),GizmoMode.TRANSLATE);
		}
		
		public function scale():void
		{
			D3SceneManager.getInstance().currScene.selectObject(mapItem.getObject(),GizmoMode.SCALE);
		}
		
		public function rotation():void
		{
			D3SceneManager.getInstance().currScene.selectObject(mapItem.getObject(),GizmoMode.ROTATE);
		}
		
		public function bindObject(d:D3ObjectBind):Boolean
		{
			if(mapItem!=null) return mapItem.bindObject(d)
			return false;
		}
		
		public function unBindObject(d:D3ObjectBind):void
		{
			if(mapItem!=null) mapItem.unBindObject(d)
		}
		
		public function unPreBindObject(d:D3ObjectBind):void
		{
			if(mapItem!=null) mapItem.unPreBindObject(d)
		}
			
		
		//////////////////////////////////////// particle /////////////////////////////////
		
		protected function createParticle(f:File=null):void
		{
			var mf:File;
			if(f!=null){
				mf = f;
			}else{
				mf = (comp as D3Object).getParticleFile();
			}
			if(mf!=null&&mf.exists){
				if(mapItem!=null){
					var d:D3ObjectParticle = D3SceneManager.getInstance().displayList.convertObject(mf) as D3ObjectParticle;
					(comp as D3Object).particleComp = d;
					mapItem.loadParticle(mf);
					comp.configData.particleObj = d.configData.particleObj
				}
			}
		}
		
		public function removeParticle():void
		{
			mapItem.removeParticle()
		}
		
		public function reflashParticleCache():void
		{
			createParticle(D3Object(comp).getParticleFile());
		}
		
		
		
		
		
		override public function dispose():void
		{
			super.dispose()
			if(mapItem!=null){
				mapItem.dispose();
			}
			mapItem = null;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}