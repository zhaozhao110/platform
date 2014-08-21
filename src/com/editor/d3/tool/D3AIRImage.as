package com.editor.d3.tool
{
	import com.air.component.SandyAIRImage;
	import com.editor.d3.cache.D3ResChangeProxy;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;
	
	public class D3AIRImage extends SandyAIRImage
	{
		public function D3AIRImage()
		{
			super();
		}
		
		override public function set source(value:*):void
		{
			if(value is File){
				var f:File = value as File;
				if(!f.exists) return ;
				if(D3ResChangeProxy.getInstance().getFile(f.nativePath)!=null){
					var b:* = D3ResChangeProxy.getInstance().getFile(f.nativePath).content;
					if(b is Bitmap){
						readComplete(b);
						return ;
					}
				}
			}
			super.source = value;
		}
		
	}
}