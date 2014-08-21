package com.editor.d3.tool
{
	import com.air.io.WriteFile;
	import com.editor.d3.cache.D3ProjectFilesCache;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.utils.ByteArray;
	
	public class D3WriteFile extends WriteFile
	{
		public function D3WriteFile()
		{
			super();
		}
		
		override public function writeCompress(_file:File,content:*):ByteArray
		{
			var b:ByteArray = super.writeCompress(_file,content);
			if(b!=null){
				D3ProjectFilesCache.getInstance().pubByteByFile(_file,b);
			}
			return b;
		}
		
		override public function write(_file:File,content:*,_fileMode:String = FileMode.WRITE):ByteArray
		{
			var b:ByteArray = super.write(_file,content,_fileMode);
			D3ProjectFilesCache.getInstance().pubByteByFile(_file,b);
			return b;
		}
		
	}
}