package com.editor.modules.common.app.center
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;
	
	public class AppMiddleCenterBottomContainer extends UICanvas
	{
		public function AppMiddleCenterBottomContainer()
		{
			super();
			create_init();
		}
		
		public var tabBar:UITabBarNav;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			cornerRadius = 10
			paddingLeft = 2;
			paddingRight = 2;
			paddingBottom = 2;
			
			tabBar = new UITabBarNav();
			//tabBar.background_red = true;
			tabBar.enabledPercentSize = true;
			tabBar.y = 1;
			addChild(tabBar);
			
			tabBar.selectedIndex = 0;
			
			initComplete();
		}
	}
}