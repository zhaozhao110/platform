package com.editor.module_ui.css
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICodeEditor;
	import com.editor.component.controls.UITabBar;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CSSShowContainer extends UIVBox
	{
		public function CSSShowContainer()
		{
			super();
			create_init();
		}
		
		public var textArea:UICodeEditor;
		public var tabbar:UITabBar;
		
		private function create_init():void
		{
			verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			
			paddingLeft = 3;
			paddingBottom = 3;
			paddingRight = 3;
			enabledPercentSize = true;
						
			tabbar = new UITabBar();
			tabbar.percentWidth = 100;
			tabbar.height = 30;
			tabbar.paddingLeft = 2;
			tabbar.paddingTop = 2;
			tabbar.contentPaddingLeft = 2;
			tabbar.contentPaddingRight = 2
			tabbar.enabledTabClose = true
			addChild(tabbar);
			
			textArea = new UICodeEditor();
			textArea.enabledPercentSize = true
			//textArea.around = 5;
			addChild(textArea);
		}
		
		
	}
}