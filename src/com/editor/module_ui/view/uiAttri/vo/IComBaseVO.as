package com.editor.module_ui.view.uiAttri.vo
{
	import com.editor.module_ui.view.uiAttri.com.IComBase;
	import com.editor.module_ui.vo.CSSComponentData;

	public interface IComBaseVO
	{
		function getCSSXML():String
		function createCSSXML(data:CSSComponentData,a:Array):void;
		function getCSSFile():String
				
		function get key():String
		function set key(value:String):void
	
		function set target(value:IComBase):void;
		function get target():IComBase;
		
		function get value():*
		function set value(value:*):void
		
	}
}