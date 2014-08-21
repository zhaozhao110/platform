package com.editor.module_ui.app.css
{
	import com.editor.component.LogContainer;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UITabBar;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.css.CSSShowContainer;
	import com.editor.module_ui.ui.UIEditManager;
	import com.sandy.manager.data.SandyDragSource;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CSSEditor extends UICanvas
	{
		public function CSSEditor()
		{
			super();
			create_init();
		}
		
		public var content:UICanvas;
		public var toolBar:CSSEditorTopBar;
		public var logCont:LogContainer;
		private var vbox:UIVBox;
		public var showContainer:CSSShowContainer;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			cornerRadius = 10;
			padding = 10;
			verticalGap = 10;
			
			vbox = new UIVBox();
			vbox.enabledPercentSize = true;
			addChild(vbox);
						
			toolBar = new CSSEditorTopBar();
			toolBar.styleName = "uicanvas"
			vbox.addChild(toolBar);
			
			showContainer = new CSSShowContainer();
			vbox.addChild(showContainer);
			
			logCont = new LogContainer();
			addChild(logCont);
			
			//dragAndDrop = true;
			
			UIEditManager.cssEditor = this;
		}
		
	}
}