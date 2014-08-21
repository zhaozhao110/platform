package com.editor.module_avg.view.left
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.module_avg.popview.lib.AVGLibView;
	import com.editor.module_avg.popview.outline.AVGOutlineView;
	import com.editor.module_avg.popview.section.AVGSectionView;
	import com.editor.module_avg.popview.sett.AVGSetView;
	import com.editor.module_avg.popview.timeline.AVGTimelineView;
	
	public class AVGModuleLeftContainer extends UICanvas
	{
		public function AVGModuleLeftContainer()
		{
			super();
			create_init();
		}
		
		public var tabBar:UITabBarNav;
		
		public var libView:AVGLibView;
		public var outlineView:AVGOutlineView;
		public var sectionView:AVGSectionView;
		public var timelineView:AVGTimelineView;
		public var setView:AVGSetView;
		
		private function create_init():void
		{
			mouseChildren = false;
			mouseEnabled = false;
			width = 300;
			styleName = "uicanvas";
			percentHeight = 100;
			y  = 30;
			
			tabBar = new UITabBarNav();
			tabBar.y = 5;
			tabBar.x = 2;
			tabBar.percentHeight = 100;
			tabBar.width = 295;
			addChild(tabBar);
			
			setView = new AVGSetView();
			tabBar.addChild(setView)				
			
			libView = new AVGLibView();
			tabBar.addChild(libView);
			
			outlineView = new AVGOutlineView();
			tabBar.addChild(outlineView);
			
			sectionView = new AVGSectionView();
			tabBar.addChild(sectionView);
			
			timelineView = new AVGTimelineView();
			tabBar.addChild(timelineView);
			
			tabBar.selectedIndex = 0;
		}
	}
}