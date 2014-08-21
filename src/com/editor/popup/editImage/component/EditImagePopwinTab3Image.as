package com.editor.popup.editImage.component
{
	import com.air.io.FileUtils;
	import com.air.io.WriteFile;
	import com.editor.model.AppMainModel;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class EditImagePopwinTab3Image
	{
		public function EditImagePopwinTab3Image()
		{
			
		}
		
		public function convert(f:File):void
		{
			if(f == null) return ;
			if(!f.exists) return ;
			//if(f.extension != "png") return ;
						
			var cmd:String = createCMD(f);
			
			var createFile:File = new File(File.applicationStorageDirectory.nativePath + File.separator+"tmp"+File.separator+"creatATF.bat")
			var w:WriteFile = new WriteFile();
			w.write(createFile,cmd);
			
			createFile.openWithDefaultApplication();
		}
		
		public function dispose():void
		{
			
		}
		
		private function createCMD(f:File,f2:File=null):String
		{
			var toolUrl:String = FileUtils.getUserLocalAppData().nativePath+File.separator+"engineEditor"+File.separator+"png2atf.exe"
			//png2atf -c -i test.png -o test.atf
			var newFile:File;
			if(f2!=null){
				newFile = new File(f2.nativePath+File.separator+f.name.split(".")[0]+".atf");
			}else{
				newFile = new File(f.parent.nativePath+File.separator+f.name.split(".")[0]+".atf");
			}
			if(mipmap){
				var cmd:String = '"'+toolUrl+'" -i "'+f.nativePath+'" -o "'+newFile.nativePath+'"';
			}else{
				cmd = '"'+toolUrl+'" -n 0,0 -i "'+f.nativePath+'" -o "'+newFile.nativePath+'"';
			}
			return cmd;
		}
		
		public var mipmap:Boolean=true;
		private var saveFold:File;
		private var orginFold:File;
		public var appendLog_f:Function;
		
		private var cmd_s:String = "";
				
		public function convertFold(f:File):void
		{
			if(f == null) return ;
			if(!f.exists) return ;
			cmd_s = "";
			orginFold = f;
			saveFold = new File(f.nativePath+File.separator+"atf");
			
			_convertFold(f);
			
			appendLog_f(cmd_s);
			
			var createFile:File = new File(File.applicationStorageDirectory.nativePath + File.separator+"tmp"+File.separator+"creatATF.bat")
			var w:WriteFile = new WriteFile();
			w.write(createFile,cmd_s);
			
			createFile.openWithDefaultApplication();
		}
		
		private function _convertFold(f:File):void
		{
			var a:Array = f.getDirectoryListing();
			for(var i:int=0;i<a.length;i++){
				var file:File = a[i] as File;
				if(file.extension == "png"){
					var sf:File = new File(saveFold.nativePath+File.separator+getPath2(f));
					WriteFile.createDirectory(sf.nativePath);				
					var cmd:String = createCMD(file,sf);
					cmd_s += cmd + "\n";
				}else if(file.isDirectory){
					_convertFold(file);
				}
			}
		}
		
		private function getPath2(f:File):String
		{
			var s:String = f.nativePath;
			var s2:String = orginFold.nativePath;
			return StringTWLUtil.remove(s,s2);
		}
		
		
	}
}