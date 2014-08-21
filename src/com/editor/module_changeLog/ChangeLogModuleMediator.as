package com.editor.module_changeLog
{
	import com.editor.command.action.DownloadChangeLogEventCommand;
	import com.editor.mediator.AppMediator;
	import com.editor.module_changeLog.manager.ChangeLogSqlConn;
	import com.editor.module_changeLog.mediator.ChangeLogLeftViewMediator;
	import com.editor.module_changeLog.mediator.ChangeLogRightViewMediator;
	import com.editor.module_changeLog.view.ChangeLogLeftView;
	import com.editor.module_changeLog.view.ChangeLogRightView;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class ChangeLogModuleMediator extends AppMediator
	{
		public static const NAME:String = "ChangeLogModuleMediator";
		public function ChangeLogModuleMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		public function get win():ChangeLogModule
		{
			return viewComponent as ChangeLogModule;
		}
		public function get leftView():ChangeLogLeftView
		{
			return win.leftView;
		}
		public function get rightView():ChangeLogRightView
		{
			return win.rightView;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			if(DownloadChangeLogEventCommand.changelog_complete > 0){
				showMessage("changeLog数据库还没下载完成，请等待或者可以进行其他操作");
				return ;
			}
			respondToDownloadChangeLogCompleteEvent();
		}
		
		public function respondToDownloadChangeLogCompleteEvent(noti:Notification=null):void
		{
			if(retrieveMediator(ChangeLogLeftViewMediator.NAME)) return ;
			if(ChangeLogSqlConn.getInstance().connected){
				respondToChangeLogConnectEvent()
			}else{
				ChangeLogSqlConn.getInstance().connSql();
			}
		}
		
		public function respondToChangeLogConnectEvent(noti:Notification=null):void
		{
			if(retrieveMediator(ChangeLogLeftViewMediator.NAME)) return ;
			registerMediator(new ChangeLogLeftViewMediator(leftView));
			registerMediator(new ChangeLogRightViewMediator(rightView));
		}
		
	}
}