package com.editor.moudule_drama.timeline.vo.interfaces
{
	/**
	 * 时间轴关键帧	BaseVO
	 * @author sun
	 * 
	 */	
	public interface ITimelineKeyframe_BaseVO
	{
		function clone():ITimelineKeyframe_BaseVO;
		
		function get id():String;
		function set id(value:String):void;
		
		/**类型（1普通帧、2空白帧、3补间帧）**/
		function get type():int;
		function set type(value:int):void;
		
		function get rowId():String;
		function set rowId(value:String):void;
		
		function get frame():int;
		function set frame(value:int):void;
	}
}