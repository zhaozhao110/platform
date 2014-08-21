package com.editor.module_map.vo.map.interfaces
{
	public interface IMapSceneResVO extends IMapSceneVO
	{
		function get sourceId():String;
		function set sourceId(value:String):void;
		function get sourceName():String;
		function set sourceName(value:String):void;
		function get sceneId():String;
		function set sceneId(value:String):void;
		function get name():String;
		function set name(value:String):void;
		function get locked():int;
		function set locked(value:int):void;
	}
}