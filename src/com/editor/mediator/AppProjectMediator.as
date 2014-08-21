package com.editor.mediator
{
	import com.air.io.HashMapFile;
	import com.editor.event.AppEvent;
	import com.editor.manager.AppTimerManager;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.login.GDPSLoginPopwin;
	import com.editor.module_gdps.login.GDPSLoginPopwinMediator;
	import com.editor.view.preloader.AppPreLoaderContainer;
	import com.editor.view.preloader.AppPreLoaderContainerMediator;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.global.AppMenuConfig;
	import com.editor.vo.global.AppStorageConfFile;
	import com.sandy.asComponent.core.ASLoaderBase;
	import com.sandy.error.SandyError;
	import com.sandy.fabrication.IFabricationMediator;
	import com.sandy.manager.data.KeyStringCodeConst;
	import com.sandy.manager.timer.ISandyTimer;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	
	public class AppProjectMediator extends UIApplicationMediator implements IFabricationMediator
	{
		public static const NAME:String = 'AppProjectMediator'
		public function AppProjectMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get app():engineEditor
		{
			return viewComponent as engineEditor;
		}
		public function get preLoader():AppPreLoaderContainer
		{
			return app.preLoader;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new AppPreLoaderContainerMediator(preLoader));
			registerMediator(new GDPSLoginPopwinMediator(engineEditor.gdpsLogin));
			//create sharedObject
			iSharedObject.createAppCookie("engineEditor");
			//applicationStorageDirectory
			AppMainModel.getInstance().applicationStorageFile = new AppStorageConfFile();
			 
			//if(!engineEditor.isRelease){
				//ASLoaderBase.requestURLProxy = loaderURLProxy;
			//}
			
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN , onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == KeyStringCodeConst.F9){
				
				var open:OpenPopwinData = new OpenPopwinData();
				open.popupwinSign = PopupwinSign.DebugPopwin_sign
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				open.openByAirData = opt;
				iManager.iPopupwin.applicationPopupwinManager.openPopupwinInternal(open);
			}
		}
		
		private function loaderURLProxy(url:String):String
		{
			return StringTWLUtil.replace(url,"192.168.20.156","localhost");
		}
		
		  
		private var appCreateCompleteEvent_b:Boolean;
		
		public function respondToAppCreateCompleteEvent(noti:Notification):void
		{
			//preLoader.visible = false;
			if(appCreateCompleteEvent_b){
				SandyError.error("have aready init");
			}
			appCreateCompleteEvent_b = true;
			
			openMainPop();
		}
		
		private function openMainPop():void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.AppMainPopupwinModule_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		public function respondToLoginEvent(noti:Notification):void
		{
			laterShow();
		}
		
		private function laterShow():void
		{
			preLoader.visible = false;
			
			sendAppNotification(AppEvent.showMainPopModule_event);
			sendAppNotification(AppEvent.add_preLoader_msg_event,"显示主界面"+"/"+getTimer());
		}
		
		public function respondToLoadIoErrorEvent(noti:Notification):void
		{
			iLogger.error("load error," + noti.getBody());
		}
				
		
		
	}
}