package com.editor.moudule_drama.popup.preview.component
{
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class DramaPreview_Sprite extends DramaPreview_DisplayObject
	{
		/**以底部坐标模式**/
		public var isBottomCoordModel:Boolean;
		private var _hConversionBool:int;
		private var _hConversionBoolTemp:int;
		
		private var setedX:Number;
		private var setedY:Number;
		
		public function DramaPreview_Sprite()
		{
			create_init();
		}
		
		public var resContainer:Sprite;
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
					(displayObj as MovieClip).gotoAndPlay(1);
					UIComponentUtil.playAllInMovieClip(displayObj as MovieClip);
				}
			}
		}
		
		public function updatePosition():void
		{
			x = setedX;
			y = setedY;
			hConversionBool = _hConversionBoolTemp;
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
		
		/**左右翻转	0不翻转 1翻转**/
		public function get hConversionBool():int
		{
			return _hConversionBool;
		}
		/**左右翻转	0不翻转 1翻转**/
		public function set hConversionBool(value:int):void
		{
			_hConversionBoolTemp = value;
			if(value != _hConversionBool)
			{
				var w:int = resContainer.width;
				var h:int = resContainer.height;
				if(w > 0 && h > 0)
				{
					var len:int = resContainer.numChildren;
					for(var i:int=len-1;i>=0;i--)
					{
						var child:DisplayObject = resContainer.getChildAt(i) as DisplayObject;
						if(child)
						{
							var matrix:Matrix = child.transform.matrix;
							matrix.transformPoint(new Point(w/2, h/2));
							if(matrix.a>0){
								matrix.a=-1*matrix.a;
								matrix.tx=w+child.x;
							}
							else
							{
								matrix.a=-1*matrix.a;
								matrix.tx=child.x-w;
							}
							child.transform.matrix=matrix;
						}
					}
					
					_hConversionBool = value;
					
				}
			}
		}
		
		
		/** set get : X / Y **/
		override public function set x(value:Number):void
		{
			setedX = value;
			if(isBottomCoordModel)
			{
				super.x = value - (resContainer.width/2);
			}else
			{
				super.x = value;
			}
		}
		override public function get x():Number
		{
			if(isBottomCoordModel)
			{
				return super.x + (resContainer.width/2);
			}else
			{
				return super.x;
			}
		}
		override public function set y(value:Number):void
		{
			setedY = value;
			if(isBottomCoordModel)
			{
				super.y = value - resContainer.height;
				
			}else
			{
				super.y = value;
			}
		}
		override public function get y():Number
		{
			if(isBottomCoordModel)
			{
				return super.y + resContainer.height;
			}else
			{
				return super.y;
			}
		}


	}
}