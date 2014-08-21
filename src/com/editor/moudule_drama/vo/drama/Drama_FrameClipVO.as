package com.editor.moudule_drama.vo.drama
{
	import com.sandy.math.HashMap;

	/**
	 * 剧情片断
	 * @author sun
	 * 
	 */	
	public class Drama_FrameClipVO
	{
		public var id:String;
		public var name:String;
		public var index:int;
		public var lastFrame:int;
		
		/**关键帧列表**/
		public var keyframeList:HashMap;
		/**显示资源列表**/
//		public var layoutViewList:HashMap;
		
		public function Drama_FrameClipVO()
		{
			keyframeList = new HashMap();
		}
		
		
		
	}
}