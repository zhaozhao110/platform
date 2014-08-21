package com.editor.moudule_drama.popup.preview.component
{
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	public class DramaPreview_Movie extends DramaPreview_DisplayObject
	{
		private var _movie:MovieClip;
		public function DramaPreview_Movie()
		{
			
		}

		public function get movie():MovieClip
		{
			return _movie;
		}

		public function set movie(value:MovieClip):void
		{
			disposeAllChild();			
			addChild(value);			
			_movie = value;
		}
		
		private function disposeAllChild():void
		{
			var len:int = numChildren;
			for(var i:int=len-1;i>=0;i--)
			{
				var obj:DisplayObject = getChildAt(i);
				if(obj)
				{
					removeChild(obj);					
					if(obj is MovieClip)
					{
						UIComponentUtil.stopAllInMovieClip((obj as MovieClip));
					}					
					obj = null;
				}
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			disposeAllChild();
		}

	}
}