package com.editor.moudule_drama.mediator.right
{
	import com.editor.component.containers.UIVBox;
	import com.editor.mediator.AppMediator;
	import com.editor.moudule_drama.manager.DramaDataManager;
	import com.editor.moudule_drama.mediator.right.layout.DramaLayoutContainerMediator;
	import com.editor.moudule_drama.mediator.right.timePanel.DramaTimelinePanelMediator;
	import com.editor.moudule_drama.view.right.DramaRightContainer;
	import com.editor.moudule_drama.view.right.layout.DramaLayoutContainer;
	import com.editor.moudule_drama.view.right.timePanel.DrameTimelinePanel;

	public class DramaRightContainerMediator extends AppMediator
	{	
		public static const NAME:String = "DramaRightContainerMediator";
		
		public function DramaRightContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}		
		public function get vbox():UIVBox
		{
			return mainUI.vbox;
		}
		public function get mainUI():DramaRightContainer
		{
			return viewComponent as DramaRightContainer;
		}
		public function get timelinePanel():DrameTimelinePanel
		{
			return mainUI.timelinePanel;
		}
		/**布局容器**/
		public function get layoutContainer():DramaLayoutContainer
		{
			return mainUI.layoutContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();			
			registerMediator(new DramaTimelinePanelMediator(timelinePanel));
			registerMediator(new DramaLayoutContainerMediator(layoutContainer));
			
		}
		
		
	}
			
}