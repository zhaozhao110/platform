package com.editor.command.action
{
	import com.air.io.DownloadFile;
	import com.air.io.FileUtils;
	import com.editor.command.AppSimpleCommand;
	import com.editor.manager.AppTimerManager;
	import com.editor.services.Services;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.math.HashMap;
	import com.sandy.puremvc.interfaces.INotification;
	
	import flash.filesystem.File;

	public class DownToolFileCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			check()
		}
		
		private var tool_ls:HashMap = new HashMap();
		
		public static function get saveFile():File
		{
			return new File(FileUtils.getUserLocalAppData().nativePath+File.separator+"engineEditor");
		}
		
		private function check():void
		{
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			if(AppTimerManager.version_xml == null) return ;
			
			var x:XML = XML(AppTimerManager.version_xml.tool);
			for each(var xml:XML in x.i)
			{
				tool_ls.put(xml.toString(),xml.@v);
			}
			
			var key:String;
			for(key in tool_ls.getContent()) 
			{
				var db_new_v:int = int(tool_ls.find(key));
				var curr_v:Number = Number(iSharedObject.find("",key));
				if(curr_v == 0){
					iSharedObject.put("",key,db_new_v);
				}else{
					if(curr_v<db_new_v){
						downDB2(key);
						continue;
					}
				}
				var fl:File = new File(saveFile.nativePath+File.separator+key);
				if(!fl.exists){
					downDB2(key);
				}
			}			
		}
		
		private function downDB2(key:String):void
		{
			iLogger.info("download tool:"+key);
			var download:DownloadFile = new DownloadFile();
			download.data2 = key;
			download.addEventListener(ASEvent.PROGRESS,onDownDB_progress2);
			download.addEventListener(ASEvent.COMPLETE,onDownDB_complete2)
			download.download(Services.server_res_url+"/tool/"+key,saveFile.nativePath+File.separator+key)
		}
		
		private function onDownDB_progress2(e:ASEvent):void
		{
			//sendAppNotification(AppEvent.add_preLoader_msg_event,"更新api数据库....."+Math.ceil(e.data*100)+"%");
		}
		
		private function onDownDB_complete2(e:ASEvent):void
		{
			var download:DownloadFile = e.target as DownloadFile
			iSharedObject.put("",download.data2,tool_ls.find(download.data2));
		}
		
	}
}