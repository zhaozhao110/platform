package com.editor.d3.cache
{
	import com.air.io.FileUtils;
	import com.air.thread.ThreadMessageData;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.editor.model.AppMainModel;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.ToolUtils;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class D3ProjectFilesCache
	{
		private static var instance:D3ProjectFilesCache ;
		public static function getInstance():D3ProjectFilesCache{
			if(instance == null){
				instance =  new D3ProjectFilesCache();
			}
			return instance;
		}
		
		
		public function getAllTexture2():Array
		{
			var f:File = new File(getProjectFold().nativePath+File.separator+"assets"+File.separator+"textures")
			var t:FileUtils = new FileUtils();
			t.getAllDirectoryListing(f,[D3ComponentConst.sign_8]);
			return t.file_ls;
		}
		
		public function getAllTextureAssets():Array
		{
			var f:File = new File(getProjectFold().nativePath+File.separator+"assets"+File.separator+"textures_assets")
			var t:FileUtils = new FileUtils();
			t.getAllDirectoryListing(f,["jpg","png"]);
			return t.file_ls;
		}
		
		public function getAllMesh():Array
		{
			var f:File = new File(getProjectFold().nativePath+File.separator+"assets"+File.separator+"meshes")
			var t:FileUtils = new FileUtils();
			t.getAllDirectoryListing(f,[D3ComponentConst.sign_3]);
			return t.file_ls;
		}
		
		public function getAllMaterial():Array
		{
			var f:File = new File(getProjectFold().nativePath+File.separator+"assets"+File.separator+"materials")
			var t:FileUtils = new FileUtils();
			t.getAllDirectoryListing(f,[D3ComponentConst.sign_1]);
			return t.file_ls;
		}
		
		public function getAllAnim():Array
		{
			var f:File = new File(getProjectFold().nativePath+File.separator+"assets"+File.separator+"anim")
			var t:FileUtils = new FileUtils();
			t.getAllDirectoryListing(f,[D3ComponentConst.sign_4]);
			return t.file_ls;
		}
		
		public function getAllParticle():Array
		{
			var f:File = new File(getProjectFold().nativePath+File.separator+"assets"+File.separator+"particle")
			var t:FileUtils = new FileUtils();
			t.getAllDirectoryListing(f,[D3ComponentConst.sign_5]);
			return t.file_ls;
		}
		
		public function getProjectResPath(f:File):String
		{
			if(f == null) return "";
			if(getProjectFold() == null) return f.nativePath;
			var p:String = f.nativePath;
			var p2:String = getProjectFold().nativePath;
			p2 = StringTWLUtil.remove(p,p2);
			return p2;
		}
		
		public function addProjectResPath(f:String):String
		{
			if(getProjectFold() == null) return f;
			if(StringTWLUtil.isWhitespace(f)) return "";
			var p:String = f
			var p2:String = getProjectFold().nativePath;
			var p3:String = StringTWLUtil.remove(p,p2);
			var fl:File = new File(p2+File.separator+p3);
			return fl.nativePath;
		}
		
		public function getProjectFold():File
		{
			if(getConfigFile() == null) return null;
			if(getConfigFile().exists){
				return getConfigFile().parent;
			}
			return null;
		}
		
		public function getConfigFile():File
		{
			var f:String = AppMainModel.getInstance().applicationStorageFile.curr_3dproject;
			if(!FileUtils.checkFilePath(f)) return null;
			return new File(f + File.separator + D3ComponentConst.sign_2);
		}
		
		
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		
		public var projectFile:File;
		private var file_ls:Array;
		private var fileGroup_ls:Array;
		
		//项目里的所有文件都缓存成byteArray
		public function reflashProjectCache(d:ThreadMessageData):void
		{
			projectFile = new File(d.data3);
			file_ls = d.data;
			fileGroup_ls = d.data2;
			
			parserImage()
		}
		
		public function dispose():void
		{
			projectFile = null;
			file_ls = null;
			fileGroup_ls = null;
		}
		
		private function parsereEnd():void
		{
			iManager.sendAppNotification(D3Event.change3DProject_event,projectFile);
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
		public function getByteByFile(f:File):ByteArray
		{
			if(file_ls == null) return null;
			return ToolUtils.originalClone(file_ls[f.nativePath] as ByteArray);
		}
		
		public function pubByteByFile(f:File,b:ByteArray):void
		{
			if(file_ls == null) return ;
			file_ls[f.nativePath] = b;
		}
		
		public function delByteByFile(f:File):void
		{
			if(file_ls[f.nativePath]!=null){
				file_ls[f.nativePath] = null;
			}
		}
		
		private var image_total:int;
		private function parserImage():void
		{
			image_total = 0;
			
			for(var path:String in file_ls){
				var f:File = new File(path);
				if(f.exists){
					if(f.extension == "jpg" || f.extension == "png"){
						image_total += 1;
					}
				}
			}
			
			for(path in file_ls){
				f = new File(path);
				if(f.exists){
					var d:D3ResData = new D3ResData();
					if(f.extension == "jpg" || f.extension == "png"){
						d.file = f;
						d.readImage(readImageEnd);
						D3ResChangeProxy.getInstance().putFile(d);
					}
				}
			}
			
			if(image_total == 0){
				parsereEnd();
			}
			
		}
		
		private function readImageEnd():void
		{
			image_total -= 1;
			//trace(image_total);
			if(image_total <= 0){
				parsereEnd();
			}
		}
		
		
	}
}