package com.editor.tool
{
	import com.asparser.ClsUtils;
	import com.air.io.FileUtils;
	import com.air.io.WriteFile;
	import com.editor.event.AppEvent;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class PopwinEnumTool
	{
		public function PopwinEnumTool()
		{
		}
		
		private var write:WriteFile = new WriteFile();
		
		//PopwinEnum.as
		public function create():void
		{
			
			var a:Array = [];
			var file:File = new File(ProjectCache.getInstance().getModelPath())
			a = file.getDirectoryListing();
			var b:Array = [];
			for(var i:int=0;i<a.length;i++){
				var _fl2:File = a[i] as File;
				if(_fl2.isDirectory){
					if(!FileUtils.isSVNFile(_fl2.name)){
						b.push(_fl2);
					}
				}
			}
			var popwinSign_a:Array = [];
			var popupwinClass_a:Array = [];
			for(i=0;i<b.length;i++)
			{
				var tool:FileUtils = new FileUtils();
				tool.getAllDirectoryListingByStr(b[i],"popwinSign");
				popwinSign_a = popwinSign_a.concat(tool.file_ls);
				
				tool = new FileUtils();
				tool.getAllDirectoryListingByStr(b[i],"popwinClass");
				popupwinClass_a = popupwinClass_a.concat(tool.file_ls);
			}
			
			var fl:File = new File(ProjectCache.getInstance().getPopwinEnum());
			var out:String = "package "+ClsUtils.getClassPackage(fl)+NEWLINE_SIGN;
			out += "{"+NEWLINE_SIGN;
			
			for(i=0;i<b.length;i++){
				out += createSpace()+"import  "+ ClsUtils.getClassPathString(b[i])+".*;"+ NEWLINE_SIGN;	
			}
			
			out += createSpace()+NEWLINE_SIGN;
			
			out += createSpace()+"public class PopwinEnum"+NEWLINE_SIGN;
			out += createSpace()+"{"+NEWLINE_SIGN;
			
			
			
			
			
			out += createSpace(2)+"public static function getPopupwinSign():Array"+NEWLINE_SIGN;
			out += createSpace(2)+"{"+NEWLINE_SIGN;
			var a2:Array = [];
			for(i=0;i<popwinSign_a.length;i++){
				var fl2:File = popwinSign_a[i] as File;
				a2.push(fl2.name.split(".")[0]);
			}
			out += createSpace(3) + "return ["+a2.join(",")+"];"+NEWLINE_SIGN;
			out += createSpace(2)+"}"+NEWLINE_SIGN;
			
			
			
			
			
			out += createSpace(2)+"public static function getPopupwinClass():Array"+NEWLINE_SIGN;
			out += createSpace(2)+"{"+NEWLINE_SIGN;
			a2 = [];
			for(i=0;i<popupwinClass_a.length;i++){
				fl2 = popupwinClass_a[i] as File;
				a2.push(fl2.name.split(".")[0]);
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