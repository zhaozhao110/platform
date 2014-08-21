package com.editor.d3.object.base
{
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.lightpickers.LightPickerBase;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectAnim;
	import com.editor.d3.object.D3ObjectBind;
	import com.editor.d3.object.D3ObjectCamera;
	import com.editor.d3.object.D3ObjectGeometry;
	import com.editor.d3.object.D3ObjectGroup;
	import com.editor.d3.object.D3ObjectLight;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMesh;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.object.D3ObjectTerrain;
	import com.editor.d3.object.D3ObjectTexture;
	import com.editor.d3.object.D3ObjectWireframe;
	import com.editor.d3.process.D3ProccessAnim;
	import com.editor.d3.process.D3ProccessBindBone;
	import com.editor.d3.process.D3ProccessLight;
	import com.editor.d3.process.D3ProccessMaterial;
	import com.editor.d3.process.D3ProccessMesh;
	import com.editor.d3.process.D3ProccessObject;
	import com.editor.d3.process.D3ProccessParticle;
	import com.editor.d3.process.D3ProccessTexture;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.d3.vo.comp.ID3CompItem;
	import com.editor.model.AppMainModel;
	import com.sandy.error.SandyError;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.UIDUtil;
	
	import flash.filesystem.File;
	import flash.geom.Vector3D;
	
	import flashx.textLayout.compose.ISWFContext;

	public class D3ObjectBase
	{
		public function D3ObjectBase(from:int)
		{
			super();
			fromUI = from;
			uid = UIDUtil.createUID();
		}
		
		public var enSave:Boolean = true;
		
		public var fromUI:int;
		public var uid:String;
		
		private var _name:String
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get id():*
		{
			return uid
		}
		
		public function get isGlobal():Boolean
		{
			if(node == null) return false;
			return StringTWLUtil.beginsWith(node.path,"all.global.");
		}
		
		//是从文件中创建的
		public var meshComp:D3ObjectMesh;
		public var materialComp:D3ObjectMaterial;
		public var particleComp:D3ObjectParticle;
		public var parentObject:D3ObjectBase;
		
		////////////////////////////////// attri //////////////////////////////
		
		public function get group():int
		{
			return -1;
		}

		private var _compItem:ID3CompItem;
		public function get compItem():ID3CompItem
		{
			return _compItem;
		}
		public function set compItem(value:ID3CompItem):void
		{
			_compItem = value;
		}
		
		public var file:File;
		public var configData:D3ResData;
		public var proccess:D3CompProcessBase;
		public var node:D3TreeNode;
		
		public function get isBranch():Boolean
		{
			if(node == null) return false;
			return node.isBranch;
		}
		
		public function get isMethod():Boolean
		{
			return false;
		}
		
		////////////////////////////// function //////////////////////////////////////
		
		public function checkIsInProject():Boolean
		{
			if(fromUI == 0){
				SandyError.error("D3ObjectBase fromUI is 0");
			}
			return fromUI == D3ComponentConst.from_project
		}
		
		public function getD3ObjProccess():D3ProccessObject
		{
			return proccess as D3ProccessObject;
		}
				
		public function readObject():void
		{
			if(configData!=null) return ;
			createConfigData()
			configData.readObject();
		}
		
		//convertObjectXML -- 创建
		public function readConfigData(d:D3ResData):void
		{
			configData = d;
			configData.comp = this;
		}
		
		public function readObjectXML(x:*):void
		{
			if(configData!=null) return ;
			createConfigData();
			configData.readXML(x);
		}
		
		protected function createConfigData():void
		{
			if(configData == null){
				configData = new D3ResData();
				configData.comp = this;
			}
		}
		
		public function getGroups():Array
		{
			var a:Array = [];
			if(compItem!=null){
				if(fromUI == D3ComponentConst.from_outline){
					if(group == D3ComponentConst.comp_group8 || group == D3ComponentConst.comp_group9){
						b = compItem.outline_attri2.split(",");
					}else{
						var b:Array = compItem.outline_attri.split(",");
					}
				}else if(fromUI == D3ComponentConst.from_project){
					b = compItem.project_attri.split(",");
				}
				for(var i:int=0;i<b.length;i++){
					if(a.indexOf(b[i])==-1){
						a.push(b[i]);
					}
				}
			}
			if(configData!=null){
				b = a.concat(configData.getGroups());
				for(i=0;i<b.length;i++){
					if(a.indexOf(b[i])==-1){
						a.push(b[i]);
					}
				}
			}
			return a;
		}
		
		public function dispose():void
		{
			if(proccess!=null)proccess.dispose();
			if(node!=null)node.dispose();
		}
		
		public function clone():*
		{
			var d:D3ObjectBase = new D3ObjectBase(fromUI);
			ToolUtils.clone(this,d);
			return d;
		}
		
		public static function getObject(f:File):D3ObjectBase
		{
			if(f.isDirectory){
				return new D3ObjectGroup(D3ComponentConst.from_project);
			}
			if(StringTWLUtil.isWhitespace(f.extension)) return null;
			if(f.extension.toLowerCase() == D3ComponentConst.sign_1){
				return new D3ObjectMaterial(D3ComponentConst.from_project);
			}
			if(f.extension.toLowerCase() == D3ComponentConst.sign_3){
				return new D3ObjectMesh(D3ComponentConst.from_project);
			}
			if(f.extension.toLowerCase() == D3ComponentConst.sign_4){
				return new D3ObjectAnim(D3ComponentConst.from_project);
			}
			if(f.extension.toLowerCase() == D3ComponentConst.sign_5 || f.extension.toLowerCase() == D3ComponentConst.sign_6){
				return new D3ObjectParticle(D3ComponentConst.from_project);
			}
			if(f.extension.toLowerCase() == D3ComponentConst.sign_8){
				return new D3ObjectTexture(D3ComponentConst.from_project);
			}
			return null;
		}
		
		public static function getObjectByGroup(group:int,from:int):D3ObjectBase
		{
			if(group == D3ComponentConst.comp_group1){
				return new D3Object(from);
			}
			if(group == D3ComponentConst.comp_group4){
				return new D3ObjectMaterial(from);
			}
			if(group == D3ComponentConst.comp_group6){
				return new D3ObjectTexture(from);
			}
			if(group == D3ComponentConst.comp_group8){
				return new D3ObjectAnim(from);
			}
			if(group == D3ComponentConst.comp_group10){
				return new D3ObjectParticle(from);
			}
			if(group == D3ComponentConst.comp_group5){
				return new D3ObjectGroup(from);
			}
			if(group == D3ComponentConst.comp_group7){
				return new D3ObjectMesh(from);
			}
			if(group == D3ComponentConst.comp_group9){
				return new D3ObjectBind(from);
			}
			if(group == D3ComponentConst.comp_group11){
				return new D3ObjectGeometry(from);
			}
			if(group == D3ComponentConst.comp_group12){
				return new D3ObjectWireframe(from);
			}
			if(group == D3ComponentConst.comp_group2){
				return new D3ObjectLight(from);
			}
			if(group == D3ComponentConst.comp_group3){
				return new D3ObjectTerrain(from);
			}
			if(group == D3ComponentConst.comp_group14){
				return new D3ObjectCamera(from);
			}
			return null;
		}
		
		public function selected():void
		{
			D3SceneManager.getInstance().currScene.noSelected()
		}
		
		public function objectSave():Object
		{
			if(configData == null) return null;
			var obj:Object = configData.objectSave();
			return obj;
		}
		
		//D3MapItem
		public function d3ObjectToReflashAttri(m:ObjectContainer3D):void
		{
			var a:Array = D3ComponentConst.d3CompToReflashAttri_ls;
			for(var i:int=0;i<a.length;i++){
				var d:D3ComAttriItemVO = a[i] as D3ComAttriItemVO;
				if(d.id == 114){
					configData.putAttri(d.key,m.position.clone())
				}else if(d.id == 115){
					configData.putAttri(d.key,m.eulers.clone())
				}else if(d.id == 116){
					configData.putAttri(d.key,m.scaleVector3D.clone())
				}else{
					if(m.hasOwnProperty([d.key])){
						configData.putAttri(d.key,m[d.key]);
					}
				}
			}
			if(D3SceneManager.getInstance().displayList.selectedAttriView!=null){
				D3SceneManager.getInstance().displayList.selectedAttriView.d3ObjectToReflashAttri(this);
			}
			D3ProjectCache.dataChange = true;
		}
		
		public function d3ObjectToRefOneAttri(key:String,m:*):void
		{
			var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemByKey(key);
			if(d == null) return ;
			configData.putAttri(key,m);
			
			if(D3SceneManager.getInstance().displayList.selectedAttriView!=null){
				D3SceneManager.getInstance().displayList.selectedAttriView.d3ObjectToReflashAttri(this);
			}
			D3ProjectCache.dataChange = true;
		}
		
		protected function reflashAttriNow():void
		{
			if(D3SceneManager.getInstance().displayList.selectedAttriView){
				D3SceneManager.getInstance().displayList.selectedAttriView.reflashAttriNow(this);
			}
		}
		
	}
}
