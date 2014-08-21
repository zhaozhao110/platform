package com.editor.module_html
{
	import com.editor.component.UIModule2;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.module_html.view.HtmlModuleContent;
	import com.editor.module_html.view.HtmlModuleFav;
	import com.editor.module_html.view.HtmlModuleToolBar;

	public class HtmlModule extends UIModule2
	{
		public function HtmlModule()
		{
			super();
		}
				
		public var toolBar:HtmlModuleToolBar;
		public var cont:HtmlModuleContent;
		public var fav:HtmlModuleFav;
		
		override protected function get addLogBool():Boolean
		{
			return false;
		}
		
		override public function create_init():void
		{
			super.create_init();
			
			toolBar = new HtmlModuleToolBar();
			layout2Container.getToolBar().addChild(toolBar);
			
			fav = new HtmlModuleFav();
			layout2Container.getLeftContainer().addChild(fav);
			layout2Container.getLeftContainer().width = 10;
						
			cont = new HtmlModuleContent();
			layout2Container.getRightContainer().addChild(cont);
			
			
		}
	}
}