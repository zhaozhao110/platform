package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;

	public interface IComBase
	{
		function set item(value:ComAttriItemVO):void
		function get item():ComAttriItemVO
		
		function set compItem(value:ComponentData):void
		function get compItem():ComponentData
		
		function set reflashFun(value:Function):void
		function get reflashFun():Function
					
		function getValue():IComBaseVO;
		function setValue(obj:IComBaseVO):void
		function checkIsDel():Boolean
	}
}