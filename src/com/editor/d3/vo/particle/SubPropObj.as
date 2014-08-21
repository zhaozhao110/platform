package com.editor.d3.vo.particle
{
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;

	public class SubPropObj extends Object
	{
		public function SubPropObj()
		{
		}
		
		private var _enabled:Boolean=true;
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		public var index:int;
		public var type:*;
		public var name:String;
		
		private var _id:String = ""
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			_id = value;
		}
		
		public var attri_ls:Array = [];
		
		public var data:Object;
		
		public var attriType:int;
		
		public function clear():void
		{
			data = null;
			data = {};
		}
		
		public function putAttri(k:String,v:*):void
		{
			if(data == null) data = {};
			if(id == "OneDConstValueSubParser"){
				data.value = v;
			}else{
				
				if(attriType == 1){
					if(k.indexOf("scale")!=-1){
						data[k.substring(k.length-1,k.length).toLowerCase()] = v;
						return ;
					}
					if(k.indexOf("rotation")!=-1){
						data[k.substring(k.length-1,k.length).toLowerCase()] = v;
						return ;
					}
				}
				
				data[k] = v;
			}
		}
		
		public function removeAttri(k:String):void
		{
			if(data == null) return ;
			delete data[k];
		}
		
		public function getAttri(k:String):*
		{
			if(data == null) return null;
			if(id == "OneDConstValueSubParser"){
				return data.value;
			}
			return data[k]
		}
		
		public function checkAttri(k:String):Boolean
		{
			if(data == null) return false;
			return data.hasOwnProperty(k);
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			if(!StringTWLUtil.isWhitespace(id)){
				obj.id = id;
			}
			if(!StringTWLUtil.isWhitespace(type)){
				obj.type = type;
			}
			if(!StringTWLUtil.isWhitespace(name)){
				obj.name = name
			}
			if(data!=null)obj.data = data;
			return obj;
		}
		
		public function cloneAddObject(obj:Object):void
		{
			for(var key:String in obj){
				putAttri(key,obj[key]);
			}
		}
		
		public function initAttri(a:Array):void
		{
			attri_ls = a;
			if(a.length == 3){
				id = "ThreeDConstValueSubParser"
			}else if(a.length == 1){
				id = "OneDConstValueSubParser"
			}
			for(var i:int=0;i<attri_ls.length;i++){
				var d:D3ComAttriItemVO = getItemById(int(attri_ls[i]));
				if(d!=null){
					putAttri(d.key,d.defaultValue);
				}
			}
		}
		
		public function parser(obj:Object):void
		{
			if(obj == null) return ;
			if(!StringTWLUtil.isWhitespace(obj["id"])) id = obj["id"];
			if(!StringTWLUtil.isWhitespace(obj["type"])) type = obj["type"]
			if(!StringTWLUtil.isWhitespace(obj["name"])) name = obj["name"]
		
			for(var key:String in obj.data){
				putAttri(key,obj.data[key]);
				enabled = true
			}
		}
		
		public function clone():Object
		{
			return ToolUtils.originalClone(this) as Object
		}
		
		protected function getItemById(d:int):D3ComAttriItemVO
		{
			return D3ComponentProxy.getInstance().particle_attri_ls.getItemById(d.toString());
		}
	}
}