package com.editor.module_ui.ui.vo
{
	import com.sandy.asComponent.core.ASComponent;

	public class OutlineData
	{
		public function OutlineData()
		{
		}
		
		public var list:Array = [];
		
		public function add(ui:ASComponent):void
		{
			list.push(ui);
		}
	}
}