package com.editor.modules.common.app.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;
	import com.sandy.asComponent.controls.ASTextField;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class AppMiddleLeftContainer extends UICanvas
	{
		public function AppMiddleLeftContainer()
		{
			super();
			create_init();
		}
		
		public var tabBar:UITabBarNav;
		//public var 
		
		private function create_init():void
		{
			styleName = "uicanvas"
			cornerRadius = 10;
			
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			tabBar.y = 1;
			tabBar.tabHeight = 25;
			addChild(tabBar);
						
			initComplete();
		}
		
	}
}