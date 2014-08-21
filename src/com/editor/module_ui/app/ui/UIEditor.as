package com.editor.module_ui.app.ui
{
	import com.editor.component.LogContainer;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.ui.UIShowContainer;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.manager.data.SandyDragSource;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;

	public class UIEditor extends UICanvas
	{
		public function UIEditor()
		{
			super()
			create_init();
		}
		
		public var content:UIViewStack;
		public var toolBar:UIEditorTopBar;
		public var tabbar:UITabBar;
		public var logCont:LogContainer
		
		private function create_init():void
		{
			UIEditManager.uiEditor = this;
			enabledPercentSize = true;
			styleName = "uicanvas"
			cornerRadius = 10;
			padding = 10;
			
			var vbox:UIVBox = new UIVBox();
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			toolBar = new UIEditorTopBar();
			toolBar.styleName = "uicanvas"
			vbox.addChild(toolBar);
			
			var sp:ASSpace = new ASSpace();
			sp.height = 10;
			vbox.addChild(sp);
			
			tabbar = new UITabBar();
			tabbar.percentWidth = 100;
			tabbar.height = 30;
			tabbar.paddingLeft = 2;
			tabbar.paddingTop = 2;
			tabbar.contentPaddingLeft = 2;
			tabbar.contentPaddingRight = 2
			tabbar.enabledTabClose = true
			vbox.addChild(tabbar);
			
			content = new UIViewStack();
			content.enabledPercentSize = true;
			vbox.addChild(content);
			
			logCont = new LogContainer();
			addChild(logCont);
			
			
		}
		
	}
}