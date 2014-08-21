package com.editor.modules.common.app.center
{
	import com.editor.component.controls.UITabBarNav;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.AppStackMediator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.UIComponentUtil;
	
	public class AppMiddleCenterBottomContainerMediator extends AppMediator
	{	
		public static const NAME:String = "AppMiddleCenterBottomContainerMediator";
		public function AppMiddleCenterBottomContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get bottomContainer():AppMiddleCenterBottomContainer
		{
			return viewComponent as AppMiddleCenterBottomContainer;
		}
		public function get tabBar():UITabBarNav
		{
			return bottomContainer.tabBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToOpenViewEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
			if(type == DataManager.pop_console){
				if(StackManager.checkIsCodeStack()){
					if(!tabBar.contains(ui)){
						tabBar.addChild(ui);
					}
				}
			}
		}
		
		public function respondToCloseViewEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
			if(type == DataManager.pop_console){
				if(StackManager.checkIsCodeStack()){
					tabBar.setTabVisible(tabBar.getIndexByLabel(ui.label),false);
				}
			}
		}
		
		public function respondToChangeStackModeEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			if(type == DataManager.stack_code){
				tabBar.selectedIndex = 1;
			}
			
		}
		
		
	}
}