package com.editor.project_pop.serverCode
{
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.sandy.math.ArrayCollection;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class CreateServerCodeTool
	{
		public function CreateServerCodeTool()
		{
			if(instance == null){
				instance = this;
			}
		}
		
		public static var instance:CreateServerCodeTool;
		
		public var rec_ls:ArrayCollection = new ArrayCollection();
		
		public function dispose():void
		{
			rec_ls.removeAll();
		}
		
		public function parserRec(s:String):ArrayCollection
		{
			rec_ls.removeAll();
			s = StringTWLUtil.trim(s);
			if(StringTWLUtil.isWhitespace(s)) return rec_ls
			var a:Array = s.split("+");
			for(var i:int=0;i<a.length;i++){
				var item:CreateServerCodeVO = new CreateServerCodeVO();
				item.parser(a[i]);
				rec_ls.addItem(item);
			}
			return rec_ls;
		}
				
		public function createAS(m:CreateServerCodePopwinMediator):String
		{
			var pro_name:String = StringTWLUtil.setFristUpperChar(m.createWin.ti.text);
			var s:String = ""
			if(m.createWin.ti2.text.indexOf("/**")==-1){
				s += createSpace()+"/**"+m.createWin.ti2.text+"**/"+NEWLINE_SIGN;
			}else{
				s += createSpace()+m.createWin.ti2.text+NEWLINE_SIGN;
			}
			s += createSpace()+"public"+" "+"function"+" "+StringTWLUtil.setAllFristUpperChar(m.createWin.ti6.text)+"(buf:ISandyByteArray):"+pro_name+"SocketReceiveDataProxy"+NEWLINE_SIGN;
			s += createSpace()+"{"+NEWLINE_SIGN;
			s += createSpace(2)+"var proxy:"+pro_name+"SocketReceiveDataProxy = createSocketReceiveDataProxy(buf);"+NEWLINE_SIGN;
			s += createSpace(2)+"if(checkIsError(proxy.getErrorCode()))"+NEWLINE_SIGN;
			s += createSpace(2)+"{"+NEWLINE_SIGN;
			s += createSpace(4)+"parserError(proxy);"+NEWLINE_SIGN;
			s += createSpace(2)+"}else{"+NEWLINE_SIGN;
			var a:Array = rec_ls.source;
			for(var i:int=0;i<a.length;i++){
				var row_s:String = CreateServerCodeVO(a[i]).createAS();
				if(!StringTWLUtil.isWhitespace(row_s)){
					s += row_s;
				}
			}
			s += createSpace(2)+"}"+NEWLINE_SIGN;
			s += createSpace(2)+"return proxy;"+NEWLINE_SIGN;
			s += createSpace()+"}"+NEWLINE_SIGN;
			return s;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n)
		}
		
		
		public function copyCode(fl:File,t:String):Boolean
		{
			if(fl.isDirectory) return false;
			var read:ReadFile = new ReadFile();
			var cont:String = read.readFromFile(fl);
			var a:Array = StringTWLUtil.splitNewline(cont);
			var n1:int;
			var n2:int;
			for(var i:int=a.length-1;i>=0;i--){
				var s:String = a[i];
				if(s.indexOf("}")!=-1){
					if(n1 == 1){
						n2 = i;
						break
					}
					n1 +=1
				}
			}
			if(n2 == 0) return false;
			a.splice(n2,0,t);
			cont = a.join(StringTWLUtil.NEWLINE_SIGN);
			var write:WriteFile = new WriteFile();
			write.write(fl,cont);
			return true;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}