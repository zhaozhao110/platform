package com.editor.modules.common.layout2.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.modules.common.layout2.AppLayout2Container;

	public class AppLayout2LeftContainer extends UICanvas
	{
		public function AppLayout2LeftContainer(_module:AppLayout2Container)
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			width = 300;
			percentHeight = 100;
			styleName = "uicanvas"
				
		}
	}
}