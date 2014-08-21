package com.editor.tool.project.jsfl
{
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class CompileFla
	{
		public function CompileFla()
		{
		}
		
		public function compile(filesArr:Array):void
		{
			var file:File = new File(File.applicationStorageDirectory.nativePath+File.separator+"flaToSwf.jsfl");
			var cont:String = "//在flash cs5.5里的命令菜单里执行，就可以把项目中打包的所有fla编译成swf"+NEWLINE_SIGN;
			cont += "function FlaToSwf(flaNamePath,swfNamePath)"+NEWLINE_SIGN;
			cont += "{"+NEWLINE_SIGN;
			cont += createSpace2(2)+"var fla=fl.openDocument(flaNamePath);"+NEWLINE_SIGN;
			cont += createSpace2(2)+"var pathUri=fla.pathURI;"+NEWLINE_SIGN;
			cont += createSpace2(2)+"fla.exportSWF(swfNamePath,false);"+NEWLINE_SIGN;
			cont += createSpace2(2)+"fl.closeDocument(fl.documents[0],false);"+NEWLINE_SIGN;
			cont += "}"+NEWLINE_SIGN;
			if (filesArr.length){
				for(var i:int=0;i<filesArr.length;i++){
					var swf:File = Object(filesArr[i]).swf;
					var fla:File = Object(filesArr[i]).fla;
					cont += 'FlaToSwf("file:///'+fla.nativePath.split(File.separator).join("/")+'","file:///'+swf.nativePath.split(File.separator).join("/")+'");'+NEWLINE_SIGN;
				}
			}
			var write:WriteFile = new WriteFile();
			write.write(file,cont);
			file.openWithDefaultApplication();
		}
		
		public function createUserModuleFla():void
		{
			var name:String = AppMainModel.getInstance().user.shortName;
			var file:File = new File(File.applicationStorageDirectory.nativePath+File.separator+"createFla.jsfl");
			//src
			var cont:String = "var dom = fl.createDocument();"+NEWLINE_SIGN;
			var url:String = 'file:///'+ProjectCache.getInstance().getAssetsPath()+File.separator+"swf"+File.separator+name+".fla";
			url = url.split(File.separator).join("/");
			cont += "fl.saveDocument(dom,'"+url+"');"+NEWLINE_SIGN;
			cont += "fl.openDocument('"+url+"');"+NEWLINE_SIGN;
			//theme
			cont += "var dom = fl.createDocument();"+NEWLINE_SIGN;
			url = 'file:///'+ProjectCache.getInstance().getThemeAssetsPath()+File.separator+"swf"+File.separator+name+"_t.fla"
			url = url.split(File.separator).join("/");
			cont += "fl.saveDocument(dom,'"+url+"');"+NEWLINE_SIGN;
			cont += "fl.openDocument('"+url+"');"+NEWLINE_SIGN;
			var write:WriteFile = new WriteFile();
			write.write(file,cont);
			file.openWithDefaultApplication();
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace2(n:int=1):String
		{
			return StringTWLUtil.createSpace(n,"	")
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en(n)
		}
	}
}