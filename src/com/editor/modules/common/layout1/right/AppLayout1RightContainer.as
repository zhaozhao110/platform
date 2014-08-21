package com.editor.modules.common.layout1.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.modules.common.layout1.AppLayout1Container;

	public class AppLayout1RightContainer extends UICanvas
	{
		public function AppLayout1RightContainer(_module:AppLayout1Container)
		{
			super();
			module = _module;
			create_init();
		}
		
		private var module:AppLayout1Container;
		
		private function create_init():void
		{
			percentHeight = 100;
			width = 300;
			styleName = "uicanvas"
			
		}
		
	}
}