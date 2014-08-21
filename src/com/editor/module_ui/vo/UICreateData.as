package com.editor.module_ui.vo
{
	import com.editor.manager.DataManager;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	import flashx.textLayout.compose.ISWFContext;

	public class UICreateData
	{
		public function UICreateData()
		{
		}
		
		public var vars:String="";
		public var comp:String;
		
		public var imports:Array = [];
		public function addImport(s:String):void
		{
			if(s.substring(0,1) == "."){
				s = s.substring(1,s.length);
			}
			if(imports.indexOf(s)==-1){
				imports.push(s);
			}
		}
				
		public function parserMediator(x:XML):void
		{
			var _id:String = x.@id;
			var type:String = x.@type;
			var groupId:int = x.@groupId;
									
			var viewsURL:String = x.@viewsURL;
			if(!StringTWLUtil.isWhitespace(viewsURL)){
				//多视图
				var views_a:Array = viewsURL.split(",");
				for(var i:int=0;i<views_a.length;i++){
					var url:String = views_a[i];
					var url2:String = url.split(".")[0];
					if(url2.indexOf("/")!=-1){
						url2 = url2.split("/").join(".");
					}
					if(url2.indexOf(File.separator)!=-1){
						url2 = url2.split(File.separator).join(".");
					}
					
					if(imports.indexOf(url2)==-1){
						imports.push(url2);
					}
					
					var bb:Array = url2.split(".");
					var clsName:String = bb[bb.length-1];
					
					vars += createSpace()+"public"+" "+"function"+" "+"get"+" "+clsName.toLocaleLowerCase()+"():"+clsName+NEWLINE_SIGN;
					vars += createSpace()+"{"+NEWLINE_SIGN;
					vars += createSpace(2)+"return"+" "+"win."+clsName.toLocaleLowerCase()+";"+NEWLINE_SIGN;
					vars += createSpace()+"}"+NEWLINE_SIGN;
				}
			}
			
			var proxy:String = x.@proxy;
			if(!StringTWLUtil.isWhitespace(proxy)){
				
				url = proxy;
				url2 = url.split(".")[0];
				if(url2.indexOf("/")!=-1){
					url2 = url2.split("/").join(".");
				}
				if(url2.indexOf(File.separator)!=-1){
					url2 = url2.split(File.separator).join(".");
				}
				
				if(imports.indexOf(url2)==-1){
					imports.push(url2);
				}
				
				bb = url2.split(".");
				clsName = bb[bb.length-1];
				
				vars += createSpace(2)+"public"+" "+"function"+" "+"get"+" "+_id+"():"+clsName+NEWLINE_SIGN;
				vars += createSpace(2)+"{"+NEWLINE_SIGN;
				vars += createSpace(3)+"return"+" "+"win."+_id+";"+NEWLINE_SIGN;
				vars += createSpace(2)+"}"+NEWLINE_SIGN;
				
				return ;
			}
			
			if(groupId == DataManager.comType_6){
				vars += createSpace(2)+"public"+" "+"function"+" "+"get"+" "+_id+"():"+type+NEWLINE_SIGN;	
			}else{
				vars += createSpace(2)+"public"+" "+"function"+" "+"get"+" "+_id+"():UI"+type+NEWLINE_SIGN;
			}
			
			vars += createSpace(2)+"{"+NEWLINE_SIGN;
			vars += createSpace(3)+"return"+" "+"win."+_id+";"+NEWLINE_SIGN;
			vars += createSpace(2)+"}"+NEWLINE_SIGN;
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