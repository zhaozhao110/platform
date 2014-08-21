package com.editor.module_pop.serverDirManager.itemRenderer
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	
	public class ServerDirManagerBottomRenderer extends UICanvas
	{
		public function ServerDirManagerBottomRenderer()
		{
			super();
			create_init();
		}
		
		private var txt:UIText;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			percentWidth = 100;
			height = 30;
			
			txt = new UIText();
			txt.width = 800
			addChild(txt);
		}
		
		public function reflash(m:String):void
		{
			txt.htmlText = m;
		}
		
	}
}