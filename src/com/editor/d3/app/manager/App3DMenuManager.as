package com.editor.d3.app.manager
{
	import com.air.io.FileUtils;
	import com.air.io.SelectFile;
	import com.editor.d3.app.scene.grid.vo.CameraMode;
	import com.editor.d3.app.view.ui.bottom.App3DBottomContainerMediator;
	import com.editor.d3.app.view.ui.left.App3DLeftContainerMediator;
	import com.editor.d3.app.view.ui.right.App3DRightContainerMediator;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.event.App3DEvent;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.manager.SharedObjectManager;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.URLUtils;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.filesystem.File;

	public class App3DMenuManager extends SandyManagerBase
	{
		private static var instance:App3DMenuManager ;
		public static function getInstance():App3DMenuManager{
			if(instance == null){
				instance =  new App3DMenuManager();
			}
			return instance;
		}
		
		public function topMenuBarClick(xml:XML):void
		{
			var d:int = int(xml.@data);
			if(d == 10006){
				get_App3DLeftContainerMediator().leftContainer.visible = !get_App3DLeftContainerMediator().leftContainer.visible;				
			}else if(d == 10007){
				get_App3DRightContainerMediator().rightContainer.visible = !get_App3DRightContainerMediator().rightContainer.visible;				
			}else if(d == 10008){
				get_App3DBottomContainerMediator().bottomContainer.visible = !get_App3DBottomContainerMediator().bottomContainer.visible;				
			}else if(d == 10001){
				var open:OpenPopwinData = new OpenPopwinData();
				open.popupwinSign = PopupwinSign.App3DCreateProjectPopupwin_sign;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(d == 10004){
				open = new OpenPopwinData();
				open.popupwinSign = PopupwinSign.AppRecentOpenProjectPopwin_sign;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(d == 10002){
				SelectFile.selectByFilter("d3Pro","3dpro",selectProject);
			}else if(d == 10009){
				D3ProjectCache.getInstance().openConfigByIE();
			}else if(d == 10005){
				sendAppNotification(D3Event.change3DProject_event,null);
				SharedObjectManager.getInstance().put("","camera.position",null);
			}else if(d == 10010){
				var _nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				_nativeProcessStartupInfo.executable = new File(FileUtils.getUserLocalAppData().nativePath+File.separator+"engineEditor"+File.separator+"ATFViewer.exe");
				var _process:NativeProcess = new NativeProcess();
				_process.start(_nativeProcessStartupInfo);
			}else if(d == 10012){
				URLUtils.openLink(get_AppConfigProxy().config_hash.find("starlingParticle"))
			}else if(d == 10013){
				open = new OpenPopwinData();
				open.popupwinSign = PopupwinSign.D3Preview3DSpopwin_sign;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}else if(d == 10014){
				//D3SceneManager.getInstance().currScene.cameraMM.mode = CameraMode.TARGET;
			}else if(d == 10015){
				//D3SceneManager.getInstance().currScene.cameraMM.mode = CameraMode.FREE;
			}
			
			if(d == 10011){
				var popId:int = int(xml.@popId);
				open = new OpenPopwinData();
				open.data = xml;
				open.addData = AppGlobalConfig.instance.popInfo_vo.getData(popId).webId;
				open.popupwinSign = AppGlobalConfig.instance.popInfo_vo.getData(popId).info;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
				return ;
			}
		}
		
		private function get_AppConfigProxy():AppGlobalConfig
		{
			return AppGlobalConfig.instance;
		}
		
		private function selectProject(e:Event):void
		{
			var f:File = e.target as File;
			sendAppNotification(D3Event.change3DProject_event,f);
		}
		
		private function get_App3DRightContainerMediator():App3DRightContainerMediator
		{
			return iManager.retrieveMediator(App3DRightContainerMediator.NAME) as App3DRightContainerMediator;
		}
		
		private function get_App3DLeftContainerMediator():App3DLeftContainerMediator
		{
			return iManager.retrieveMediator(App3DLeftContainerMediator.NAME) as App3DLeftContainerMediator;
		}
		
		private function get_App3DBottomContainerMediator():App3DBottomContainerMediator
		{
			return iManager.retrieveMediator(App3DBottomContainerMediator.NAME) as App3DBottomContainerMediator;
		}
	}
}