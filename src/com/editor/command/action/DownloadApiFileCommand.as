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

	public class DownloadApiFileCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			check()
		}
		
		private var api_new_v:Number;
		public static var api_complete:int
		
		private function check():void
		{
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			api_new_v = Number(AppTimerManager.version_xml.apiVer);
			var curr_v:Number = Number(iSharedObject.find("","apiVer"));
			if(curr_v == 0){
				iSharedObject.put("","apiVer",api_new_v);
			}else{
				if(curr_v<api_new_v){
					downDB2();
					return ;
				}
			}
			var fl:File = new File(Services.api_local_url);
			if(!fl.exists){
				downDB2();
			}
		}
		
		private var download2:DownloadFile;
		private function downDB2():void
		{
			iLogger.info("download api:"+Services.api_local_url);
			api_complete = 1;
			if(download2 == null){
				download2 = new DownloadFile();
				download2.addEventListener(ASEvent.PROGRESS,onDownDB_progress2);
				download2.addEventListener(ASEvent.COMPLETE,onDownDB_complete2)
			}
			download2.download(Services.api_url,Services.api_local_url)
		}
		
		private function onDownDB_progress2(e:ASEvent):void
		{
			//sendAppNotification(AppEvent.add_preLoader_msg_event,"更新api数据库....."+Math.ceil(e.data*100)+"%");
		}
		
		private function onDownDB_complete2(e:ASEvent):void
		{
			iSharedObject.put("","apiVer",api_new_v);
			api_complete = 0;
			
			sendAppNotification(AppEvent.download_apifileComplete_event);
		}
		
	}
}