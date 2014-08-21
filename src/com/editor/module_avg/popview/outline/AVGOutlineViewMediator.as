package com.editor.module_avg.popview.outline
{
	import com.editor.component.containers.UIVBox;
	import com.editor.mediator.AppMediator;
	import com.editor.module_avg.manager.AVGManager;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	public class AVGOutlineViewMediator extends AppMediator
	{
		public static const NAME:String = "AVGOutlineViewMediator";
		public function AVGOutlineViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():AVGOutlineView
		{
			return viewComponent as AVGOutlineView;
		}
		public function get fileBox():UIVBox
		{
			return mainUI.fileBox;
		}
		
		public function respondToReflashOutlineInavgEvent(noti:Notification):void
		{
			if(AVGManager.currFrame!=null){
				fileBox.dataProvider = AVGManager.currFrame.res_ls.sortOn("id",Array.NUMERIC);
			}else{
				fileBox.dataProvider = null;
			}
		}
		
		
	}
}