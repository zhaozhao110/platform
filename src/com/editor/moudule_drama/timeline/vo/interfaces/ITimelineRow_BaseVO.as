package com.editor.moudule_drama.timeline.vo.interfaces
{
	/**
	 * 时间轴层	BaseVO
	 * @author sun
	 * 
	 */	
	public interface ITimelineRow_BaseVO
	{
		function get id():String;
		function set id(value:String):void;
		
		function get name():String;
		function set name(value:String):void;
		
		function get type():int;
		function set type(value:int):void;
		
		function get index():int;
		function set index(value:int):void;
		
		
	}
}