package com.editor.modules.common.layout2.top
{
	import com.editor.component.containers.UIHBox;
	import com.editor.modules.common.layout2.AppLayout2Container;

	public class AppLayout2ToolBar extends UIHBox
	{
		public function AppLayout2ToolBar(_module:AppLayout2Container)
		{
			super();
			create_init();
		}
		
		
		
		private function create_init():void
		{
			percentWidth = 100;
			height = 30;
			styleName = "uicanvas"
			//cornerRadius = 10;
		}
	}
}