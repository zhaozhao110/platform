package com.editor.module_map.popup.preview.component
{
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class PreviewSceneSprite extends PreviewDisplayObject
	{
		public var startFrame:int;
		public function PreviewSceneSprite()
		{
			super();
			create_init();
		}
		
		private var resContainer:Sprite;
		private function create_init():void
		{
			resContainer = new Sprite();
			addChild(resContainer);
		}
		
		public function addRes(res:DisplayObject):void
		{
			resContainer.addChild(res);
		}
		public function playRes():void
		{
			var len:int = resContainer.numChildren;
			for(var i:int=0;i<len;i++)
			{
				var displayObj:DisplayObject = resContainer.getChildAt(i) as DisplayObject;
				if(displayObj && displayObj is MovieClip)
				{
					(displayObj as MovieClip).gotoAndPlay(3);
					UIComponentUtil.playAllInMovieClip(displayObj as MovieClip);
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			var len:int = resContainer.numChildren;
			for(var i:int=len-1;i>=0;i--)
			{
				var disObj:DisplayObject = resContainer.getChildAt(i) as DisplayObject;
				if(disObj is Bitmap)
				{
					(disObj as Bitmap).bitmapData.dispose();
					(disObj as Bitmap).bitmapData = null;
				}else if(disObj is MovieClip)
				{
					(disObj as MovieClip).stop();
					UIComponentUtil.stopAllInMovieClip((disObj as MovieClip));
				}
				
				resContainer.removeChild(disObj);
				disObj = null;
			}
			
		}
		
		
	}
}