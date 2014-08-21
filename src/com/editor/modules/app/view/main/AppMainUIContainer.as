package com.editor.modules.app.view.main
{
	import com.air.utils.AIRUtils;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.manager.DataManager;
	import com.editor.modules.app.view.ui.bottom.AppBottomContainer;
	import com.editor.modules.app.view.ui.topBar.AppTopBarContainer;
	import com.sandy.asComponent.containers.ASCanvas;
	
	
	public class AppMainUIContainer extends UIVBox
	{
		public function AppMainUIContainer()
		{
			super();
			create_init()
		}
		
		public var topBarContainer:AppTopBarContainer;
		public var viewStack:AppMainUIViewStack;
		public var bottomContainer:AppBottomContainer;
		
		public function create_init():void
		{
			name = "AppMainUIContainer"
			styleName = "uicanvas"
			enabledPercentSize=true;
			backgroundColor = DataManager.def_col;
			
			//通用的顶部
			topBarContainer = new AppTopBarContainer();
			addChild(topBarContainer);
			
			//包括各个stack,包含所有的透视图
			viewStack = new AppMainUIViewStack();
			viewStack.y = 30
			addChild(viewStack);
			
			//通用的底部
			bottomContainer = new AppBottomContainer();
			bottomContainer.height = 30;
			bottomContainer.percentWidth = 100;
		//	bottomContainer.background_red = true
			addChild(bottomContainer);
			
			initComplete();
		}
		
		
		
	}
}