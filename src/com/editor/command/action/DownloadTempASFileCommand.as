package com.editor.command.action
{
	import com.air.io.DownloadFile;
	import com.editor.command.AppSimpleCommand;
	import com.editor.manager.AppTimerManager;
	import com.editor.services.Services;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.interfaces.INotification;
	
	import flash.filesystem.File;

	public class DownloadTempASFileCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			check()
		}
		
		private var temp_new_v:Number;
		
		private function check():void
		{
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			temp_new_v = Number(AppTimerManager.version_xml.tempVer);
			var curr_v:Number = Number(iSharedObject.find("","tempVer"));
			
			if(curr_v == 0){
				downDB3();
				iSharedObject.put("","tempVer",temp_new_v);
			}else{
				if(curr_v<temp_new_v){
					downDB3();
					return ;
				}
			}
			var fl:File = new File(Services.temp_local_url);
			if(!fl.exists){
				downDB3();
			}
		}
		
		private var download3:DownloadFile;
		private function downDB3():void
		{
			iLogger.info("download tempASFile:"+Services.temp_local_url);
			if(download3 == null){
				download3 = new DownloadFile();
				download3.addEventListener(ASEvent.PROGRESS,onDownDB_progress3);
				download3.addEventListener(ASEvent.COMPLETE,onDownDB_complete3)
			}
			download3.download(Services.temp_url,Services.temp_local_url)
		}
		
		private function onDownDB_progress3(e:ASEvent):void
		{
			//sendAppNotification(AppEvent.add_preLoader_msg_event,"更新api数据库....."+Math.ceil(e.data*100)+"%");
		}
		
		private function onDownDB_complete3(e:ASEvent):void
		{
			iSharedObject.put("","tempVer",temp_new_v);
			
		}
	}
}