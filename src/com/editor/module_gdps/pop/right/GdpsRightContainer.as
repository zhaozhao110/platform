package com.editor.module_gdps.pop.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.module_gdps.component.GdpsLoadingProgressBar;
	import com.editor.module_gdps.component.GdpsMsgProgressBar;
	import com.sandy.utils.FilterTool;

	public class GdpsRightContainer extends UICanvas
	{
		public function GdpsRightContainer()
		{
			super();
			
			create_init();
		}
		
		public var tabNav:UITabBarNav;
		public var loadingProgressBar:GdpsLoadingProgressBar;
		public var msgProgressBar:GdpsMsgProgressBar;
		public var backCell:UICanvas;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			
			backCell = new UICanvas();
			backCell.backgroundColor = 0xFFFFFF;
			backCell.enabledPercentSize = true;
			backCell.visible = false;
			backCell.filters = [FilterTool.getDropShadowFilter(4,4)];
			addChild(backCell);
			
			tabNav = new UITabBarNav();
			tabNav.paddingLeft = 2;
			tabNav.paddingTop = 2;
			tabNav.enabledPercentSize = true;
			tabNav.enabledTabClose = true;
			tabNav.enabled_anchor = true;
			tabNav.dropDownWidth = 300;
			tabNav.tabOffset = 0;
			addChild(tabNav);
			
			loadingProgressBar = new GdpsLoadingProgressBar();
			loadingProgressBar.visible = false;
			loadingProgressBar.enabledPercentSize = true;
			addChild(loadingProgressBar);
			
			msgProgressBar = new GdpsMsgProgressBar();
			msgProgressBar.visible = false;
			msgProgressBar.enabledPercentSize = true;
			addChild(msgProgressBar);
			
			initComplete();
		}
	}
}