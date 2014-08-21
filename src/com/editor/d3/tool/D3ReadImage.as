package com.editor.d3.tool
{
	import com.air.io.ReadImage;
	import com.editor.d3.cache.D3ResChangeProxy;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;
	
	public class D3ReadImage extends ReadImage
	{
		public function D3ReadImage()
		{
			super();
		}
		
		override public function loadImageFromFile(fl:File):void
		{
			var f:File = fl;
			if(D3ResChangeProxy.getInstance().getFile(f.nativePath)!=null){
				var b:* = D3ResChangeProxy.getInstance().getFile(f.nativePath).content;
				if(b is Bitmap){
					readComplete(b);
					return ;
				}
			}
			super.loadImageFromFile(fl);
		}
		
		public static function checkIsImage(f:File):Boolean
		{
			if(f.extension == "jpg" || f.extension == "png"){
				return true;
			}
			return false;
		}
		
		
	}
}