package com.editor.modules.pop.editLocale
{
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.tool.ParserLocaleTool;
	import com.editor.vo.LocaleData;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.math.HashMap;
	import com.sandy.math.SandyArray;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class EditLocaleTool
	{
		public function EditLocaleTool(m:EditLocalePopwinMediator)
		{
			mediator = m;
		}
		
		private var mediator:EditLocalePopwinMediator;
		private var read:ReadFile = new ReadFile();
		private var write:WriteFile = new WriteFile();
		public var locale_map:SandyArray = new SandyArray();
		public var min:Number;
		public var max:Number;
		public var info:String="";
				
		public function parser(_path:String):void
		{
			var cont:String = read.read(_path);
			var a:Array = StringTWLUtil.splitNewline(cont);
			var c:String = a[0];
			if(StringTWLUtil.beginsWith(c,"#")){
				if(c.indexOf("<")!=-1){
					var b:Array= StringTWLUtil.getContent(c,"<",">");
					min = int(b[0]);
					max = int(b[1]);
					info = c;
				}
			}
			var tool:ParserLocaleTool = new ParserLocaleTool();
			tool.parser2(ProjectCache.getInstance().getUserLocale());
			locale_map = tool.map;
		}
		
		public function add(key:String,info:String):void
		{
			if(StringTWLUtil.isWhitespace(key)) return ;
			var d:LocaleData = ProjectCache.getInstance().locale_map.find(info,2);
			if(d!=null){
				SandyManagerBase.getInstance().showError("该locale已经在"+FileUtils.getFileName(d.filePath)+"中有了");
				return ;
			}
			d = ProjectCache.getInstance().locale_map.find(key,1);
			if(d!=null){
				SandyManagerBase.getInstance().showError("该locale已经在"+FileUtils.getFileName(d.filePath)+"中有了");
				return ;
			}
			d = locale_map.find(info,2);
			if(d!=null){
				SandyManagerBase.getInstance().showError("在本帐号下的locale已经在中有了");
				return ;
			}
			d = locale_map.find(key,1);
			if(d!=null){
				SandyManagerBase.getInstance().showError("在本帐号下的locale已经在中有了");
				return ;
			}
			d = new LocaleData();
			d.key = key;
			d.value = info;
			d.filePath = ProjectCache.getInstance().getUserLocale();
			locale_map.addItem(d);
			mediator.reflashData();
		}
		
		public function change(key:String,info:String):void
		{
			var d:LocaleData = locale_map.find(key,1);
			if(d!=null){
				d.value = info;	
				mediator.reflashData();
			}			
		}
		
		public function del(d:LocaleData):void
		{			
			if(locale_map.removeItem(d)){
				mediator.reflashData();
			}
		}
		
		public function findBindClass(d:LocaleData):void
		{
			mediator.showBindClass(d);
		}
		
		public function pub():void
		{
			var out:String = info+NEWLINE_SIGN;
			var a:Array = locale_map.source;
			for(var i:int=0;i<a.length;i++){
				var d:LocaleData = a[i] as LocaleData;
				if(d!=null){
					ProjectCache.getInstance().addLocale(d);
					out += d.toString()+NEWLINE_SIGN;
				}
			}
			
			var fl:File = new File(ProjectCache.getInstance().getUserLocale());
			write.write(fl,out);
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN;
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n);
		}
	}
}