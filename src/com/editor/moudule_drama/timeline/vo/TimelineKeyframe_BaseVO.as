package com.editor.moudule_drama.timeline.vo
{
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;

	/**
	 * 时间轴关键帧	BaseVO	>= (id:id, type:type, rowId:层id, frame:帧数)
	 * 
	 * @author sun
	 * 
	 * 
	 */	
	public class TimelineKeyframe_BaseVO implements ITimelineKeyframe_BaseVO
	{				
		private var _id:String;
		private var _type:int;
		private var _rowId:String;
		private var _frame:int;
		
		public function TimelineKeyframe_BaseVO(r:String="", f:int=0)
		{
			_rowId = r;
			_frame = f;
		}
		
		public function clone():ITimelineKeyframe_BaseVO
		{
			var cloneObj:TimelineKeyframe_BaseVO = new TimelineKeyframe_BaseVO();
			
			cloneObj.id = id;
			cloneObj.type = type;
			cloneObj.rowId = rowId;
			cloneObj.frame = frame;
			
			return cloneObj;
		}

		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		/**类型（1普通帧、2空白帧、3补间帧）**/
		public function get type():int
		{
			return _type;
		}
		/**类型（1普通帧、2空白帧、3补间帧）**/
		public function set type(value:int):void
		{
			_type = value;
		}
		
		public function get rowId():String
		{
			return _rowId;
		}

		public function set rowId(value:String):void
		{
			_rowId = value;
		}

		public function get frame():int
		{
			return _frame;
		}

		public function set frame(value:int):void
		{
			_frame = value;
		}
		
		
	}
}