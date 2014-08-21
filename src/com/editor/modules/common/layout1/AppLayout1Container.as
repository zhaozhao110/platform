package com.editor.modules.common.layout1
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.modules.common.layout1.center.AppLayout1CenterContainer;
	import com.editor.modules.common.layout1.left.AppLayout1LeftContainer;
	import com.editor.modules.common.layout1.right.AppLayout1RightContainer;

	public class AppLayout1Container extends UIHBox
	{
		public function AppLayout1Container(_module:UICanvas)
		{
			super();
			module = _module;
			create_init();
		}
		
		private var module:UICanvas
		public var leftContainer:AppLayout1LeftContainer;
		public var middleContainer:AppLayout1CenterContainer;
		public var rightContainer:AppLayout1RightContainer;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			//styleName = "uicanvas"
			name = "AppLayout1Container"
			cornerRadius = 10;
			
			leftContainer = new AppLayout1LeftContainer(this);
			this.addChild(leftContainer);
			
			middleContainer = new AppLayout1CenterContainer(this);
			this.addChild(middleContainer);
			
			rightContainer = new AppLayout1RightContainer(this);
			this.addChild(rightContainer);
		}
		
		public function getLeftContainer():AppLayout1LeftContainer
		{
			return leftContainer;
		}
		
		public function getRightContainer():AppLayout1RightContainer
		{
			return rightContainer;
		}
		
		public function getMiddleContainer():AppLayout1CenterContainer
		{
			return middleContainer;
		}
		
	}
}