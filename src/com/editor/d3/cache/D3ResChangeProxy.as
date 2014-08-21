package com.editor.d3.cache
{
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.object.D3Object;
	import com.sandy.math.HashMap;
	
	import flash.filesystem.File;

	public class D3ResChangeProxy
	{
		private static var instance:D3ResChangeProxy ;
		public static function getInstance():D3ResChangeProxy{
			if(instance == null){
				instance =  new D3ResChangeProxy();
			}
			return instance;
		}
		
		private var file_ls:HashMap = new HashMap();
		
		public function addFile(f:File,c:*=""):void
		{
			if(getFile(f.nativePath)!=null){
				getFile(f.nativePath).content = c;
				return;
			}
			var d:D3ResData = new D3ResData();
			d.file = f;
			d.content = c;
			file_ls.put(f.nativePath,d);
		}
		
		public function putFile(d:D3ResData):void
		{
			file_ls.put(d.file.nativePath,d);
		}
		
		public function getFile(f:String,isClone:Boolean=false):D3ResData
		{
			if(isClone){
				return (file_ls.find(f) as D3ResData).clone();	
			}
			return file_ls.find(f) as D3ResData;
		}
		
		public function delFile(f:File):void
		{
			file_ls.remove(f.nativePath);
		}
		
		public function changeContent(f:String,c:*):Boolean
		{
			if(getFile(f)==null){
				addFile(new File(f),c);
			}
			if(getFile(f)!=null){
				getFile(f).readXML(c);
				return true;
			}
			return false;
		}
		
		public function changedFile(f:String):Boolean
		{
			if(getFile(f)!=null){
				getFile(f).changed = true
				return true;
			}
			return false;
		}
		
		public function checkFile(f:File):Boolean
		{
			return file_ls.exists(f.nativePath);
		}
		
		public function dispose():void
		{
			file_ls.clear();
		}
		
		
		
		
		
		
	}
}