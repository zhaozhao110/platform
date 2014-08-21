package com.editor.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.modules.common.layout1.AppLayout1Container;
	import com.editor.modules.common.layout1.center.AppLayout1CenterContainer;
	import com.editor.modules.common.layout1.left.AppLayout1LeftContainer;
	import com.editor.modules.common.layout1.right.AppLayout1RightContainer;

	/**
	 * 左，中，右
	 */ 
	public class UIModule1 extends UICanvas
	{
		public function UIModule1()
		{
			super();
			create_init();
		}
		
		public var layout1Container:AppLayout1Container;
		
		public function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			cornerRadius = 10;
			//verticalGap = 5;
			
			layout1Container = new AppLayout1Container(this);
			addChild(layout1Container);
		}
		
		public function getMiddleContainer():AppLayout1CenterContainer
		{
			return layout1Container.middleContainer;
		}
		
		public function getRightContainer():AppLayout1RightContainer
		{
			return layout1Container.rightContainer
		}
		
		public function getLeftContainer():AppLayout1LeftContainer
		{
			return layout1Container.leftContainer;
		}
		
	}
}