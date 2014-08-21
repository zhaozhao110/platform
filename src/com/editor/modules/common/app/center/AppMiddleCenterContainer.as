package com.editor.modules.common.app.center
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIVDividedBox;
	import com.editor.component.containers.UIViewStack;
	
	public class AppMiddleCenterContainer extends UIViewStack
	{
		public function AppMiddleCenterContainer()
		{
			super();
			create_init();
		}
		
		public var vdivBox:UIVDividedBox;
		public var topContainer:AppMiddleCenterTopContainer;
		public var bottomContainer:AppMiddleCenterBottomContainer;
		
		private function create_init():void
		{
			
			// 上下
			//code
			vdivBox = new UIVDividedBox();
			vdivBox.enabledPercentSize = true;
			addChild(vdivBox);
			
			var area_a:Array = [];
			
			topContainer = new AppMiddleCenterTopContainer();
			topContainer.enabledPercentSize = true;
			area_a.push(topContainer);
			
			bottomContainer = new AppMiddleCenterBottomContainer();
			bottomContainer.height = 200;
			bottomContainer.percentWidth = 100
			area_a.push(bottomContainer);
			
			vdivBox.areaComponent = area_a;
			
			
			
			
		}
		
	}
}