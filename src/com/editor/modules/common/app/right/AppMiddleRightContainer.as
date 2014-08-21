package com.editor.modules.common.app.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;

	public class AppMiddleRightContainer extends UICanvas
	{
		public function AppMiddleRightContainer()
		{
			super();
			create_init();
		}
		
		public var tabBar:UITabBarNav;
		
		private function create_init():void
		{
			styleName = "uicanvas";
			cornerRadius = 10;
				
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			tabBar.y = 1;
			tabBar.tabHeight = 25
			addChild(tabBar);
		}
	}
}