package com.editor.modules.common.app
{
	import com.editor.component.UIModule1;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.modules.common.app.center.AppMiddleCenterContainer;
	import com.editor.modules.common.app.left.AppMiddleLeftContainer;
	import com.editor.modules.common.app.right.AppMiddleRightContainer;

	public class AppMiddleContainer extends UIModule1
	{
		public function AppMiddleContainer()
		{
			super();
			
		}
		
		public var middleLeft:AppMiddleLeftContainer;
		public var middleCenter:AppMiddleCenterContainer;
		public var middleRight:AppMiddleRightContainer;
		
		override public function create_init():void
		{
			super.create_init();
			enabledPercentSize = true;
			
			middleLeft = new AppMiddleLeftContainer();
			middleLeft.enabledPercentSize = true;
			getLeftContainer().addChild(middleLeft);
			
			middleCenter = new AppMiddleCenterContainer();
			middleCenter.enabledPercentSize = true
			getMiddleContainer().addChild(middleCenter);
			
			middleRight = new AppMiddleRightContainer();
			middleRight.enabledPercentSize = true
			getRightContainer().addChild(middleRight);
			
			initComplete();
		}
		
	}
}