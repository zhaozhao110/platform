package com.editor.model
{
	
	import com.editor.event.AppEvent;
	import com.editor.mediator.AppProjectMediator;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.manager.GDPSPopwinClass;
	import com.editor.serverCode.AppServerCode;
	import com.sandy.core.IInjectClassProcessor;
	import com.sandy.core.SandyEngineConfig;
	import com.sandy.locale.Locale;
	
	import theme.main;

	public class UISandyEngineConfig extends SandyEngineConfig
	{
		public function UISandyEngineConfig()
		{
			super();
		}
		
		override protected function initializeSandyEngine():void
		{
			super.initializeSandyEngine();
			
			appFrame = 30
			projectName = "engineEditor";
			defaultLocale = Locale.SimplifiedChinese;
			
			engineLoggerEnabled = true;
			loggerEnabled = true;
			gc_time = 0;
			loadLogEnabled = true;
			socketLogEnabled = true
			popupLogEnabled = true
			enabledProfiler = true
			
			enabled_saveLocal = false
		}
		
		override public function get defaultTheme():String
		{
			return "classic"
		}
		
		override public function getAppBindingMediator():Class
		{
			return AppProjectMediator;
		}
		
		override protected function importCSS():Array
		{
			return [main];
		}
		
		override protected function serverInterfaceClass():Array
		{
			return [ServerInterfaceConst];
		}
		
		override protected function createServerCodeParser():Array
		{
			return [AppServerCode];
		}
		
		override public function get_InjectClassProcessor():IInjectClassProcessor
		{
			return new AppInjectClassProcessor();
		}
		
		override public function getPopupwinSign():Array
		{
			return [PopupwinSign,GDPSPopupwinSign];
		}
		
		override public function getPopupwinClass():Array
		{
			return [PopwinClass,GDPSPopwinClass];
		}
		
		override public function getCustomEvent():Array
		{
			return [AppEvent];
		}
		/*
		override public function get skinSourceURL():String
		{
			return "http://localhost:9001/"
		}
		*/
		/*override public function importCSSLibs():Array
		{
			return ["/theme/swf/sh.swf"];
		}*/
		
		
	}
}