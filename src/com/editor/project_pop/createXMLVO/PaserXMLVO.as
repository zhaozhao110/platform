package com.editor.project_pop.createXMLVO
{
	import com.sandy.utils.StringTWLUtil;

	public class PaserXMLVO
	{
		public function PaserXMLVO()
		{
		}
		
		//xml 里的id
		public var xml:String;
		//as 里的id
		public var vo:String;
		//注释
		public var info:String;
		//类型,只有字符串和数字
		public var isNumber:Boolean;
		
		public var isGroup:Boolean;
		
		public function getId():String
		{
			if(StringTWLUtil.isWhitespace(vo)){
				return xml;
			}
			return vo;
		}
		
		public function create():Object
		{
			var obj:Object = {};
			obj.vars = "";
			if(!StringTWLUtil.isWhitespace(info)){
				obj.vars += createSpace()+"/**"+info+"**/;"+NEWLINE_SIGN;
			}
			obj.vars += createSpace()+"public"+" "+"var"+" "+getId()+":";
			if(isNumber){
				obj.vars += "Number;"+NEWLINE_SIGN;
			}else{
				obj.vars += "String;"+NEWLINE_SIGN;
			}
			obj.txt = createSpace()+getId()+" = x.@"+xml+";"+NEWLINE_SIGN;
			return obj;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
	}
}