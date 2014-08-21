package com.editor.moudule_drama.timeline.vo.interfaces
{
	/**
	 * 选中的帧VO
	 * @author sun
	 * 
	 */	
	public interface ITimelinePostFrameVO
	{
		function get id():String;
		function set id(value:String):void;
		
		function get rowId():String;
		function set rowId(value:String):void;
		
		function get frame():int;
		function set frame(value:int):void;
	}
}