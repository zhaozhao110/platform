package com.editor.moudule_drama.view.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.moudule_drama.view.right.layout.DramaLayoutContainer;
	import com.editor.moudule_drama.view.right.timePanel.DrameTimelinePanel;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.events.Event;

	public class DramaRightContainer extends UICanvas
	{
		public function DramaRightContainer()
		{
			super();
			create_init();
		}
		
		/**总容器**/
		public var vbox:UIVBox;
		/**时间轴容器**/
		public var timelinePanel:DrameTimelinePanel;
		/**布局容器**/
		public var layoutContainer:DramaLayoutContainer;
		private function create_init():void
		{
			enabledPercentSize = true;
			
			/**总容器**/
			vbox = new UIVBox();
			vbox.verticalGap = 6;
			vbox.enabledPercentSize = true;
			vbox.percentHeight = 100;
			addChild(vbox);
			
			/**时间轴容器**/
			timelinePanel = new DrameTimelinePanel();
			timelinePanel.height = 139;
			vbox.addChild(timelinePanel);
			
			/**布局容器**/
			layoutContainer = new DramaLayoutContainer();
			vbox.addChild(layoutContainer);
			
		}
		
		
		
	}
}