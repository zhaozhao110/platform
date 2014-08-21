package com.editor.modules.app.view.main
{
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.manager.ViewManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_server.pop.systemRightBotTip.SystemRightTipVO;
	import com.editor.modules.app.view.ui.bottom.AppBottomContainer;
	import com.editor.modules.app.view.ui.bottom.AppBottomContainerMediator;
	import com.editor.modules.app.view.ui.topBar.AppTopBarContainer;
	import com.editor.modules.app.view.ui.topBar.AppTopBarContainerMediator;
	import com.editor.modules.event.AppModulesEvent;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class AppMainUIContainerMediator extends AppMediator
	{
		public static const NAME:String = 'AppMainUIContainerMediator'
		public function AppMainUIContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get container():AppMainUIContainer
		{
			return viewComponent as AppMainUIContainer
		}
		public function get topBarContainer():AppTopBarContainer
		{
			return container.topBarContainer;
		}
		public function get viewStack():AppMainUIViewStack
		{
			return container.viewStack;
		}
		public function get bottomContainer():AppBottomContainer
		{
			return container.bottomContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new AppTopBarContainerMediator(topBarContainer));
			registerMediator(new AppMainUIViewStackMediator(viewStack));
			registerMediator(new AppBottomContainerMediator(bottomContainer));
			
		}
		
		
	}
}