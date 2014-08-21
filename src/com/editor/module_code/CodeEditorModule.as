package com.editor.module_code
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;
	
	import flash.events.MouseEvent;

	public class CodeEditorModule extends UICanvas
	{
		public function CodeEditorModule()
		{
			super();
			create_init();
		}
		
		
		public var tabbar:UITabBarNav;
				
		private function create_init():void
		{
			enabledPercentSize = true;
			
			tabbar = new UITabBarNav();
			tabbar.name = "CodeEditorModule";
			tabbar.enabledPercentSize = true
			tabbar.paddingLeft = 2;
			tabbar.paddingTop = 2;
			tabbar.contentPaddingLeft = 2;
			tabbar.contentPaddingRight = 2
			tabbar.enabledTabClose = true
			tabbar.enabled_anchor = true
			tabbar.dropDownWidth = 300
			addChild(tabbar);
			
		}
		
	}
}