package com.editor.tool
{
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.asparser.ClsUtils;
	import com.editor.event.AppEvent;
	import com.editor.manager.LogManager;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.LocaleData;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.error.SandyError;
	import com.sandy.math.HashMap;
	import com.sandy.math.SandyArray;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ParserLocaleTool
	{
		public function ParserLocaleTool()
		{
		}
		
		public var map:SandyArray = new SandyArray();
		private var write:WriteFile = new WriteFile();
		
		public function parser2(path:String):void
		{
			_parser(path);
		}
		
		public function parser(locale:String = "zh_CN"):void
		{
			var path:String = ProjectCache.getInstance().getLocalePath();
			_parser(path);
		}
		
		private function _parser(path:String):void
		{
			var fl:File = new File(path);
			if(fl.exists){
				if(fl.isDirectory){
					var a:Array = fl.getDirectoryListing();
					for(var i:int=0;i<a.length;i++){
						parserFile(a[i]);	
					}
				}else{
					parserFile(fl);
				}
			}
		}
		
		private function parserFile(fl:File):void
		{
			if(fl.extension == "properties"){
				var read:ReadFile = new ReadFile();
				var cont:String = read.readFromFile(fl);
				var a:Array = StringTWLUtil.splitNewline(cont);
				var n:int = a.length;
				for(var i:int=0;i<n;i++){
					add(a[i],fl.nativePath);
				}
			}
		}
		
		private function add(c:String,path:String):void
		{
			if(c.indexOf("=")==-1) return ;
			var a:Array = c.split("=");
			var key:String = StringTWLUtil.trim(a[0]);
			var value:String = StringTWLUtil.trim(a[1]);
			if(!StringTWLUtil.isWhitespace(key)){
				if(map.containerKey(key,1)){
					if(SandyEngineGlobal.isAir){
						trace("有重复的locale:" + key);
					}
					if(SandyEngineGlobal.isFlash){
						SandyError.error("有重复的locale:" + key);
					}
				}
				if(map.containerKey(value,2)){
					if(SandyEngineGlobal.isAir){
						trace("有重复的locale:" + key);
					}
					if(SandyEngineGlobal.isFlash){
						SandyError.error("有重复的locale:" + key);
					}
				}
				var d:LocaleData = new LocaleData();
				d.key = key;
				d.value = value;
				d.filePath = path;
				map.addItem(d);
			}
		}
		
		
		//LocaleEnum.as
		//生成sh.properties，并注册在localeEnum.as
		public function createLocaleEnum():void
		{
			var fl:File = new File(ProjectCache.getInstance().getUserLocale());
			var a:Array = [];
			var file:File = new File(ProjectCache.getInstance().getLocalePath())
			a = file.getDirectoryListing();
			if(!fl.exists){
				var n:int ;
				if(file.exists){
					n = a.length;
				}				
				write.write(fl,'#数字从<'+n*100000+">到<"+(n+1)*100000+">");
				LogManager.getInstance().addLog("create file:"+fl.nativePath);
			}else{
				return ;
			}
			
			//change localeEnum.as
			fl = new File(ProjectCache.getInstance().getLocaleEnum());
			var out:String = "package "+ClsUtils.getClassPathString(fl)+NEWLINE_SIGN;
			out += "{"+NEWLINE_SIGN;
			out += createSpace()+"public class LocaleEnum"+NEWLINE_SIGN;
			out += createSpace()+"{"+NEWLINE_SIGN;
			var b:Array = [];
			for(var i:int=0;i<a.length;i++){
				var fl2:File = a[i] as File;
				var c1:String = fl2.name.split(".")[0];
				out += getUserEmbed(c1.split("_")[0]);
				b.push(c1);
			}
			out += NEWLINE_SIGN;
			out += createSpace(2)+"public function getList():Array"+NEWLINE_SIGN;
			out += createSpace(2)+"{"+NEWLINE_SIGN;
			out += createSpace(3)+"var a:Array = [];"+NEWLINE_SIGN;
			for(i=0;i<b.length;i++){
				out += createSpace(3)+'a.push('+b[i]+');'+NEWLINE_SIGN;
			}
			out += createSpace(2)+"}"+NEWLINE_SIGN;
			out += createSpace()+"}"+NEWLINE_SIGN;
			out += "}"+NEWLINE_SIGN;
			write.write(fl,out);
		}
		
		private function getUserEmbed(user:String):String
		{
			var out:String = "";
			out += createSpace(2)+'[Embed(source="./local/zh_CN/'+user+'.properties", mimeType="application/octet-stream")]'+NEWLINE_SIGN;  
			out += createSpace(2)+'public var '+user+'_locale:Class;'+NEWLINE_SIGN;
			return out;
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en2(n);
		}
	}
}