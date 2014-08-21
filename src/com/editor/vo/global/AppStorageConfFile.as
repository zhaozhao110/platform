package com.editor.vo.global
{
	import com.air.io.FileUtils;
	import com.air.io.HashMapFile;
	import com.editor.d3.cache.D3ComponentConst;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	/**
	 * 客户端的配置文件,保存不变的数据
	 */ 
	public class AppStorageConfFile
	{
		public static function getStorageFileURL():String
		{
			return File.applicationStorageDirectory.nativePath+File.separator+"config.txt"
		}
		
		public static function getStorageDirt():String
		{
			return File.applicationStorageDirectory.nativePath;
		}
		
		public function AppStorageConfFile()
		{
			var url:String = getStorageFileURL();
			//trace("AppStorageConfFile: " + url)
			hashFile = new HashMapFile(url)
				
			curr_project 				= getKey_project();
			curr_editFiles 				= getKey_editFiles();
			roleEdit_recentOpenFileURL 	= getKey_roleEdit_recentOpenFile();
			javaHome 					= getKey_javaHome();
			stacks_ls 					= getKey_stacks();
			recentDatabase_ls 			= getKey_recentDatabase();
			curr_projectFold			= getKey_projectFold();
			if( !StringTWLUtil.isWhitespace(curr_projectFold) && !FileUtils.checkFileIsExist(curr_projectFold)){
				curr_projectFold = "";
			}
			tempActionFold_ls 			= getKey_tempActionFold();
			editFile					= getKey_editFile();
			loadAssets_ls				= getKey_loadAssets_ls();
			sdkFold_ls					= getKey_sdkFold();
			recentProject_ls			= getKey_recentProject();
			recent3DProject_ls			= getKey_recent3DProject();
			curr_3dproject				= getKey_3dproject();
			curr_3dprojectFold			= getKey_3dprojectFold();
			curr_3dOutlineUID			= getKey_3dOutlineUID();
		}
		
		private var hashFile:HashMapFile;
		
		//更改项目
		public function changeProject(f:File):void
		{
			curr_project = f.nativePath;
			curr_projectFold = "";
			curr_editFiles = null;curr_editFiles = [];
		}
		
		//当前编辑的项目
		public var curr_project:String;
		
		private function getKey_project():String
		{
			var value:String = hashFile.find("projects");
			if(StringTWLUtil.isWhitespace(value)) return "";
			return value;
		}
		
		public function putKey_project(url:String):void
		{
			curr_project = url;
			hashFile.put("projects",url)
		}
		
		//当前看的项目里的文件
		public var curr_projectFold:String;
				
		private function getKey_projectFold():String
		{
			var value:String = hashFile.find("projectFold");
			if(StringTWLUtil.isWhitespace(value)) return "";
			return value;
		}
		
		public function putKey_projectFold(url:String):void
		{
			curr_projectFold = url
			hashFile.put("projectFold",url)
		}
		
		//当前编辑的文件列表
		public var curr_editFiles:Array;
		
		private function getKey_editFiles():Array
		{
			var value:String = hashFile.find("editFiles");
			if(StringTWLUtil.isWhitespace(value)) return [];
			return value.split(",")
		}
		
		public function putKey_editFiles(url_a:Array):void
		{
			curr_editFiles = url_a;
			hashFile.put("editFiles",url_a.join(","))
		}
		
		public function removeKey_editFiles(url:String):void
		{
			var _ind:int = curr_editFiles.indexOf(url);
			if(_ind>=0){
				curr_editFiles.splice(_ind,1)
				hashFile.put("editFiles",curr_editFiles.join(","))
			}
		}
		
		//角色动作编辑器里最近打开的目录
		public var roleEdit_recentOpenFile:File;
		public var roleEdit_recentOpenFileURL:String;
		
		private function getKey_roleEdit_recentOpenFile():String
		{
			var value:String = hashFile.find("roleEdit_recentOpenFile");
			if(StringTWLUtil.isWhitespace(value)) return "";
			return value;
		}
		
		public function putKey_roleEdit_recentOpenFile(url:String):void
		{
			roleEdit_recentOpenFileURL = url
			hashFile.put("roleEdit_recentOpenFile",url)
		}
		
		
		//java JAVA_HOME=C:\Program Files\Java\jdk1.6.0_37
		public var javaHome:String;
		
		private function getKey_javaHome():String
		{
			var value:String = hashFile.find("javaHome");
			if(StringTWLUtil.isWhitespace(value)) return "";
			return value;
		}
		
		public function putKey_javaHome(url:String):void
		{
			javaHome = url
			hashFile.put("javaHome",url)
		}
		
		//保存的显示的stacks
		public var stacks_ls:Array = [];
		
		private function getKey_stacks():Array
		{
			var value:String = hashFile.find("stacks");
			if(StringTWLUtil.isWhitespace(value)) return [];
			return value.split(",");
		}
		
		public function putKey_stacks(url:String):void
		{
			stacks_ls = url.split(",");
			hashFile.put("stacks",url);
		}
		
		//保存的数据库路径
		public var recentDatabase_ls:Array = [];
		
		private function getKey_recentDatabase():Array
		{
			var value:String = hashFile.find("recentDatabase");
			if(StringTWLUtil.isWhitespace(value)) return [];
			return value.split("|");
		}
		
		public function putKey_recentDatabase(url:String):void
		{
			recentDatabase_ls = url.split("|");
			hashFile.put("recentDatabase",url);
		}
		
		//临时的操作的目录
		public var tempActionFold_ls:Array = [];
		
		private function getKey_tempActionFold():Array
		{
			var value:String = hashFile.find("tempActionFold");
			if(StringTWLUtil.isWhitespace(value)) return [];
			return value.split("|");
		}
		
		public function putKey_tempActionFold(url:String):void
		{
			tempActionFold_ls = url.split("|");
			hashFile.put("tempActionFold",url);
		}
		
		
		//当前编辑的文件
		public var editFile:String;
		
		private function getKey_editFile():String
		{
			var value:String = hashFile.find("editFile");
			if(StringTWLUtil.isWhitespace(value)) return "";
			return value;
		}
		
		public function putKey_editFile(url:String):void
		{
			editFile = url;
			hashFile.put("editFile",url);
		}
		
		//load assets 
		public var loadAssets_ls:Array;
		
		private function getKey_loadAssets_ls():Array
		{
			var value:String = hashFile.find("loadAssets");
			if(StringTWLUtil.isWhitespace(value)) return [];
			return value.split("|");
		}
		
		public function putKey_loadAssets_ls(url:String):void
		{
			loadAssets_ls = url.split("|");
			hashFile.put("loadAssets",url);
		}
		
		//sdk
		public var sdkFold_ls:Array = [];
		
		private function getKey_sdkFold():Array
		{
			var value:String = hashFile.find("sdkFold");
			if(StringTWLUtil.isWhitespace(value)) return [];
			return value.split("|");
		}
		
		public function putKey_sdkFold(url:String):void
		{
			sdkFold_ls = url.split("|");
			hashFile.put("sdkFold",url);
		}
		
		
		//recent projects
		public var recentProject_ls:Array = [];
		
		private function getKey_recentProject():Array
		{
			var value:String = hashFile.find("recentProject");
			if(StringTWLUtil.isWhitespace(value)) return [];
			return value.split("|");
		}
		
		public function putKey_recentProject(url:String):void
		{
			if(recentProject_ls.indexOf(url)==-1){
				recentProject_ls.push(url);
			}
			hashFile.put("recentProject",recentProject_ls.join("|"));
		}
		
		//recent 3d projects
		public var recent3DProject_ls:Array = [];
		
		private function getKey_recent3DProject():Array
		{
			var value:String = hashFile.find("recent3DProject");
			if(StringTWLUtil.isWhitespace(value)) return [];
			return value.split("|");
		}
		
		public function putKey_recent3DProject(url:String):void
		{
			if(recent3DProject_ls.indexOf(url)==-1){
				recent3DProject_ls.push(url);
			}
			hashFile.put("recent3DProject",recent3DProject_ls.join("|"));
		}
		
		//当前3d编辑的项目
		public var curr_3dproject:String;
		
		private function getKey_3dproject():String
		{
			var value:String = hashFile.find("3dprojects");
			if(StringTWLUtil.isWhitespace(value)) return "";
			return value;
		}
		
		public function putKey_3dproject(url:String):void
		{
			if(StringTWLUtil.isWhitespace(url)){
				curr_3dproject = ""
				hashFile.put("3dprojects",curr_3dproject)
				return ;
			}
			var f:File = new File(url);
			if(!f.exists) return ;
			if(f.name == D3ComponentConst.sign_2){
				f = f.parent;
			}
			curr_3dproject = f.nativePath;
			hashFile.put("3dprojects",curr_3dproject)
		}
		
		//当前看的项目里的文件
		public var curr_3dprojectFold:String;
		
		private function getKey_3dprojectFold():String
		{
			var value:String = hashFile.find("3dprojectFold");
			if(StringTWLUtil.isWhitespace(value)) return "";
			return value;
		}
		
		public function putKey_3dprojectFold(url:String):void
		{
			curr_3dprojectFold = url
			hashFile.put("3dprojectFold",url)
		}
		
		//当前看的outline里的文件
		public var curr_3dOutlineUID:String;
		
		private function getKey_3dOutlineUID():String
		{
			var value:String = hashFile.find("3dOutlineUID");
			if(StringTWLUtil.isWhitespace(value)) return "";
			return value;
		}
		
		public function putKey_3dOutlineUID(url:String):void
		{
			curr_3dOutlineUID = url
			hashFile.put("3dOutlineUID",url)
		}
		
		
	}
}