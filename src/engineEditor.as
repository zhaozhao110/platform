package 
{
	import away3d.Away3D;
	
	import com.air.popupwin.data.AIRPopOptions;
	import com.air.render2D.SandyAirApplication;
	import com.editor.command.AppStartUpCommand;
	import com.editor.manager.DataManager;
	import com.editor.model.UISandyEngineConfig;
	import com.editor.module_gdps.login.GDPSLoginPopwin;
	import com.editor.services.Services;
	import com.editor.tool.ScreenShot;
	import com.editor.view.preloader.AppPreLoaderContainer;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.asComponent.controls.ASToolTip;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.core.ISandyEngineConfig;
	import com.sandy.utils.FindPingyinUtils;  
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	import com.sandy.utils.URLUtils;   
	
	import flash.display.NativeWindow;  
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File; 
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	                
	public class engineEditor extends SandyAirApplication
	{
		public function engineEditor()
		{  
			DataManager.init();
			if(instance == null) instance = this;
			super();   
		}
		   
		public static var instance:engineEditor;
		public var isRelease:Boolean = false;
		public static var userThread:Boolean = true;
		 
		override protected function createConfig():ISandyEngineConfig{
			return new UISandyEngineConfig(); 
		}
		
		override public function getStartupCommand():Class{
			return AppStartUpCommand;
		}
		
		public var preLoader:AppPreLoaderContainer;
		public static var gdpsLogin:GDPSLoginPopwin;
		 
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.systemChrome = NativeWindowSystemChrome.NONE;
			opts.transparent = true;
			opts.type = NativeWindowType.UTILITY;
			opts.width 	= 657;
			opts.height = 199; 
			return opts;
		}
		      
		override protected function appCreateComplete():void
		{
			super.appCreateComplete();
						
			ASToolTip.MAX_WIDTH = 300;
			Services.init();
			
			preLoader = new AppPreLoaderContainer(); 
			addChild(preLoader);
			
			gdpsLogin = new GDPSLoginPopwin();
			addChild(gdpsLogin);
			
			initComplete();
			toCenter();     
			DataManager.pass = new txtCls();
			trace("当前时间:" +  TimerUtils.getCurrentTime_str(),Capabilities.os,File.userDirectory.nativePath);
		}
		
		override protected function onApplicationClickHandle(e:MouseEvent):void
		{
			super.onApplicationClickHandle(e);
		}
		
		override protected function get systrayMenuList():Array
		{
			return [{label:"截屏",fun:systrayBackFun},
					{label:"颜色",fun:pickerColor}]
		}
		
		private function pickerColor():void
		{
			
		}
				
		override protected function get systrayMenuDock():String
		{
			return "assets/icon/v16.png";
		}
		
		private var shot:ScreenShot;
		public function systrayBackFun(e:Event=null):void
		{
			if(shot == null){
				shot = new ScreenShot();
				shot.addEventListener(ScreenShot.SHOTCOMPLETE,shotComplete);
			}
			shot.shot();
		}
		     
		private function shotComplete(e:ASEvent):void{};
				
		override protected function getBackgroundThreadSwf():Array
		{
			return ["/assets/editor_thread.swf",
				"/assets/editor_thread2.swf",
				"/assets/editor_thread3.swf"];
		}
				         
		[Embed(source="/assets/p.txt", mimeType="application/octet-stream")]  
		public var txtCls:Class; 
		
		private function get_AppConfigProxy():AppGlobalConfig
		{
			return AppGlobalConfig.instance;
		}
		
		override public function checkThread():void
		{
			CONFIG::highSdk{
				super.checkThread();
			}
		}
		
	}
}