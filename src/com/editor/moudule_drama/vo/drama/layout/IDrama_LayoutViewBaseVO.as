package com.editor.moudule_drama.vo.drama.layout
{
	/**
	 * 布局显示对象
	 * @author sun
	 * 
	 */	
	public interface IDrama_LayoutViewBaseVO
	{
		function get id():String;
		function set id(value:String):void;
		
		function get rowId():String;		
		function set rowId(value:String):void;
		
		function get sourceId():int;		
		function set sourceId(value:int):void;
		
		function get sourceName():String;		
		function set sourceName(value:String):void;
		
		function get sourceType():int;		
		function set sourceType(value:int):void;
		
		function get fileType():int;		
		function set fileType(value:int):void;
	}
}