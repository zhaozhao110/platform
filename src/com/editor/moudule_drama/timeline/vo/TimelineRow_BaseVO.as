package com.editor.moudule_drama.timeline.vo
{
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineRow_BaseVO;

	/**
	 * 时间轴层	BaseVO	 >= (id:id, name:name, type:type, index:层次)
	 * @author sun
	 * 
	 */	
	public class TimelineRow_BaseVO implements ITimelineRow_BaseVO
	{
		private var _id:String;
		private var _name:String;
		private var _type:int;
		private var _index:int;
		public function TimelineRow_BaseVO(id:String="", name:String="", type:int=0, index:int=0)
		{
			_id = id;
			_name = name;
			_type = type;
			_index = index;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}


	}
}