package com.editor.module_avg.mediator.right
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.preview.AVGPreview;
	import com.editor.module_avg.view.right.AVGModRightPreview;
	import com.editor.module_avg.view.right.AVGModRightTopBar;
	import com.editor.module_avg.view.right.AVGModuleRightContainer;
	import com.editor.module_avg.vo.AVGResData;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class AVGModuleRightContainerMediator extends AppMediator
	{
		public static const NAME:String = "AVGModuleRightContainerMediator";
		public function AVGModuleRightContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():AVGModuleRightContainer
		{
			return viewComponent as AVGModuleRightContainer;
		}
		public function get preview():AVGPreview
		{
			return mainUI.preView;
		}
		public function get rightPreView():AVGModRightPreview
		{
			return mainUI.rightPreView;
		}
		public function get topBar():AVGModRightTopBar
		{
			return mainUI.topBar;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
				
		}
		
		public function respondToPreResInavgEvent(noti:Notification):void
		{
			rightPreView.load(noti.getBody() as AVGResData);
		}
		
		public function respondToSelectPlotInavgEvent(noti:Notification):void
		{
			mainUI.mouseChildren = true;
			mainUI.mouseEnabled = true;
		}
		
		public function respondToSelectFrameInavgEvent(noti:Notification):void
		{
			topBar.setFrame(AVGManager.currFrame);
			preview.setFrame(AVGManager.currFrame)
		}
		
		public function respondToReflashAttriInavgEvent(noti:Notification):void
		{
			if(AVGManager.currAttriView!=null){
				AVGManager.currAttriView.reflashAttri(noti.getBody() as AVGResData)
			}
		}
	}
	
}