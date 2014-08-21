package com.editor.command.action
{
	import com.air.io.DownloadFile;
	import com.editor.command.AppSimpleCommand;
	import com.editor.event.AppEvent;
	import com.editor.manager.AppTimerManager;
	import com.editor.services.Services;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.interfaces.INotification;
	
	import flash.filesystem.File;

	public class DownloadChangeLogEventCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			if(changelog_complete > 0) return ;
			check()
		}
		
		private var temp_new_v:Number;
		public static var changelog_complete:int
		
		private function check():void
		{
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			temp_new_v = Number(AppTimerManager.version_xml.changeLog);
			var curr_v:Number = Number(iSharedObject.find("","lastChangeLogTime"));
			if(curr_v == 0){
				downDB3();
				iSharedObject.put("","lastChangeLogTime",temp_new_v);
			}else{
				if(curr_v<temp_new_v){
					downDB3();
					return ;
				}
			}
			var fl:File = new File(Services.changeLog_local_url);
			if(!fl.exists){
				downDB3();
			}
		}
		
		private var download3:DownloadFile;
		private function downDB3():void
		{
			iLogger.info("download changeLog:"+Services.changeLog_local_url);
			changelog_complete = 1;
			if(download3 == null){
				download3 = new DownloadFile();
				download3.addEventListener(ASEvent.PROGRESS,onDownDB_progress3);
				download3.addEventListener(ASEvent.COMPLETE,onDownDB_complete3)
			}
			download3.download(Services.changeLog_url,Services.changeLog_local_url)
		}
		
		private function onDownDB_progress3(e:ASEvent):void
		{
			//sendAppNotification(AppEvent.add_preLoader_msg_event,"更新api数据库....."+Math.ceil(e.data*100)+"%");
		}
		
		private function onDownDB_complete3(e:ASEvent):void
		{
			changelog_complete = 0
			iSharedObject.put("","lastChangeLogTime",temp_new_v);
			//sendAppNotification(AppEvent.download_changeLog_complete_event);
			AppTimerManager.getInstance().openChangeLogWin();
		}
	}
}