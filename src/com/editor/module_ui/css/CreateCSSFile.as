package com.editor.module_ui.css
{
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.vo.CSSFileChangeVO;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class CreateCSSFile
	{
		public function CreateCSSFile()
		{
		}
		 
		private var map:Array = [];
		private var xml:XML
		
		public function create(x:XML,compd:CSSComponentData):void
		{
			xml = x;
			map = null;
			map = [];
			for each(var p:XML in x.item){
				var item:CreateCSSFileItemVO = new CreateCSSFileItemVO(p);
				map[item.key] = item;
			}
			
			var s:String = "/** from templete <" + getValue("templete") + "> ,author by ["+AppMainModel.getInstance().user.shortName+"], please not delete **/"+NEWLINE_SIGN;
			s += "package "+getValue("package")+NEWLINE_SIGN;
			s += "{"+NEWLINE_SIGN;
			s += createSpace()+"import flash.filters.*;"+NEWLINE_SIGN;
			if(!StringTWLUtil.isWhitespace(map["info"])){
				s+="/**"+map["info"].value+"**/"+NEWLINE_SIGN;
			}
			s += createSpace()+"public"+" "+"class"+" "+getValue("name")+NEWLINE_SIGN;
			s += createSpace()+"{"+NEWLINE_SIGN;
			
			/*s += createSpace_en(4)+"public"+createSpace_en()+"function"+createSpace_en()+getValue("name")+'():void'+NEWLINE_SIGN;
			s += createSpace_en(4)+"{"+NEWLINE_SIGN;
			s += createSpace_en(4)+"}"+NEWLINE_SIGN;*/
			
			for each(item in map){
				if(exclude_ls.indexOf(item.key)==-1){
					s += item.getCSSFile(this) + NEWLINE_SIGN;
				}
			}
			
			s += createSpace()+"}"+NEWLINE_SIGN;
			s += "}"+NEWLINE_SIGN;
			
			//E:/hg_res/sandy_engine/test/uiTest/src/theme/css/CSS_btn2.as
			var f:File = compd.file;
			var write:WriteFile = new WriteFile();
			write.write(f,s);
			
			var d:CSSFileChangeVO = new CSSFileChangeVO();
			d.fileContent = s;
			d.xmlContent = xml;
			d.componentData = compd;
			iManager.sendAppNotification(UIEvent.cssFile_change_event,d);
		}
		
		
		
		private var exclude_ls:Array = ["templete","package","name","path"];
		
		public function getValue(key:String):*
		{
			return CreateCSSFileItemVO(map[key]).value;
		}
		
		public function haveValue(key:String):Boolean
		{
			return map[key] != null;
		}
		
		
		
		
		
		
		
		
		
		
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n);
		}
		
		private function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
	}
}