package com.editor.d3.vo.comp
{
	import com.editor.d3.object.base.D3ObjectBase;

	public interface ID3CompItem
	{
		function get id():int
		function set id(value:int):void
		
		function get name():String
		function set name(value:String):void
			
		function get outline_attri():String
		function set outline_attri(value:String):void
		
		function get project_attri():String
		function set project_attri(value:String):void
		
		function get en():String
		function set en(value:String):void
		
		function get group():int
		function set group(value:int):void
		
		function get data():*
		function set data(value:*):void
		
		function get outline_attri2():String
		function set outline_attri2(value:String):void
		
		function get isSkyBox():Boolean
		function getObject(from:int):D3ObjectBase;
		
	}
}