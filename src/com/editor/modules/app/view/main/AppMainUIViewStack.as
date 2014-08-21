package com.editor.modules.app.view.main
{
	import com.editor.component.containers.UIViewStack;
	import com.editor.modules.common.app.AppMiddleContainer;
	
	public class AppMainUIViewStack extends UIViewStack
	{
		public function AppMainUIViewStack()
		{
			super();
			create_init();
		}
		
		public var contianer:AppMiddleContainer;
		
		private function create_init():void
		{
			enabledPercentSize = true;	
			
			contianer = new AppMiddleContainer();
			addChild(contianer);
		}
	}
}