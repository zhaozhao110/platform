package com.editor.module_avg.view.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_avg.popview.attri.AVGAttriView;
	import com.editor.module_avg.preview.AVGPreview;
	import com.sandy.asComponent.event.ASEvent;
	
	public class AVGModuleRightContainer extends UICanvas
	{
		public function AVGModuleRightContainer()
		{
			super();
			create_init();
		}
		
		public var preView:AVGPreview;
		public var rightPreView:AVGModRightPreview;
		public var topBar:AVGModRightTopBar;
		public var attriView:AVGAttriView;
		
		private function create_init():void
		{
			mouseChildren = false;
			mouseEnabled = false;
			enabledPercentSize = true
			styleName = "uicanvas";
			x = 310
			y = 30;
			
			preView = new AVGPreview();
			addChild(preView);
			
			attriView = new AVGAttriView();
			addChild(attriView);
			
			topBar = new AVGModRightTopBar();
			addChild(topBar);
			
			rightPreView = new AVGModRightPreview();
			addChild(rightPreView);
			rightPreView.addEventListener(ASEvent.VISIBLE_CHANGE,rightPreChange);
		}
		
		private function rightPreChange(e:ASEvent):void
		{
			topBar.visible = !rightPreView.visible;
		}
		
	}
}