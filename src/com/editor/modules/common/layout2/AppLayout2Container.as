package com.editor.modules.common.layout2
{
	import com.editor.component.LogContainer;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.modules.common.layout2.left.AppLayout2LeftContainer;
	import com.editor.modules.common.layout2.right.AppLayout2RightContainer;
	import com.editor.modules.common.layout2.top.AppLayout2ToolBar;

	public class AppLayout2Container extends UIVBox
	{
		public function AppLayout2Container(_module:UICanvas,_addLogBool:Boolean)
		{
			super();
			addLogBool = _addLogBool;
			module = _module;
			create_init();
		}
		
		public var addLogBool:Boolean=true;
		private var module:UICanvas
		public var toolBar:AppLayout2ToolBar;
		public var middleContainer:AppLayout2MiddleContainer;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			cornerRadius = 10;
			verticalGap = 5;
			
			toolBar = new AppLayout2ToolBar(this);
			addChild(toolBar);
			
			middleContainer = new AppLayout2MiddleContainer(this);
			addChild(middleContainer);
		}
		
		public function getToolBar():AppLayout2ToolBar
		{
			return toolBar;
		}
		
		public function getLeftContainer():AppLayout2LeftContainer
		{
			return middleContainer.leftContainer;
		}
		
		public function getRightContainer():AppLayout2RightContainer
		{
			return middleContainer.rightContainer;
		}
		
		public function getLogContainer():LogContainer
		{
			return getRightContainer().logContainer;
		}
		
	}
}