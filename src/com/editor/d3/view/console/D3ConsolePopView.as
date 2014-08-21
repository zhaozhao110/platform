package com.editor.d3.view.console
{
	import com.editor.component.containers.UIVBox;

	public class D3ConsolePopView extends UIVBox
	{
		public function D3ConsolePopView()
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			styleName = "uicanvas"
			enabledPercentSize = true;
			padding = 2;
				
		}
	}
}