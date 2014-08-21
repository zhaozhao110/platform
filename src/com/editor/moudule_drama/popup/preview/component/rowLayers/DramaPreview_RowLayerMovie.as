package com.editor.moudule_drama.popup.preview.component.rowLayers
{
	import com.editor.moudule_drama.manager.DramaManager;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_Movie;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_RowLayer;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameMovieVO;
	import com.sandy.utils.UIComponentUtil;

	/**
	 * 影片层
	 * @author sun
	 * 
	 */	
	public class DramaPreview_RowLayerMovie extends DramaPreview_RowLayer
	{
		private var curMovie:DramaPreview_Movie;
		public function DramaPreview_RowLayerMovie()
		{
			
		}
				
		override public function processKeyFrameVO(vo:ITimelineKeyframe_BaseVO):void
		{
			if(vo)
			{
				var movieVO:Drama_FrameMovieVO = vo as Drama_FrameMovieVO;
				if(movieVO)
				{
					var mId:String = movieVO.movieId.toString();
					var a:Array = layoutList;
					var len:int = a.length;
					for(var i:int=0;i<len;i++)
					{
						var m:DramaPreview_Movie = a[i] as DramaPreview_Movie;
						if(m && m.ident == mId)
						{
							DramaManager.getInstance().get_DramaPreviewPopupwinMediator().previewContainer.pause();
							
							curMovie = m;
							m.movie.addFrameScript(m.movie.totalFrames-1, movieFrameScriptHandle);
							addChild(m);
							UIComponentUtil.playAllInMovieClip(m.movie);
						}
					}
				}
			}
		}
		
		private function movieFrameScriptHandle():void
		{
			if(curMovie)
			{
				UIComponentUtil.stopAllInMovieClip(curMovie.movie);
				curMovie.movie.addFrameScript(curMovie.movie.totalFrames-1, null);
				if(contains(curMovie))
				{
					removeChild(curMovie);
				}
				DramaManager.getInstance().get_DramaPreviewPopupwinMediator().previewContainer.dePause();
				
			}
		}
		
		
		
	}
}