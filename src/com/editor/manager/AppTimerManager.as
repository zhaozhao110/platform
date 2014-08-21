package com.editor.manager
{
	import com.air.utils.AIRUtils;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_server.pop.systemRightBotTip.SystemRightTipVO;
	import com.editor.services.Services;
	import com.sandy.component.controls.SandyLoader;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.manager.timer.ISandyTimer;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	import com.sandy.version.VersionUtils;
	
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	public class AppTimerManager extends SandyManagerBase
	{
		private static var instance:AppTimerManager ;
		public static function getInstance():AppTimerManager{
			if(instance == null){
				instance =  new AppTimerManager();
				instance.init_inject();
			}
			return instance;
		}
		
		private var isStart:Boolean;
		
		public function start():void
		{
			if(isStart) return ;
			
			//检测是否有新版本
			var timer:Timer = new Timer(1000*60*10);
			timer.addEventListener(TimerEvent.TIMER , onTimer1);
			timer.start();
		}
		
		private function onTimer1(e:TimerEvent):void
		{
			var loader:SandyLoader = new SandyLoader();
			loader.complete_fun = loadComplete;
			loader.load(Services.update_xml+"?"+Math.random());
		}
		
		public static var version_xml:XML;
		
		private function loadComplete(c:*):void
		{
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			var x:XML = XML(c);
			version_xml = x;
			
			var new_v:String = String(x.versionNumber)
			var curr_v:String = AIRUtils.getAPP_version();
			if(VersionUtils.checkVersion(curr_v,new_v)){
				/*closePoupwin(PopupwinSign.AppUpdateWinPopwin_sign);
				var open:OpenPopwinData = new OpenPopwinData();
				open.data = AppTimerManager.version_xml;
				open.popupwinSign = PopupwinSign.AppUpdateWinPopwin_sign;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);*/
			}
			
			//检测是否有更新，有更新的就马上下载
			sendAppNotification(AppEvent.download_apifile_event);
			sendAppNotification(AppEvent.download_tempAS_event);
			//sendAppNotification(AppEvent.download_changeLog_event);
			sendAppNotification(AppEvent.download_dbFile_event);
			
			checkOpenChangeLogWin();
			
			iLogger.info("check new version: " + TimerUtils.getCurrentTime_str());
		}
		
		public function openChangeLogWin():void
		{
			closePoupwin(PopupwinSign.ChangeLogPopwin_sign);
			var open:OpenPopwinData = new OpenPopwinData();
			open.data = null			
			open.popupwinSign = PopupwinSign.ChangeLogPopwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		public function checkOpenChangeLogWin():void
		{ 
			/*openChangeLogWin();
			return ;*/
			if(AppMainModel.getInstance().user == null) return ;
			if(AppMainModel.getInstance().user.checkIsSystem()) return ;
			if(!AppMainModel.getInstance().user.checkInPower([2])) return ;
			
			var fl:File = new File(Services.changeLog_local_url);
			if(!fl.exists){
				sendAppNotification(AppEvent.download_changeLog_event);
				return;
			}
			
			if(iManager == null) return ;
			if(iManager.iSharedObject == null) return ;
			if(version_xml == null) return ;
			var time:String = iManager.iSharedObject.find("","lastChangeLogTime")
			if(StringTWLUtil.isWhitespace(time)){
				sendAppNotification(AppEvent.download_changeLog_event);
				return ;
			}
			
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			var new_v:String = String(version_xml.changeLog)
			if(Number(new_v)>Number(time)){
				sendAppNotification(AppEvent.download_changeLog_event);
				return;
			}
			
			
		}
		
	}
}