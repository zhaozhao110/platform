package com.editor.modules.common.layout1.center
{
	import com.editor.component.containers.UICanvas;
	import com.editor.modules.common.layout1.AppLayout1Container;

	public class AppLayout1CenterContainer extends UICanvas
	{
		public function AppLayout1CenterContainer(_module:AppLayout1Container)
		{
			super();
			module = _module;
			create_init();
		}
		
		private var module:AppLayout1Container;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			
		}
	}
}