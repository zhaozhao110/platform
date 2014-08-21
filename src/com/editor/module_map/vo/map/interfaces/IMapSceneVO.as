package com.editor.module_map.vo.map.interfaces
{
	public interface IMapSceneVO
	{
		function get id():String;
		function set id(value:String):void;
		function get type():int;
		function set type(value:int):void;
		function get x():int;
		function set x(value:int):void;		
		function get y():int;
		function set y(value:int):void;
		function get index():int;
		function set index(value:int):void;
		function get data():*;
		function set data(value:*):void;
	}
}