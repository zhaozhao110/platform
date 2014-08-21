package com.editor.moudule_drama.view.right.timePanel
{
	import com.editor.component.containers.UICanvas;
	import com.editor.moudule_drama.timeline.TimelineContainer;

	public class DrameTimelinePanel extends UICanvas
	{
		public function DrameTimelinePanel()
		{
			super();
			percentWidth = 100;
			create_init();
		}
		
		public var timeline:TimelineContainer;
		private function create_init():void
		{			
			timeline = new TimelineContainer();
			//timeline.background_red = true
			timeline.x = 5; timeline.y = 2;
			timeline.enabledPercentSize = true
			addChild(timeline);
			
		}
		
	}
}