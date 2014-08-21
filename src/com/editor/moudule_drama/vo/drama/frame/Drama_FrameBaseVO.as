package com.editor.moudule_drama.vo.drama.frame
{
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;

	public class Drama_FrameBaseVO extends TimelineKeyframe_BaseVO
	{
		/**所在的片段剪辑**/
		public var frameClipId:String;
		public function Drama_FrameBaseVO()
		{
			
		}
		
		override public function clone():ITimelineKeyframe_BaseVO
		{
			var cloneObj:Drama_FrameBaseVO = new Drama_FrameBaseVO();
			
			cloneObj.id = id;
			cloneObj.type = type;
			cloneObj.rowId = rowId;
			cloneObj.frame = frame;
			
			/**base**/
			cloneObj.frameClipId = frameClipId;
			
			return cloneObj;
		}
		
		/**解析扩展数据XML**/
		public function parseExtendXML(x:XML):void{}
		
	}
}