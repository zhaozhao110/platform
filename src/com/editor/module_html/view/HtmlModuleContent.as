package com.editor.module_html.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;
	
	public class HtmlModuleContent extends UICanvas
	{
		public function HtmlModuleContent()
		{
			super();
			create_init();
		}
		
		public var nav:UITabBarNav;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			
			nav = new UITabBarNav();
			nav.tabWidth = 150;
			nav.enabledTabClose = true;
			nav.enabled_anchor = true
			nav.enabledPercentSize = true;
			addChild(nav);
		}
		
	}
}