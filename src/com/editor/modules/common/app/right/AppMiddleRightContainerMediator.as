package com.editor.modules.common.app.right
{
	import com.editor.component.controls.UITabBarNav;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.AppStackMediator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	public class AppMiddleRightContainerMediator extends AppMediator
	{	
		public static const NAME:String = "AppMiddleRightContainerMediator";
		public function AppMiddleRightContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get rightContainer():AppMiddleRightContainer
		{
			return viewComponent as AppMiddleRightContainer;
		}
		public function get tabBar():UITabBarNav
		{
			return rightContainer.tabBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToOpenViewEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			 
			if(type == DataManager.pop_uiAttriList || type == DataManager.pop_cssAttriList ){
				if(StackManager.checkIsCodeStack()){
					if(!tabBar.contains(ui)){
						tabBar.addChild(ui);
					}else{
						tabBar.setTabVisible(tabBar.getIndexByLabel(ui.label),true);
					}
				}
			}
		}
		
		public function respondToChangeStackModeEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			if(type == DataManager.stack_code){
				tabBar.setSelectByLabel(DataManager.tabLabel_projectDirt);
			}else if(type == DataManager.stack_ui){
				tabBar.setSelectByLabel(DataManager.tabLabel_comAttriList);
			}else if(type == DataManager.stack_css){
				tabBar.setSelectByLabel(DataManager.tabLabel_cssAttriList);
			}
		}
		
		public function respondToCloseViewEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			if(ui == null) return ;
			if(type == DataManager.pop_uiAttriList || type == DataManager.pop_cssAttriList ){
				if(StackManager.checkIsCodeStack()){
					tabBar.setTabVisible(tabBar.getIndexByLabel(ui.label),false);
				}
			}
		}
		
	}
}