package com.editor.module_ui.vo.expandComp
{
	import com.sandy.utils.XMLToJson;

	public class ExpandCompItemVO
	{
		public function ExpandCompItemVO(x:XML)
		{
			parser(x);
		}
		
		public var attri_ls:Array = [];
		
		private function parser(x:XML):void
		{
			var p:XMLToJson = new XMLToJson();
			var obj:Object = p.parse(x);
			
			for(var key:String in obj){
				if(key != "_content"){
					if(key == "type"){
						attri_ls["type"] = obj[key];
					}else{
						var a:Array = String(obj[key]).split("*");
						attri_ls[key] = {value:a[0],dataType:a[1]}
					}
				}
			}
		}
		
		public function checkIsProxyComp():Boolean
		{
			return type == "ProxyComp";
		}
		
		public function get type():String
		{
			return attri_ls["type"];
		}
		
		public function getValue(key:String):*
		{
			return attri_ls[key]
		}
		
		public function addAttri(key:String,obj:Object):void
		{
			attri_ls[key] = obj;
		}
		
		public function removeAttri(key:String):void
		{
			attri_ls[key] = null;
		}
		
		public function createXML():String
		{
			var out:String = "<item ";
			for(var key:String in attri_ls){
				if(key == "type"){
					out += key+'="'+type+'" ';	
				}else{
					var obj:Object = attri_ls[key];
					if(obj!=null){
						out += key+'="'+obj.value+"*"+obj.dataType+'" ';
					}
				}
			}
			out += " />"
			return out;
		}
		
		
		
	}
}