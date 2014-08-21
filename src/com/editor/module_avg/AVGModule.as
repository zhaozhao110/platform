package com.editor.module_avg
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_avg.pop.preview.AVGPlayview;
	import com.editor.module_avg.view.left.AVGModuleLeftContainer;
	import com.editor.module_avg.view.right.AVGModuleRightContainer;
	import com.editor.module_avg.view.top.AVGModuleTopContainer;
	import com.sandy.component.expand.ModelMaskContainer;

	public class AVGModule extends UICanvas
	{
		public function AVGModule()
		{
			super(); 
			create_init();
		}
		
		public static const MODULENAME:String = "AVGModule";
				
		public var toolBar:AVGModuleTopContainer;
		public var leftCont:AVGModuleLeftContainer;
		public var rightCont:AVGModuleRightContainer;
		public var popCont:UICanvas;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			cornerRadius = 10;
			
			toolBar = new AVGModuleTopContainer();
			addChild(toolBar);
			
			leftCont = new AVGModuleLeftContainer();
			addChild(leftCont);
			
			rightCont = new AVGModuleRightContainer();
			addChild(rightCont);
			
			popCont = new UICanvas();
			popCont.enabledPercentSize = true
			popCont.visible = false;
			addChild(popCont);
			
			var model:ModelMaskContainer = new ModelMaskContainer()
			popCont.addChild(model);
			//model.backgroundAlpha = 1;
					
		}
	}
}