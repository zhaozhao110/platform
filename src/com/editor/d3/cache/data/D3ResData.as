package com.editor.d3.cache.data
{
	import com.air.io.ReadFile;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectMesh;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.tool.D3ReadFile;
	import com.editor.d3.tool.D3ReadImage;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.editor.d3.vo.method.D3MethodItemVO;
	import com.editor.d3.vo.particle.ParticleObj;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	public class D3ResData
	{
		public function D3ResData()
		{
		}
		
		public var saveObj:Object;
		
		private var _comp:D3ObjectBase;
		public function get comp():D3ObjectBase
		{
			return _comp;
		}
		public function set comp(value:D3ObjectBase):void
		{
			_comp = value;
			call_later_putAttri();
		}

		public var file:File;
		//bitmap,bitmapData,mesh,anim,byteArray,string
		public var content:*;
		//最后退出的时候检测是否需要保存
		public var changed:Boolean = true;
		public var attr_map:HashMap = new HashMap();
		
		
		public function clone():D3ResData
		{
			var d:D3ResData = new D3ResData();
			d.attr_map = this.attr_map.cloneObject();
			d.saveObj = ToolUtils.originalClone(saveObj);
			d.comp = comp;
			d.file = file.clone();
			d.content = content;
			return d;
		}
		
		public function getAttris():Array
		{
			var b:Array = [];
			var a:Array = attr_map.getKeys();
			for(var i:int=0;i<a.length;i++){
				var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemByKey(a[i])
				if(d!=null){
					b.push(d.id);
				}
			}
			return b;
		}
		
		//d3scene里的数据
		public function getGroups():Array
		{
			if(StringTWLUtil.isWhitespace(getAttri("groups"))) return [];
			return String(getAttri("groups")).split(",");
		}
		
		private function putCommonAttri():void
		{
			if(comp == null) return ;
			if(!checkAttri("name"))putAttri("name",comp.name);
			if(comp.compItem&&!checkAttri("compId"))putAttri("compId",comp.compItem.id);
			if(comp.compItem&&!checkAttri("group1"))putAttri("group1",comp.compItem.group);
		}
		
		//file 变成路径 ， name 会赋值objectBase
		public function putAttri(k:String,v:*):void
		{
			if(StringTWLUtil.isWhitespace(k)) return ;
			if(k == "uid") return ;
			if(k == "visible") return ;
			
			var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemByKey(k);
			
			if(v is File){
				putAttri(k,D3ProjectFilesCache.getInstance().getProjectResPath((v as File)));
				return ;
			}
						
			if(d!=null){
				if(d.expand == "method"){
					create_method(d,v)
					return ;
				}
				if(d.value == "vector3D"){
					v = new Vector3D(v.x,v.y,v.z);		
				}
			}
			
			if(k == "name"){
				if(!StringTWLUtil.isWhitespace(v)){
					if(comp!=null){
						comp.name = v;	
					}
				}
			}
			attr_map.put(k,v);
		}
		
		private var _laterPutAttri_ls:Array = [];
		private function later_putAttri(d:D3ComAttriItemVO,v:*):void
		{
			_laterPutAttri_ls[d.key] = {data:d.key,data2:v};
		}
		
		public function call_later_putAttri():void
		{
			if(comp == null) return ;
			for(var key:String in _laterPutAttri_ls){
				var obj:Object = _laterPutAttri_ls[key]
				putAttri(obj.data,obj.data2);
			}
			_laterPutAttri_ls = null;_laterPutAttri_ls = [];
		}
		
		private function create_method(d:D3ComAttriItemVO,v:*):void
		{
			if(comp == null){
				later_putAttri(d,v);
				return ;
			}
			
			if(v is D3ObjectMethod){
				attr_map.put(d.key,v);
				v.medthodProccess.reflashMethod(d.key)
				return ;
			}
			
			var md:D3ObjectMethod = new D3ObjectMethod(comp.fromUI);
			md.parentObject = comp;
			if(v is D3MethodItemVO){
				md.readObject();
				md.compItem = (v as D3MethodItemVO).cloneObject();
			}else{
				md.readObjectXML(v);
				if(!md.configData.checkAttri("compId")) return ;
				md.compItem = D3ComponentProxy.getInstance().method_ls.getItemById(md.configData.getAttri("compId")).cloneObject();
			}
			attr_map.put(d.key,md);
			md.medthodProccess.reflashMethod(d.key)
		}
		
		public function getAttri(k:String):*
		{
			return attr_map.find(k);
		}
		
		public function getAttriById(k:int):*
		{
			return attr_map.find(D3ComponentProxy.getInstance().attri_ls.getItemById(k.toString()).key);
		}
		
		public function checkAttri(k:String):Boolean
		{
			return attr_map.exists(k);
		}
		
		public function getAttriObj():Object
		{
			return attr_map.getContent();
		}
		
		public function objectSave():Object
		{
			var obj2:Object = {};
			var obj:Object = attr_map.getContent();
			for(var ele:String in obj){
				var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemByKey(ele);
				if(d!=null){
					if(!d.disabled){
						saveAttri(ele,obj[ele],obj,obj2)
					}
				}else{
					saveAttri(ele,obj[ele],obj,obj2)
				}
			}
			return obj2;
		}
		
		public function readObject2(obj:Object):void
		{
			var key:String;
			var element:*;
			for(key in obj) {
				element = obj[key];
				if(StringTWLUtil.isNumber(key)){
					var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemById(key);
					if(d)putAttri(d.key,element);
				}else{
					putAttri(key,element);
				}
			}
		}
		
		public function removeGroup(d:D3GroupItemVO):void
		{
			var s:String = d.attri;
			var a:Array = s.split(",");
			for(var i:int=0;i<a.length;i++){
				var it:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemById(a[i]);
				if(it!=null)removeAttri(it.key);
			}
			s = d.attri2;
			a = s.split(",");
			for(i=0;i<a.length;i++){
				it = D3ComponentProxy.getInstance().attri_ls.getItemById(a[i]);
				if(it!=null)removeAttri(it.key);
			}
			removeCustomGroup(d);
		}
		
		public function removeAttri(k:String):void
		{
			attr_map.remove(k);
		}
		
		//////////////////////////////// save //////////////////////////////////
		
		public function getXMLString():String
		{
			var obj2:Object = getAttriObj();
			var obj:Object = {};
			for(var k:String in obj2){
				var v:* = obj2[k]
				saveAttri(k,v,obj2,obj);
			}
			return JSON.stringify(obj);
		}
		
		private function saveAttri(k:String,v:*,obj1:Object,obj2:Object):void
		{
			if(StringTWLUtil.isWhitespace(v)) return ;
			var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemByKey(k);
			if(v is D3ObjectMethod){
				if(d!=null){
					obj2[d.id.toString()] = D3ObjectMethod(v).objectSave();
				}else{
					obj2[k] = D3ObjectMethod(v).objectSave();
				}
			}else if(v is Vector3D){
				if(d!=null){
					obj2[d.id.toString()] = {x:v.x,y:v.y,z:v.z}
				}else{
					obj2[k] = {x:v.x,y:v.y,z:v.z}
				}
			}else{
				if(d!=null){
					obj2[d.id.toString()] = v
				}else{
					obj2[k] = v
				}
			}
		}
		
		//////////////////////////////// xml //////////////////////////////////
		
		//c:string , bytearray
		public function readXML(c:*):void
		{
			content = c;
			if(c is String){
				if(!StringTWLUtil.isWhitespace(c)){
					c = JSON.parse(c);
				}
			}
			if(c is ByteArray){
				
			}else{
				if(!StringTWLUtil.isWhitespace(c)){
					readObject2(c);
				}
			}
			putCommonAttri();
		}
		
		
		
		
		//////////////////////////////// image /////////////////////////////////
		private var readImg:D3ReadImage;
		private var readImageEnd_f:Function;
		public function readImage(endF:Function=null):void
		{
			readImageEnd_f = endF;
			putCommonAttri()
			
			if(readImg == null){
				readImg = new D3ReadImage();
				readImg.complete_f = loadComplete;
			}
			readImg.loadImageFromFile(file);
		}
		
		private function loadComplete(b:Bitmap):void
		{
			content = b;
			putAttri("width",b.width);
			putAttri("height",b.height);
			if(readImageEnd_f!=null) readImageEnd_f();
			readImageEnd_f = null;
		}
		
		
		////////////////////////////// object /////////////////////////////////
		public function readObject():void
		{
			putCommonAttri();
			if(comp.group == D3ComponentConst.comp_group1 ||
				comp.group == D3ComponentConst.comp_group7 ||				
				comp.group == D3ComponentConst.comp_group10){
				if(!checkAttri("x"))putAttri("x",0);
				if(!checkAttri("y"))putAttri("y",0);
				if(!checkAttri("z"))putAttri("z",0);
				if(!checkAttri("rotationX"))putAttri("rotationX",0);
				if(!checkAttri("rotationY"))putAttri("rotationY",0);
				if(!checkAttri("rotationZ"))putAttri("rotationZ",0);
				if(!checkAttri("scaleX"))putAttri("scaleX",1);
				if(!checkAttri("scaleY"))putAttri("scaleY",1);
				if(!checkAttri("scaleZ"))putAttri("scaleZ",1);
			}
		}
		
		public function addCustomGroup(d:D3GroupItemVO):void
		{
			var s:String = getAttri("groups");
			if(StringTWLUtil.isWhitespace(s)){
				s = "";
				putAttri("groups","");
			}
			var a:Array = s.split(",");
			if(a.indexOf(d.id.toString())==-1){
				a.push(d.id);
			}
			putAttri("groups",a.join(","));
		}
		
		public function removeCustomGroup(d:D3GroupItemVO):void
		{
			var s:String = getAttri("groups");
			if(StringTWLUtil.isWhitespace(s)) return ;
			var a:Array = s.split(",");
			var n:int = a.indexOf(d.id.toString())
			a.splice(n,1);
			putAttri("groups",a.join(","));
		}
		
		//////////////////////////// particle /////////////////////////////////
		
		public var particleObj:ParticleObj;
		
		public function readParticle(s:String):void
		{
			particleObj = new ParticleObj();
			particleObj.parser(s);
		}
		
	}
}