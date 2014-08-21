package com.editor.moudule_drama.vo.drama.frame
{
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;

	/**
	 * 影片	关键帧
	 * 
	 */	
	public class Drama_FrameMovieVO extends Drama_FrameBaseVO
	{
		public var movieId:int;
		public var movieX:int;
		public var movieY:int;
		public function Drama_FrameMovieVO()
		{
		}
		
		override public function clone():ITimelineKeyframe_BaseVO
		{
			var cloneObj:Drama_FrameMovieVO = new Drama_FrameMovieVO();
			
			cloneObj.id = id;
			cloneObj.type = type;
			cloneObj.rowId = rowId;
			cloneObj.frame = frame;
			
			/**base**/
			cloneObj.frameClipId = frameClipId;
			
			/**self**/
			cloneObj.movieId = movieId;
			cloneObj.movieX = movieX;
			cloneObj.movieY = movieY;
			
			return cloneObj;
		}
		
		override public function parseExtendXML(x:XML):void
		{
			this.movieId = x.@mid;
			this.movieX = x.@mx;
			this.movieY = x.@my;
		}
		
		
		
	}
}