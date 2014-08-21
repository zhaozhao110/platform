package com.gdps.module.peopleImage.tool
{
	import com.sandy.utils.BitmapDataUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	
	import com.sandy.core.FlexGlobals;
	
	import spark.core.SpriteVisualElement;
	
	/**
	 * 合并阴影
	 */ 
	public class ComposeImageTool
	{
		
		public static function compose(bit1:Bitmap,bit2:Bitmap):Bitmap
		{
			var sp:SpriteVisualElement = new SpriteVisualElement();
			FlexGlobals.topLevelApplication.addElement(sp);
			
			var sp2:SpriteVisualElement = new SpriteVisualElement();
			
			sp2.addChild(bit2);
			sp2.alpha = .5;
			sp2.filters = [new BlurFilter(4,4)];
			
			sp.addChild(sp2);
			sp.addChild(bit1);
			
			
			var bit:BitmapData = BitmapDataUtil.getBitmapData(bit1.width,bit1.height);
			bit.draw(sp,null,null,null,null,true);
			
			FlexGlobals.topLevelApplication.removeElement(sp);
			var bitmap:Bitmap = new Bitmap(bit);
			return bitmap;
		}
		
		
	}
}