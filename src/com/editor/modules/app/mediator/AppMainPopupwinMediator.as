package com.editor.modules.app.mediator
{
	import com.air.render2D.SandyAirApplication;
	import com.air.utils.AIRUtils;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.app.view.App3DMainUIContainer;
	import com.editor.event.App3DEvent;
	import com.editor.event.AppEvent;
	import com.editor.manager.AppTimerManager;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.manager.ViewManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.module_gdps.app.GDPSMainUIContainer;
	import com.editor.module_gdps.app.GDPSMainUIContainerMediator;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.modules.app.AppMainPopupwinModule;
	import com.editor.modules.app.view.main.AppMainPopupContainer;
	import com.editor.modules.app.view.main.AppMainPopupContainerMediator;
	import com.editor.modules.app.view.main.AppMainUIContainer;
	import com.editor.modules.app.view.main.AppMainUIContainerMediator;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.view.popup.AppNotDestroyPopupwinMediator;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.effect.tween.ASTween;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.manager.data.KeyStringCodeConst;
	import com.sandy.puremvc.interfaces.INotification;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.TimerUtils;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.utils.setTimeout;

	/**
	 * 主界面
	 */ 
	public class AppMainPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = 'AppMainPopupwinMediator'
		public function AppMainPopupwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get main():AppMainPopupwinModule
		{
			return viewComponent as AppMainPopupwinModule;
		}
		public function get popContainer():AppMainPopupContainer
		{
			return main.popContainer;
		}
		public function get mainUIContainer():AppMainUIContainer
		{
			return main.mainContainer;
		}
		public function get main3DContainer():App3DMainUIContainer
		{
			return main.main3DContainer;
		}
		public function get gdpsContainer():GDPSMainUIContainer
		{
			return main.gdpsContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			main.popupwinMangerMediatorName = AppMainPopupContainerMediator.NAME;
			registerMediator(new AppMainUIContainerMediator(mainUIContainer));
			registerMediator(new AppMainPopupContainerMediator(popContainer));
			
			applicationRenderComplete();
			iKeybroad.addKeyDownProxyFun(this);
			
			main.getNativeWindow().addEventListener(Event.CLOSING, _windowOnClose,false,10000000,true);  
		}
		
		public function init3DMainUI():void
		{
			if(main3DContainer.topBarContainer != null) return ;
			main3DContainer.create_init();
			registerMediator(new App3DMainUIContainerMediator(main3DContainer));
		}
		
		public function initGDPS():void
		{
			if(gdpsContainer.topCell != null) return ;
			gdpsContainer.create_init();
			registerMediator(new GDPSMainUIContainerMediator(gdpsContainer));
		}
		
		private function _windowOnClose(e:Event):void
		{
			e.preventDefault();
			
			if(D3SceneManager.getInstance().currScene){
				D3SceneManager.getInstance().currScene.quit();
			}
			if(ViewManager.getInstance().beforeCloseApp(main)){
				main.closeWindow();
			}
		}
		
		public function respondToChangeTo3DSceneEvent(noti:Notification):void
		{
			if(AppMainModel.getInstance().enterGDPS) return ;
			init3DMainUI()
			mainUIContainer.visible = false;
			main3DContainer.visible = true
			AppMainModel.getInstance().enter3DScene = false;
			//main3DContainer.x = main.width+50;
			//ASTween.to(main3DContainer,1,{x:0,onComplete:onComplete1});
		}
		
		private function onComplete1():void
		{
			mainUIContainer.x = main.width + 50;
			mainUIContainer.visible = false;
		}
		
		public function respondToChangeTo2DSceneEvent(noti:Notification):void
		{
			if(AppMainModel.getInstance().enterGDPS) return ;
			mainUIContainer.visible = true;
			main3DContainer.visible = false
		}
		
		private function onComplete2():void
		{
			main3DContainer.x = main.width + 50;
			main3DContainer.visible = false;
		}
		
		public function respondToShowMainPopModuleEvent(noti:Notification=null):void
		{
			main.forceActivate();
			setTimeout(function():void{AppTimerManager.getInstance().checkOpenChangeLogWin();},2000);
			
			if(AppMainModel.getInstance().enterGDPS){
				mainUIContainer.visible = false;
				main3DContainer.visible = false;
				gdpsContainer.visible = true
				AppMainModel.getInstance().enterGDPS = false
			}else{
				gdpsContainer.visible = false;
				mainUIContainer.visible = true
				main3DContainer.visible = false
			}
			
			if(AppMainModel.getInstance().enter3DScene){
				sendAppNotification(App3DEvent.changeTo3DScene_event);
			}
		}
		
		override public function keyDown_f(e:KeyboardEvent):void
		{
			if(e.ctrlKey){
				if(e.keyCode == KeyStringCodeConst.L){
					StackManager.getInstance().openCurrLogCont();
				}
			}
		}
		
		public function respondToLoginEvent(noti:Notification=null):void
		{
			main.title = "engineEditor平台,版本"+AIRUtils.getAPP_version()+
				"/login："+AppMainModel.getInstance().user.name + 
				"/loginTime："+TimerUtils.getCurrentTime_str() 
			
			if(AppMainModel.getInstance().selectProject != null){
				main.title += "/project： " + AppMainModel.getInstance().selectProject.name;
			}
		}
		
		public function respondToSendGotoGameEditorEvent(noti:Notification):void
		{
			if(AppMainModel.getInstance().selectProject != null){
				respondToShowMainPopModuleEvent();
			}else{
				main.getNativeWindow().visible = false;
			}
		}
		
		public function respondToSendGotoGDPSEvent(noti:Notification):void
		{
			if(GDPSDataManager.getInstance().getUserInfo != null){
				respondToEnterGDPSMainUIEvent()
			}else{
				main.getNativeWindow().visible = false;
			}
		}
		
		public function respondToShowGDPSProjectsEvent(noti:Notification):void
		{
			main.getNativeWindow().visible = false;
		}
		
		public function respondToEnterGDPSMainUIEvent(noti:Notification=null):void
		{
			initGDPS();
			main.forceActivate();
			mainUIContainer.visible = false;
			main3DContainer.visible = false;
			gdpsContainer.visible = true;
			AppMainModel.getInstance().enterGDPS = false;
		}
		
	}
}