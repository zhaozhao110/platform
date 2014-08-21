package com.editor.modules.app
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.air.utils.AIRUtils;
	import com.editor.d3.app.view.App3DMainUIContainer;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.app.GDPSMainUIContainer;
	import com.editor.modules.app.mediator.AppMainPopupwinMediator;
	import com.editor.modules.app.view.main.AppMainPopupContainer;
	import com.editor.modules.app.view.main.AppMainUIContainer;
	import com.editor.modules.command.AppModuleStartupCommand;
	import com.editor.view.popup.AppModulePopupwin;
	import com.editor.view.popup.AppPopupWithNoTitleWin;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.component.controls.SandyButton;
	import com.sandy.manager.StageManager;
	import com.sandy.module.ModulePopupwin;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowDisplayState;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.MouseEvent;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.NativeWindowDisplayStateEvent;
	
	/**
	 * 客户端的主界面
	 */ 
	public class AppMainPopupwinModule extends AppModulePopupwin
	{
		public function AppMainPopupwinModule()
		{
			super()
			if(instance == null) instance = this;
			create_init();
		}
		
		public static var instance:AppMainPopupwinModule;
		public var mainContainer:AppMainUIContainer;
		public var popContainer:AppMainPopupContainer;
		public var main3DContainer:App3DMainUIContainer;
		public var gdpsContainer:GDPSMainUIContainer;
		
		private function create_init():void
		{
			enabledStageReisze = true;
			
			//添加界面
			mainContainer = new AppMainUIContainer();
			addChild(mainContainer);
			
			//3d
			main3DContainer = new App3DMainUIContainer();
			main3DContainer.visible = false;
			addChild(main3DContainer);
			
			//gpds
			gdpsContainer = new GDPSMainUIContainer();
			gdpsContainer.visible = false;
			addChild(gdpsContainer);
			
			popContainer = new AppMainPopupContainer();
			addChild(popContainer);
			
			this.stage.addEventListener(MouseEvent.CLICK , onApplicationClickHandle);
						
			initComplete();
			
			engineEditor.instance.initSystrayMenu(this);
			nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,nwMinimized);
		}
		
		private function nwMinimized(displayStateEvent:NativeWindowDisplayStateEvent):void 
		{		
			sendAppNotification(AppEvent.displayStateChange_event,displayStateEvent.afterDisplayState)
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.resizable 		= true
			opts.minimizable 	= true
			opts.maximizable 	= true
			opts.width 			= 1000
			opts.height 		= 600
			opts.title 			= "engineEditor平台,版本"+AIRUtils.getAPP_version();
			opts.visible		= false
			opts.isMainApplication = true;
			opts.gpu = true
			return opts;
		}
		
		override protected function __init__():void
		{
			popupSign  		= PopupwinSign.AppMainPopupwinModule_sign;
			isModel    		= false;
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppMainPopupwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppMainPopupwinMediator.NAME);
		}
		
		override public function getStartupCommand():Class{
			return AppModuleStartupCommand;
		}
		 
		override public function forceActivate():void
		{
			super.forceActivate();
			if(AppMainModel.getInstance().minAfterLogin){
				minimize();
			}else{
				nativeWindow.visible = true
				nativeWindow.maximize();
				/*nativeWindow.width = 1400;
				nativeWindow.height = 1000*/
			}
		}
		
		override protected function nativeWinResizeHandle(w:Number=NaN,h:Number=NaN):void
		{
			w = w-9;
			super.nativeWinResizeHandle(w,h);
		}
		
		protected function onApplicationClickHandle(e:MouseEvent):void
		{
			//trace("application click at:" + e.target,e.target.width,e.target.height)
		}
		
	}
}