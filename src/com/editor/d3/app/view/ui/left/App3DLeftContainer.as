package com.editor.d3.app.view.ui.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.manager.DataManager;

	public class App3DLeftContainer extends UICanvas
	{
		public function App3DLeftContainer()
		{
			super();
			create_init();
		}
		
		public var tabBar:UITabBarNav;
		
		private function create_init():void
		{
			mouseEnabled = true;
			styleName = "uicanvas"
			backgroundColor = DataManager.def_col
				
			tabBar = new UITabBarNav();
			tabBar.enabledPercentSize = true;
			tabBar.y = 1;
			tabBar.tabHeight = 25;
			addChild(tabBar);
			
			initComplete();
			
			visible = false;
		}
	}
}