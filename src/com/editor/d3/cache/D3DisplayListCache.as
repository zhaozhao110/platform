package com.editor.d3.cache
{
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import com.air.io.WriteFile;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.app.scene.grid.D3GridScene;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.D3ObjectCamera;
	import com.editor.d3.object.D3ObjectGroup;
	import com.editor.d3.object.D3ObjectLight;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.object.D3ObjectTerrain;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.pop.preList.App3DPreListWin;
	import com.editor.d3.process.D3ProccessCamera;
	import com.editor.d3.process.D3ProccessObject;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.tool.D3ReadImage;
	import com.editor.d3.view.attri.group.D3AttriGroupViewBase;
	import com.editor.d3.view.outline.D3OutlinePopViewMediator;
	import com.editor.d3.view.outline.component.D3OutlinePopListCell;
	import com.editor.d3.view.particle.ParticleAttriView;
	import com.editor.d3.view.project.D3ProjectPopViewMediator;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.event.App3DEvent;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.error.SandyError;
	import com.sandy.math.HashMap;
	import com.sandy.utils.Random;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.UIDUtil;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class D3DisplayListCache
	{
		
		
		
		
		public var selectedParticle:D3ObjectParticle;
		public var selectedComp:D3ObjectBase;
		public var selectedFolder:File;
		public var selectedAttriView:D3AttriGroupViewBase;
		public var selectedParticleAttri:ParticleAttriView;
		public var selectedOutlineNode:D3TreeNode;
		public var terrain:D3ObjectTerrain;
		
		
		///////////////////////////////// group //////////////////////////////////
		
		public var rootNode:D3TreeNode;
		
		public function D3DisplayListCache():void
		{
			createRootNode()
		}
		
		public function dispose():void
		{
			var a:Array = getAllComp();
			for(var i:int=0;i<a.length;i++){
				D3TreeNode(a[i]).dispose(); 
			}
			
			createRootNode();
			
			selectedComp = null;
			selectedFolder = null;
			selectedAttriView = null;
		}
		
		private function createRootNode():void
		{
			rootNode = new D3TreeNode(UIDUtil.createUID());
			rootNode.top = rootNode;
			rootNode.name = "all"
			rootNode.path = "all"
			//createGlobalNode();
		}
		
		
		//////////////////////////// global /////////////////////////////////
		
		public var globalNode:D3TreeNode;
		
		private function initGlobalNode():void
		{
			if(globalNode != null) return ;
			globalNode = new D3TreeNode(UIDUtil.createUID());
			globalNode.name = "global"
			rootNode.addItem(globalNode);
			globalNode.reflashPath();
			
			var globalObject:D3ObjectGroup = new D3ObjectGroup(D3ComponentConst.from_outline);
			globalObject.node = globalNode;
			globalObject.name = globalNode.name;
			globalObject.readObject2();
			
			globalNode.object = globalObject;
			globalNode.reflashPath();
			globalObject.configData.putAttri("path",globalNode.path);
		}
		
		public function checkGlobalIsInited():void
		{
			initGlobalNode();
			initGlobalCamera()
		}
		
		/////////////////////////// global camera /////////////////////////////////
		
		public var globalCamera:D3ObjectCamera;
		
		public function initGlobalCamera():void
		{
			if(globalCamera != null) return ;
			var d:D3CompItemVO = D3ComponentProxy.getInstance().com_ls.getItemById(35);
			
			globalCamera = d.getObject(D3ComponentConst.from_outline) as D3ObjectCamera;
			globalCamera.compItem = d.clone();
			globalCamera.name = "globalCamera"
			globalCamera.proccess.beForeCreateComp(initGlobalCamera_callBack);
		}
		
		private function initGlobalCamera_callBack(p:D3CompProcessBase=null):void
		{
			D3SceneManager.getInstance().displayList.addObject(p.comp,globalNode,"");
		}
		
		
		///////////////////////////////////// compoent /////////////////////////////
		
		
		public function getAllComp():Array
		{
			return rootNode.getAllList();
		}
		
		public function findNodeByUID(uid:String):D3TreeNode
		{
			return rootNode.getAllChild(uid) as D3TreeNode;
		}
		
		public function addObject(d:D3ObjectBase,p:D3TreeNode=null,uid:String="",_add:Boolean=true):D3TreeNode
		{
			if(d == null) return null;
			var t:D3TreeNode = new D3TreeNode(uid);
			t.object = d;
			t.name = t.object.name;
			_addObject(t,p,_add);
			if(t.branch == null && _add){
				SandyError.error("d3treeData branch is null")
			}
			return t;
		}
		
		public function removeObject(d:D3ObjectBase):void
		{
			d.dispose();
			D3ProjectCache.dataChange = true;
		}
		
		private function _addObject(d:D3TreeNode,p:D3TreeNode,_add:Boolean=true):void
		{
			if(!d.object.proccess.createComp(true)) return ;
			
			if(!_add){
				d.object.proccess.afterCreateComp();
				return ;
			}
			
			if(p != null){
				p.addItem(d);
			}else if(selectedOutlineNode!=null){
				selectedOutlineNode.addItem(d);
			}else{
				rootNode.addItem(d);
			}
			d.object.proccess.afterCreateComp();
			
			D3ProjectCache.dataChange = true;
		}
		
		//D3ProjectPopViewMediator , 在D3ProjectPopView里点的时候触发
		public function convertObject(f:File,enSave:Boolean=true):*
		{
			if(!f.exists) return null;
			if(D3ReadImage.checkIsImage(f)) return f;
			var dd:D3ObjectBase = D3ObjectBase.getObject(f);
			if(dd == null) return null;
			dd.enSave = enSave;
			if(dd == null) return null;
			dd.file = f;
			dd.name = f.name;
			if(dd.proccess == null) return null;
			dd.proccess.convertObject();
			return dd;
		}
		
		//D3ProjectCache
		//object -- 在解析配置文件后触发
		public function convertObjectXML(x:Object,ptn:D3TreeNode=null,isGlobal:Boolean=false):void
		{
			_convertObjectXML(x,ptn,isGlobal);
			
			setTimeout(function():void{
				D3SceneManager.getInstance().currScene.cameraMM.enter();
			},2000);
		}
		
		private function _convertObjectXML(x:Object,ptn:D3TreeNode=null,isGlobal:Boolean=false):void
		{
			if(StringTWLUtil.isWhitespace(x)) return ;
			
			if(x.name == "all" || x.attri[1] == "global"){
				if(x.hasOwnProperty("attri")&&x.attri[1] == "global"){
					
				}else{
					convertObjectChildXML(x,isGlobal);
					return ;
				}
			}
			
			var resData:D3ResData = new D3ResData();
			resData.readObject2(x.attri);
			resData.saveObj = x;
			
			var dd:D3ObjectBase = D3ObjectBase.getObjectByGroup(resData.getAttri("group1"),D3ComponentConst.from_outline);
			if(dd == null) return ;
			
			dd.compItem = D3ComponentProxy.getInstance().com_ls.getItemById(resData.getAttri("compId")).clone();
			if(StringTWLUtil.isWhitespace(x.name)){
				dd.name = resData.getAttri("name");
			}else{
				dd.name = x.name;
			}
			dd.readConfigData(resData);
			dd.proccess.beForeCreateComp(null);
			dd.proccess.convertObjectXML();
			var tn:D3TreeNode = addObject(dd,ptn,x.uid);
			
			if(tn.path == "all.global"){
				globalNode = tn;
			}
			if(tn.path == "all.global.globalCamera"){
				globalCamera = dd as D3ObjectCamera;
				(globalCamera.proccess as D3ProccessCamera).checkHaveLens();
			}
			
			convertObjectChildXML(tn,isGlobal);
		}
		
		private function convertObjectChildXML(tn:*,isGlobal:Boolean=false):void
		{
			var obj:*;
			if(tn is D3TreeNode){
				obj = tn.object.configData.saveObj.childs;
			}else{
				obj = tn.childs;
			}
			if(obj is Array){
				var a:Array = obj as Array;
				if(a == null) return ;
				for(var i:int=0;i<a.length;i++){
					if(tn is D3TreeNode){
						_convertObjectXML(a[i],tn,isGlobal);
					}else{
						_convertObjectXML(a[i],null,isGlobal);	
					}
				}
			}else{
				if(tn is D3TreeNode){
					_convertObjectXML(obj,tn,isGlobal);
				}else{
					_convertObjectXML(obj,null,isGlobal);
				}
			}
		}
		
		
		////////////////////////////////////////////////////////////////////////////////////////////////
		
		private var laterBind_ls:HashMap = new HashMap();
		
		public function addLaterBind(d:D3ObjectBind):void
		{
			if(StringTWLUtil.isWhitespace(d.bindObjectPath)) return ;
			laterBind_ls.put(d.bindObjectPath,d);
		}
		
		public function laterBindCreated(d:D3Object):void
		{
			var p:String = d.node.path;
			if(laterBind_ls.exists(p)){
				var bd:D3ObjectBind = laterBind_ls.find(p) as D3ObjectBind;
				D3Object(bd.parentObject).bindBoneToObject(bd);
				laterBind_ls.remove(p);
			}
		}
		
		private var laterLight_ls:HashMap = new HashMap();
		
		public function addLaterLight(p:String,d:D3ObjectBase):void
		{
			laterLight_ls.put(p,d);
		}
		
		public function laterLightCreated(p:String):void
		{
			if(laterLight_ls.exists(p)){
				var bd:D3Object = laterLight_ls.find(p) as D3Object;
				bd.parserLights();
				laterLight_ls.remove(p);
			}
		}
		
		
		
		///////////////////////////////////////// 更新场景里所有对象的缓存 /////////////////////////
		
		public function reflashAllNodeMaterial(d:D3ObjectMaterial):void
		{
			var a:HashMap = rootNode.getAllHash();
			for(var ele:* in a.getContent()){
				var nd:D3TreeNode = a.find(ele);
				if(nd.object.proccess is D3ProccessObject){
					var f:File = D3Object(nd.object).getMaterialFile();
					if(f!=null && f.nativePath == d.file.nativePath){
						(nd.object.proccess as D3ProccessObject).setMaterial();
					}
				}
			}
		}
		
		public var lightPicker:StaticLightPicker;
		public var lightPicker_ls:Array = [];
		
		public function removeLight(d:D3ObjectLight):void
		{
			var a:Array = lightPicker_ls
			var n:int=a.indexOf(d);
			if(n>=0){
				a.splice(n,1);
				if(a.length > 0){
					lightPicker = new StaticLightPicker(getLightBase());
				}else{
					lightPicker = null;
				}
				reflashAllLight();
			}
		}
		
		public function getDirectionalLight():DirectionalLight
		{
			if(lightPicker == null) return null;
			var a:Array = lightPicker.lights;
			for(var i:int=0;i<a.length;i++){
				if(a[i] is DirectionalLight){
					return a[i];
				}
			}
			return null;
		}
		
		private var have_addLight_bool:Boolean;
		
		public function addLight(d:D3ObjectLight):void
		{
			var a:Array = lightPicker_ls
			var n:int=a.indexOf(d);
			if(n == -1){
				have_addLight_bool = true;
				lightPicker_ls.push(d);
				lightPicker = new StaticLightPicker(getLightBase());
				reflashAllLight();
			}
		}
		
		private function getLightBase():Array
		{
			var a:Array = [];
			for(var i:int=0;i<lightPicker_ls.length;i++){
				var l:D3ObjectLight = lightPicker_ls[i] as D3ObjectLight;
				if(l.getLight() != null){
					if(a.indexOf(l.getLight())==-1){
						a.push(l.getLight());
					}
				}
			}
			return a;
		}
		
		private function reflashAllLight():void
		{
			if(!have_addLight_bool) return ;
			var a:HashMap = rootNode.getAllHash();
			for(var ele:* in a.getContent()){
				var nd:D3TreeNode = a.find(ele);
				if(nd.object&&nd.object.proccess is D3ProccessObject){
					(nd.object.proccess as D3ProccessObject).mapItem.setLight();
				}
			}
		}
		
		
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
		private function get_D3ProjectPopViewMediator():D3ProjectPopViewMediator
		{
			return iManager.retrieveMediator(D3ProjectPopViewMediator.NAME) as D3ProjectPopViewMediator;
		}
		
		private function get_D3OutlinePopViewMediator():D3OutlinePopViewMediator
		{
			return iManager.retrieveMediator(D3OutlinePopViewMediator.NAME) as D3OutlinePopViewMediator
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
		
	}
}