package com.gdps.module.peopleImage.tool
{
	import com.sandy.resource.air.AirLoadImageProxy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	
	import spark.core.SpriteVisualElement;

	public class FlipImage
	{
		public function FlipImage()
		{
		}
		
		public var sp:SpriteVisualElement;
		
		public function flip(a:Array):void
		{
			for(var i:int=0;i<a.length;i++)
			{
				loadImage(a[i] as File);
				break 
			}
		}
		
		private function loadImage(file:File):void
		{
			var proxy:AirLoadImageProxy = new AirLoadImageProxy();
			proxy.complete_f = loadImageComplete;
			proxy.load(file);
		}
		
		private function loadImageComplete(bit:Bitmap,fl:File):void
		{
			
			var bitmap:BitmapData = new BitmapData(bit.width,bit.height,true,0x00000000)
			var mat:Matrix = new Matrix();
			mat.a = -1
			bitmap.draw(bit,mat,null,null,null,true)
			
			sp.addChild(new Bitmap(bitmap));
		}
		
		
	}
}