package com.editor.d3.object
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.lightpickers.StaticLightPicker;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.scene.grid.vo.GizmoMode;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessAnim;
	import com.editor.d3.process.D3ProccessBindBone;
	import com.editor.d3.process.D3ProccessMaterial;
	import com.editor.d3.process.D3ProccessMesh;
	import com.editor.d3.process.D3ProccessObject;
	import com.editor.d3.process.D3ProccessParticle;
	import com.editor.d3.process.D3ProccessTexture;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.d3.vo.method.D3MethodItemVO;
	import com.editor.model.AppMainModel;
	import com.sandy.error.SandyError;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	import com.sandy.utils.UIDUtil;
	
	import flash.filesystem.File;
	import flash.geom.Vector3D;

	public class D3Object extends D3ObjectBase
	{
		public function D3Object(from:int)
		{
			super(from);
			proccess = new D3ProccessObject(this);
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group1;
		}

		public function getMeshFile():File
		{
			if(StringTWLUtil.isWhitespace(configData.getAttri("mesh"))) return null;
			return new File(D3ProjectFilesCache.getInstance().addProjectResPath(configData.getAttri("mesh")))
		}
		
		public function getMaterialFile():File
		{
			if(StringTWLUtil.isWhitespace(configData.getAttri("material"))) return null;
			return new File(D3ProjectFilesCache.getInstance().addProjectResPath(configData.getAttri("material")))
		}
		
		public function getParticleFile():File
		{
			if(StringTWLUtil.isWhitespace(configData.getAttri("particle"))) return null;
			return new File(D3ProjectFilesCache.getInstance().addProjectResPath(configData.getAttri("particle")))
		}
		
		//Select3DCompEventInterceptor
		override public function selected():void
		{
			if(proccess is D3ProccessObject){
				D3ProccessObject(proccess).selectObject();
			}
		}
		
		
		////////////////////////////////////// anim ///////////////////////////////////
		
		public var animComps:Array = [];
		
		public function addAnimComp(d:D3ObjectAnim):void
		{
			if(getAnimByName(d.name)!=null)	return ;
			animComps.push(d);
		}
		
		public function removeAnim(d:D3ObjectAnim,_ref:Boolean=true):void
		{
			if(d == null) return ;
			if(animComps == null) return ;
			var n1:int = animComps.indexOf(d);
			if(n1>=0){
				var currPlayAnim:String = proccess.mapItem.currPlayingAnim;
				if(currPlayAnim == d.name){
					proccess.mapItem.stopAnim();
				}
				animComps.splice(n1,1);
				proccess.mapItem.removeAnim(d)
				if(_ref)D3SceneManager.getInstance().displayList.selectedAttriView.reflashAttriNow(this);
				playLastAnim();
			}
		}
		
		public function removeAllAnim():void
		{
			proccess.mapItem.stopAnim();
			for(var i:int=0;i<animComps.length;i++){
				removeAnim(animComps[i],false);
			}
			D3SceneManager.getInstance().displayList.selectedAttriView.reflashAttriNow(this);
		}
		
		public function getAnimByName(n:String):D3ObjectAnim
		{
			if(animComps == null) return null;
			for(var i:int=0;i<animComps.length;i++){
				if(D3ObjectAnim(animComps[i]).name == n){
					return animComps[i] as D3ObjectAnim;
				}
			}
			return null;
		}
		
		public function parserAnimFromXML():void
		{
			var a:Array = configData.getAttri("anims") as Array
			if(a == null) return ;
			for(var i:int=0;i<a.length;i++){
				var obj:Object = a[i];
				createAnimObject(obj);
			}
		}
		
		public function createAnimObject(obj:Object):void
		{
			var d:D3ObjectAnim = new D3ObjectAnim(D3ComponentConst.from_outline);
			d.compItem = D3ComponentProxy.getInstance().com_ls.getItemById(13);
			d.name = obj.name;
			d.parentObject = this
			d.readObjectXML(obj);
			addAnimComp(d);
		}
		
		private function animsSave():Array
		{
			var b:Array = [];
			for(var i:int=0;i<animComps.length;i++){
				var d:D3ObjectAnim = animComps[i] as D3ObjectAnim;
				b.push(d.objectSave());
			}
			return b;
		}
		
		public function getDefaultAnim():D3ObjectAnim
		{
			for(var i:int=0;i<animComps.length;i++){
				var d:D3ObjectAnim = animComps[i] as D3ObjectAnim;
				if(d.isDefault){
					return d;
				}
			}
			return null;
		}
		
		public function playDefaultAnim():void
		{
			var d:D3ObjectAnim = getDefaultAnim();
			if(d!=null){
				d.playAnim();
			}
		}
		
		//如果只有一个anim,自动设置isDefault=true,并且播放
		public function playLastAnim():void
		{
			if(animComps.length == 1){
				D3ObjectAnim(animComps[0]).configData.putAttri("isDefault",true);
				D3ObjectAnim(animComps[0]).playAnim();
			}
		}
		
		public function setNotAllAnim():void
		{
			for(var i:int=0;i<animComps.length;i++){
				var d:D3ObjectAnim = animComps[i] as D3ObjectAnim;
				d.configData.putAttri("isDefault",false);	
			}
		}
	
		
		/////////////////////////////////// bones ///////////////////////////////
		
		public var bindBones:Array = [];
		
		public function addBindBone(d:D3ObjectBind):void
		{
			if(getBindBoneByName(d.name)!=null)	return ;
			bindBones.push(d);
		}
		
		public function getBindBoneByName(n:String):D3ObjectBind
		{
			if(bindBones == null) return null;
			for(var i:int=0;i<bindBones.length;i++){
				if(D3ObjectBind(bindBones[i]).name == n){
					return bindBones[i] as D3ObjectBind;
				}
			}
			return null;
		}
		
		private function bonesSave():Array
		{
			var b:Array = [];
			for(var i:int=0;i<bindBones.length;i++){
				var d:D3ObjectBind = bindBones[i] as D3ObjectBind;
				b.push(d.objectSave());
			}
			return b;
		}
		
		//一个骨骼绑定一个对象，也有可能一个骨骼绑定多个对象，共用一个bingTag
		public function bindBoneToObject(d:D3ObjectBind):Boolean
		{
			if(getD3ObjProccess().bindObject(d)){
				D3ProjectCache.dataChange = true;
				return true;
			}
			return false;
		}
		
		public function unBindObject(d:D3ObjectBind,_ref:Boolean=true):void
		{
			for(var i:int=0;i<bindBones.length;i++){
				if(D3ObjectBind(bindBones[i]).uid == d.uid){
					bindBones.splice(i,1);
					break;
				}
			}
			if(d.bindObject)D3ProccessObject(d.bindObject.proccess).resteAddMapItem();
			getD3ObjProccess().unBindObject(d);
			if(_ref)D3SceneManager.getInstance().displayList.selectedAttriView.reflashAttriNow(this);
		}
		
		public function unPreBindObject(d:D3ObjectBind):void
		{
			getD3ObjProccess().unPreBindObject(d);
			if(d.pre_bindObject != null){
				D3ProccessObject(d.pre_bindObject.proccess).resteAddMapItem();
			}
		}
		
		public function unAllBindObject():void
		{
			for(var i:int=0;i<bindBones.length;i++){
				unBindObject(bindBones[i],false);
			}
			D3SceneManager.getInstance().displayList.selectedAttriView.reflashAttriNow(this);
		}
		
		public function parserBoneFromXML():void
		{
			var a:Array = configData.getAttri("bones") as Array
			if(a == null) return ;
			for(var i:int=0;i<a.length;i++){
				var obj:Object = a[i];
				createBoneObject(obj);
			}
		}
		
		public function createBoneObject(obj:Object):void
		{
			var d:D3ObjectBind = new D3ObjectBind(D3ComponentConst.from_outline);
			d.compItem = D3ComponentProxy.getInstance().com_ls.getItemById(14);
			d.name = obj.name;
			d.parentObject = this;
			d.readObjectXML(obj);
			addBindBone(d);
		}
		
		public function bindAllBones():void
		{
			for(var i:int=0;i<bindBones.length;i++){
				var d:D3ObjectBind = bindBones[i] as D3ObjectBind;
				_bindAllBones(d);
			}
		}
		
		private function _bindAllBones(d:D3ObjectBind):void
		{
			if(d.bindObject == null){
				D3SceneManager.getInstance().displayList.addLaterBind(d)
			}else{
				if(d.bindObject.proccess.mapItem.getObject() == null){
					D3SceneManager.getInstance().displayList.addLaterBind(d)	
				}else{
					bindBoneToObject(d);
				}
			}
		}
		
		
		/////////////////////////// light ////////////////////////////
		
		public var light_a:Array = [];
		public var lightPicker:StaticLightPicker;
		
		public function addLight(l:D3ObjectLight):void
		{
			if(light_a.indexOf(l)==-1){
				light_a.push(l);
				reflashLightBase()
			}
		}
		
		public function removeLight(l:D3ObjectLight):void
		{
			var n:int = light_a.indexOf(l);
			if(n>=0){
				light_a.splice(n,1);
				reflashLightBase()
			}
		}
		
		public function removeAllLights():void
		{
			light_a=null;light_a=[];
			lightPicker = null;
			if(proccess.mapItem!=null){
				proccess.mapItem.setLight();
			}
		}
		
		public function reflashLightBase():void
		{
			if(light_a.length>0){
				var a:Array = getLightBase();
				if(a.length > 0){
					lightPicker = new StaticLightPicker(a);
				}else{
					lightPicker = null;
				}
			}else{
				lightPicker = null;
			}
		}
		
		private function getLightBase():Array
		{
			var a:Array = [];
			for(var i:int=0;i<light_a.length;i++){
				var l:D3ObjectLight = light_a[i] as D3ObjectLight;
				if(l.selectedLight != null){
					if(a.indexOf(l.selectedLight)==-1){
						a.push(l.selectedLight);
					}
				}
			}
			return a;
		}
		
		private function lightsSave():Array
		{
			var an:Array = [];
			var a:Array = [];
			for(var i:int=0;i<light_a.length;i++){
				var l:D3ObjectLight = light_a[i] as D3ObjectLight;
				if(l.selectedLight != null){
					if(a.indexOf(l.selectedLight)==-1){
						a.push(l.selectedLight);
						an.push(l.name);
					}
				}
			}
			return an;
		}
		
		public function parserLights():void
		{
			if(configData!=null){
				var s:String = configData.getAttri("lights");
				if(!StringTWLUtil.isWhitespace(s)){
					var a:Array = s.split(",");
					for(var i:int=0;i<a.length;i++){
						if(!_parserLight(a[i])) return ;
					}
					
					var f:String = AppMainModel.getInstance().applicationStorageFile.curr_3dOutlineUID;
					if(!StringTWLUtil.isWhitespace(f)){
						if(f == node.path){
							reflashAttriNow()
						}
					}
				}
			}
		}
		
		private function _parserLight(p:String):Boolean
		{
			if(StringTWLUtil.isWhitespace(p)) return false;
			var d:D3TreeNode = D3SceneManager.getInstance().displayList.rootNode.getAllChild(p) as D3TreeNode;
			if(d!=null){
				var ld:D3ObjectLight = d.object as D3ObjectLight;
				if(ld.getLight()==null){
					D3SceneManager.getInstance().displayList.addLaterLight(p,this);
					return false;
				}
				var ld2:D3ObjectLight = new D3ObjectLight(D3ComponentConst.from_outline);
				ld2.object = this;
				ld2.name = d.path;
				ld2.selectedLight = ld.getLight();
				addLight(ld2);
				return true
			}else{
				D3SceneManager.getInstance().displayList.addLaterLight(p,this);
			}
			return false;
		}
		
		public function reflashLight():void
		{
			proccess.mapItem.setLight();
		}
		
		
		////////////////////////////  method  /////////////////////////////
		
		public var method_ls:Array = [];
		
		public function addMethod(d:D3ObjectMethod):void
		{
			if(method_ls.indexOf(d)==-1){
				d.readObject();
				method_ls.push(d);
			}
		}
		
		public function removeMethod(d:D3ObjectMethod):void
		{
			if(d == null) return ;
			var n:int = method_ls.indexOf(d);
			if(n>=0){
				method_ls.splice(n,1);
			}
		}
		
		public function getMethodNames(d:D3MethodItemVO):String
		{
			var a:Array = [];
			for(var i:int=0;i<method_ls.length;i++){
				var n:String = D3ObjectMethod(method_ls[i]).name;
				if(!StringTWLUtil.isWhitespace(n)){
					if(n.indexOf(d.name)!=-1){
						a.push(D3ObjectMethod(method_ls[i]));
					}
				}
			}
			return d.name+(a.length+1);
		}
		
		private function methodSave():Array
		{
			var a:Array = [];
			for(var i:int=0;i<method_ls.length;i++){
				if(D3ObjectMethod(method_ls[i]).compItem != null){
					a.push(D3ObjectMethod(method_ls[i]).objectSave());
				}
			}
			return a;
		}
		
		public function parserMethods():void
		{
			var a:Array = configData.getAttri("methods") as Array;
			if(a!=null&&a.length>0){
				for(var i:int=0;i<a.length;i++){
					_createMethod(a[i]);
				}
			}
		}
		
		private function _createMethod(obj:Object):void
		{
			var d:D3ObjectMethod = new D3ObjectMethod(D3ComponentConst.from_outline);
			d.parentObject = this;
			d.readObjectXML(obj);
			d.compItem = D3ComponentProxy.getInstance().method_ls.getItemById(d.configData.getAttri("compId"));
			if(d.compItem == null){
				SandyError.error("method compItem is null");
			}
			addMethod(d);
			d.addMethodToMaterial();
		}
		
		public function reflashAllMethod():void
		{
			for(var i:int=0;i<method_ls.length;i++){
				D3ObjectMethod(method_ls[i]).addMethodToMaterial();
			}
		}
		
		public function removeAllMethod():void
		{
			for(var i:int=0;i<method_ls.length;i++){
				D3ObjectMethod(method_ls[i]).removeMethodToMaterial()
			}
			method_ls=null;method_ls=[];
		}
		
		/////////////////////////////////////////////////////////
		
		override public function clone():*
		{
			var d:D3Object = new D3Object(fromUI);
			ToolUtils.clone(this,d);
			return d;
		}
		
		override public function objectSave():Object
		{
			if(animComps.length>0){
				configData.putAttri("anims",animsSave());					
			}else{
				configData.removeAttri("anims");
			}
			
			if(bindBones.length > 0){
				configData.putAttri("bones",bonesSave());
			}else{
				configData.removeAttri("bones");
			}
			
			var a:Array = lightsSave();
			if(a.length > 0){
				configData.putAttri("lights",a);
			}else{
				configData.removeAttri("lights");
			}
			
			a = methodSave();
			if(a.length > 0){
				configData.putAttri("methods",a);
			}else{
				configData.removeAttri("methods");
			}
			
			return configData.objectSave()
		}
		
	}
}