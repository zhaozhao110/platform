package com.editor.modules.common.layout1.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.modules.common.layout1.AppLayout1Container;

	public class AppLayout1LeftContainer extends UICanvas
	{
		public function AppLayout1LeftContainer(_module:AppLayout1Container)
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			width = 300;
			percentHeight = 100;
			styleName = "uicanvas"
			//background_red = true;
		}
	}
}