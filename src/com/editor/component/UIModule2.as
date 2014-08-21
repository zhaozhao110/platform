package com.editor.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.modules.common.layout2.AppLayout2Container;
	import com.editor.modules.common.layout2.left.AppLayout2LeftContainer;
	import com.editor.modules.common.layout2.right.AppLayout2RightContainer;
	import com.editor.modules.common.layout2.top.AppLayout2ToolBar;

	/**
	 * 顶
	 * 左，中，右
	 */ 
	public class UIModule2 extends UICanvas
	{
		public function UIModule2()
		{
			super();
			create_init();
		}
		
		public var layout2Container:AppLayout2Container;
		protected function get addLogBool():Boolean
		{
			return true;
		}
		
		public function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			cornerRadius = 10;
			//verticalGap = 5;
			
			layout2Container = new AppLayout2Container(this,addLogBool);
			addChild(layout2Container);
		}
		
		public function getToolBar():AppLayout2ToolBar
		{
			return layout2Container.toolBar;
		}
		
		public function getLeftContainer():AppLayout2LeftContainer
		{
			return layout2Container.middleContainer.leftContainer;
		}
		
		public function getRightContainer():AppLayout2RightContainer
		{
			return layout2Container.middleContainer.rightContainer;
		}
		
		public function getLogContainer():LogContainer
		{
			return layout2Container.getRightContainer().logContainer;
		}
	}
}