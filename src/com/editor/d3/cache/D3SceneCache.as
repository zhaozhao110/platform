package com.editor.d3.cache
{
	import com.editor.d3.tool.D3ReadFile;
	
	import flash.filesystem.File;

	//配置文件里的scene1.3dscene
	public class D3SceneCache
	{
		private static var _instance:D3SceneCache;
		public static function get instance():D3SceneCache
		{
			if(_instance == null){
				_instance = new D3SceneCache();
			}
			return _instance;
		}
		
		public function getSceneFile(s:String):File
		{
			var f:File = new File(D3ProjectFilesCache.getInstance().getProjectFold().nativePath+File.separator+"scenes"+File.separator+s+"."+D3ComponentConst.sign_7)
			return f;
		}
		
		public function getSceneFileCont(s:String):String
		{
			var f:File = getSceneFile(s);
			if(!f.exists) return "";
			var r:D3ReadFile = new D3ReadFile();
			return r.read(f.nativePath)
		}
		
		public var currSceneFile:File;
		
		
	}
}