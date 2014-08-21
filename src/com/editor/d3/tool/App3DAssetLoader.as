package com.editor.d3.tool
{
	import away3d.loaders.misc.AssetLoaderContext;
	import away3d.loaders.misc.AssetLoaderToken;
	import away3d.loaders.parsers.ParserBase;
	
	import com.air.io.ReadFile;
	import com.d3.loader.Sandy3DAssetLoader;
	import com.sandy.core.SandyLoggerFactory;
	import com.sandy.san_internal;
	
	import flash.filesystem.File;
	
	use namespace san_internal;
	
	public class App3DAssetLoader extends Sandy3DAssetLoader
	{
		public function App3DAssetLoader()
		{
			super();
		}
		
		override public function loadData(data:*,id:String,context:AssetLoaderContext=null,ns:String=null,parser:ParserBase=null):AssetLoaderToken
		{
			SandyLoggerFactory.load("Sandy3DAssetLoader load," + id);
			if(data is File){
				var read:D3ReadFile = new D3ReadFile();
				return super.loadData(read.read((data as File).nativePath,ReadFile.READTYPE_BYTEARRAY),id,context,ns,parser);
			}
			return super.loadData(data,id,context,ns,parser);
		}
	}
}