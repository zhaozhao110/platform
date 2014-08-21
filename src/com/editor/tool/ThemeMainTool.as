package com.editor.tool
{
	import com.air.io.FileUtils;
	import com.air.io.WriteFile;
	import com.asparser.ClsUtils;
	import com.editor.event.AppEvent;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	public class ThemeMainTool
	{
		public function ThemeMainTool()
		{
		}
		
		private var write:WriteFile = new WriteFile();
		
		//ThemeMain.as
		public function create():void
		{
			
			var a:Array = [];
			var file:File = new File(ProjectCache.getInstance().getThemePath())
			a = file.getDirectoryListing();
			var b:Array = [];
			for(var i:int=0;i<a.length;i++){
				var _fl2:File = a[i] as File;
				if(!_fl2.isDirectory){
					if(StringTWLUtil.endsWith(_fl2.name.split(".")[0],"_CSS")){
						b.push(_fl2);
					}
				}
			}
			
			var fl:File = new File(ProjectCache.getInstance().getThemeMain());
			var out:String = "package "+ClsUtils.getClassPackage(fl)+NEWLINE_SIGN;
			out += "{"+NEWLINE_SIGN;
			
			out += createSpace()+"public class ThemeMain"+NEWLINE_SIGN;
			out += createSpace()+"{"+NEWLINE_SIGN;
			
			out += createSpace(2)+"public var global:CSS_global=new CSS_global();"+NEWLINE_SIGN;
			
			out += createSpace(2)+NEWLINE_SIGN;
			
			out += createSpace(2)+"public static function importCSS():Array"+NEWLINE_SIGN;
			out += createSpace(2)+"{"+NEWLINE_SIGN;
			var a2:Array = [];
			a2.push("ThemeMain");
			for(i=0;i<b.length;i++){
				var fl2:File = b[i] as File;
				var s3:String = fl2.name.split(".")[0];
				if(a2.indexOf(s3)==-1){
					a2.push(s3);
				}
			}
			out += createSpace(3) + "return ["+a2.join(",")+"];"+NEWLINE_SIGN;
			out += createSpace(2)+"}"+NEWLINE_SIGN;
			
			out += createSpace()+"}"+NEWLINE_SIGN;
			out += "}"+NEWLINE_SIGN;
			write.write(fl,out);
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