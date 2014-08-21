package com.editor.project_pop.serverCode
{
	import com.sandy.utils.StringTWLUtil;

	public class CreateServerCodeVO
	{
		public function CreateServerCodeVO()
		{
		}
		
		public var funName:String;
				
		public var info:String = "";
		public var byte_n:int;
		public var isString:Boolean;
		public var cont:String = "";
		public var while_b:Boolean;
		public var while_a:Boolean;
		
		public function get name():String
		{
			if(while_b){
				return "循环体开始"
			}
			if(while_a){
				return "循环体结束"	
			}
			return cont;
		}
		
		public function createAS():String
		{
			var s:String = "";
			if(StringTWLUtil.isWhitespace(name)){
				return s;
			}
			s += createSpace(4);
			if(while_b){
				s += "while(proxy.bytesAvailable()){"+NEWLINE_SIGN;
			}else if(while_a){
				s += "}"+NEWLINE_SIGN;
			}else if(isString){
				s += "/**"+cont+"**/"+NEWLINE_SIGN;
				s += createSpace(4)+"proxy.addMutableString();"+NEWLINE_SIGN;
			}else{
				if(byte_n == 1){
					s += "/**"+cont+"**/"+NEWLINE_SIGN;
					s += createSpace(4)+"proxy.addByteData();"+NEWLINE_SIGN;
				}else if(byte_n == 2){
					s += "/**"+cont+"**/"+NEWLINE_SIGN;
					s += createSpace(4)+"proxy.addShortData();"+NEWLINE_SIGN;
				}else if(byte_n == 4){
					s += "/**"+cont+"**/"+NEWLINE_SIGN;
					s += createSpace(4)+"proxy.addIntData();"+NEWLINE_SIGN;
				}else if(byte_n == 8){
					s += "/**"+cont+"**/"+NEWLINE_SIGN;
					s += createSpace(4)+"proxy.addDoubleData();"+NEWLINE_SIGN;
				}
			}
			return s;
		}
		
		//加密密钥字节数组（8个字节）
		public function parser(s:String):void
		{
			s = StringTWLUtil.trim(s);
			cont = s;
			var ind:int = s.indexOf("个字节");
			if(ind >= 0){
				byte_n = int(s.substring(ind-1,ind));
			}else{
				ind = s.indexOf("字节");
				if(ind >= 0){
					byte_n = int(s.substring(ind-1,ind));
				}
			}
			ind = s.indexOf("可变字符串");
			if(ind >= 0){
				isString=true
			}else{
				ind = s.indexOf("可变长度字符串");
				if(ind >= 0){
					isString = true;
				}
			}
			
			ind = s.indexOf("（");
			if(ind >= 0){
				info = s.substring(0,ind);
			}else{
				ind = s.indexOf("(");
				if(ind >= 0){
					info = s.substring(0,ind);
				}
			}
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