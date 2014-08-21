package com.editor.project_pop.parserSwf
{
	import com.air.io.ReadFile;
	import com.asparser.swf.as3swf.SWF;
	import com.asparser.swf.as3swf.tags.ITag;
	import com.asparser.swf.as3swf.tags.TagSymbolClass;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class ParserSwfData
	{
		public function ParserSwfData()
		{
		}
		
		public var file:File;
		public var name:String;
		public var swf:SWF;
		public var symbol:TagSymbolClass
		
		public function parser():void
		{
			if(swf != null) return ;
			var read:ReadFile = new ReadFile();
			var byte:ByteArray = read.read(file.nativePath,ReadFile.READTYPE_BYTEARRAY)
			swf = new SWF(byte);
			for each(var tag:ITag in swf.tags){
				if(tag is TagSymbolClass){
					symbol = tag as TagSymbolClass;
					break
				}
			}
			
		}
	}
}