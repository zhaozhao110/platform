package com.editor.modules.common.layout2
{
	import com.editor.component.containers.UIHBox;
	import com.editor.modules.common.layout2.left.AppLayout2LeftContainer;
	import com.editor.modules.common.layout2.right.AppLayout2RightContainer;

	public class AppLayout2MiddleContainer extends UIHBox
	{
		public function AppLayout2MiddleContainer(_module:AppLayout2Container)
		{
			super();
			module = _module;
			create_init();
		}
		
		private var module:AppLayout2Container
		public var leftContainer:AppLayout2LeftContainer;
		public var rightContainer:AppLayout2RightContainer;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			//cornerRadius = 10;
			horizontalGap = 5;
				
			leftContainer = new AppLayout2LeftContainer(module);
			addChild(leftContainer);
			
			rightContainer = new AppLayout2RightContainer(module);
			addChild(rightContainer);
		}
	}
}