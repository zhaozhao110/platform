package com.editor.moudule_drama.timeline.event
{
	import flash.events.Event;
	public class TimelineEvent extends Event
	{
		public static const SELECTED_ONE_FRAME:String = "selectedOneFrame";
		public static const CHANGE_ONE_FRAME:String = "changeOneFrame";
		public static const DELETE_ONE_FRAME:String = "deleteOneFrame";
		
		public var data:*;
		public function TimelineEvent(type:String, data:* = null)
		{
			super(type);
			this.data = data;
		}
		
		public override function clone():Event 
		{ 
			return new TimelineEvent(type,data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TimelineEvent", "type", "data");
		}
		
	}
}