package com.editor.d3.tool
{
	import com.air.io.ReadFile;
	import com.editor.d3.cache.D3ProjectFilesCache;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class D3ReadFile extends ReadFile
	{
		public function D3ReadFile()
		{
			super();
		}
		   
		override public function readCompressByteArray(path:String):String
		{
			var f:File = new File(path);
			if(!f.exists) return "";
			var b:ByteArray = D3ProjectFilesCache.getInstance().getByteByFile(f)
			if(b!=null){
				b.uncompress();
				return b.toString()
			}
			return super.readCompressByteArray(path);
		}
		
		override public function read(path:String,readType:String=READTYPE_STRING):*
		{
			var f:File = new File(path);
			if(!f.exists) return "";
			var b:ByteArray = D3ProjectFilesCache.getInstance().getByteByFile(f)
			if(b!=null){
				if(readType == READTYPE_BYTEARRAY){
					return b; 
				}
				return b.toString();
			}
			return super.read(path,readType);
		}
		
	}
}