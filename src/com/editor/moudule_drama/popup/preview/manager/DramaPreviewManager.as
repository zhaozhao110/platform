package com.editor.moudule_drama.popup.preview.manager
{
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameMovieVO;
	import com.editor.moudule_drama.vo.drama.frame.Drama_FrameSceneVO;

	public class DramaPreviewManager
	{
		public function DramaPreviewManager()
		{
		}
		
		/**获取场景帧列表中_场景资源列表**/
		public static function getSceneDefLayerSourceIdList_ByKeyframeList(a:Array):Array
		{
			var outA:Array = [];
			
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var keyfVO:Drama_FrameSceneVO = a[i] as Drama_FrameSceneVO;
				var bool:Boolean = true;
				if(keyfVO)
				{
					var len2:int = outA.length;
					for(var j:int=0;j<len2;j++)
					{
						var sid:int = int(outA[j]);
						if(sid == keyfVO.sceneBackgroundSourceId)
						{
							bool = false;
						}
					}
					
					if(bool)
					{
						outA.push(keyfVO.sceneBackgroundSourceId);
					}
					
				}
			}
			
			return outA;
		}
		
		
		/**获取场景帧列表中_影片资源列表**/
		public static function getMovieSourceIdList_ByKeyframeList(a:Array):Array
		{
			var outA:Array = [];
			
			var len:int = a.length;
			for(var i:int=0;i<len;i++)
			{
				var keyfVO:Drama_FrameMovieVO = a[i] as Drama_FrameMovieVO;
				var bool:Boolean = true;
				if(keyfVO)
				{
					var len2:int = outA.length;
					for(var j:int=0;j<len2;j++)
					{
						var mid:int = int(outA[j]);
						if(mid == keyfVO.movieId)
						{
							bool = false;
						}
					}
					
					if(bool)
					{
						outA.push(keyfVO.movieId);
					}
					
				}
			}
			
			return outA;
		}
		
		
		
		
		
		
		
	}
}