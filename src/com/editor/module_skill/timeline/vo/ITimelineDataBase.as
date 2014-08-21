package com.editor.module_skill.timeline.vo
{
	public interface ITimelineDataBase
	{
		function get row():int
		function set row(value:int):void
		
		function get frame():int
		function set frame(value:int):void
		
		function get isKey():Boolean
		function set isKey(value:Boolean):void
					
		function getData():String;
		function getLabel():String
		function reflash():void
		function remove():void;
		function play():void;
		function save():*;
		function parser(v:String):void;
		
	}
}