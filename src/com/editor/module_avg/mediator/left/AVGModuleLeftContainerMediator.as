package com.editor.module_avg.mediator.left
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.popview.lib.AVGLibView;
	import com.editor.module_avg.popview.lib.AVGLibViewMediator;
	import com.editor.module_avg.popview.outline.AVGOutlineView;
	import com.editor.module_avg.popview.outline.AVGOutlineViewMediator;
	import com.editor.module_avg.popview.section.AVGSectionView;
	import com.editor.module_avg.popview.section.AVGSectionViewMediator;
	import com.editor.module_avg.popview.timeline.AVGTimelineView;
	import com.editor.module_avg.popview.timeline.AVGTimelineViewMediator;
	import com.editor.module_avg.view.left.AVGModuleLeftContainer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class AVGModuleLeftContainerMediator extends AppMediator
	{
		public static const NAME:String = "AVGModuleLeftContainerMediator";
		public function AVGModuleLeftContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():AVGModuleLeftContainer
		{
			return viewComponent as AVGModuleLeftContainer;
		}
		public function get libView():AVGLibView
		{
			return mainUI.libView;
		}
		public function get outlineView():AVGOutlineView
		{
			return mainUI.outlineView;
		}
		public function get sectionView():AVGSectionView
		{
			return mainUI.sectionView;
		}
		public function get timelineView():AVGTimelineView
		{
			return mainUI.timelineView;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new AVGLibViewMediator(libView));
			registerMediator(new AVGOutlineViewMediator(outlineView));
			registerMediator(new AVGSectionViewMediator(sectionView));
			registerMediator(new AVGTimelineViewMediator(timelineView));
			
			mainUI.tabBar.addEventListener(ASEvent.CHANGE,onTabChange);
		}
		
		private function onTabChange(e:ASEvent):void
		{
			if(AVGManager.currAttriView!=null)AVGManager.currAttriView.visible = false;
		}
		
		public function respondToSelectPlotInavgEvent(noti:Notification):void
		{
			mainUI.mouseChildren = true;
			mainUI.mouseEnabled = true;
		}
		
	}
	
}