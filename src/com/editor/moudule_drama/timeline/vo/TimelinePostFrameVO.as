package com.editor.moudule_drama.timeline.vo
{
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelinePostFrameVO;

	/**
	 * 传递数据的帧VO
	 * @author sun
	 * 
	 */	
	public class TimelinePostFrameVO implements ITimelinePostFrameVO
	{
		private var _id:String;
		private var _rowId:String;
		private var _frame:int;
		public function TimelinePostFrameVO(id:String="", rowId:String="", frame:int=0)
		{
			this.id = id;
			this.rowId = rowId;
			this.frame = frame;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
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