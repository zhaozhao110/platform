package com.editor.modules.common.app.center
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	
	public class AppMiddleCenterTopContainer extends UIVBox
	{
		public function AppMiddleCenterTopContainer()
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			styleName = "uicanvas"
			cornerRadius = 10;
			paddingLeft = 2;
			paddingRight = 2
			paddingBottom = 2
			
		}
	}
}