package com.editor.modules.common.app.center
{
	import com.editor.component.containers.UICanvas;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.AppStackMediator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	public class AppMiddleCenterContainerMediator extends AppMediator
	{	
		public static const NAME:String = "AppMiddleCenterContainerMediator";
		public function AppMiddleCenterContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get centerContainer():AppMiddleCenterContainer
		{
			return viewComponent as AppMiddleCenterContainer
		}
		public function get topContainer():AppMiddleCenterTopContainer
		{
			return centerContainer.topContainer;
		}
		public function get bottomContainer():AppMiddleCenterBottomContainer
		{
			return centerContainer.bottomContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new AppMiddleCenterTopContainerMediator(topContainer));
			registerMediator(new AppMiddleCenterBottomContainerMediator(bottomContainer));
		}
		
		public function respondToOpenViewEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			if(ui == null) return ;
			if(type == DataManager.pop_uiEditor){
				if(StackManager.checkIsCodeStack()){
					if(!centerContainer.contains(ui)){
						centerContainer.addChild(ui);
						centerContainer.setSelectedLast();
					}
				}
			}else if(type == DataManager.pop_cssEdit){
				if(StackManager.checkIsCodeStack()){
					if(!centerContainer.contains(ui)){
						centerContainer.addChild(ui);
						centerContainer.setSelectedLast();
					}
				}
			}
		}
		
		public function respondToCloseViewEvent(noti:Notification):void
		{
			/*var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			if(type == DataManager.pop_uiEditor){
				if(StackManager.checkIsCodeStack()){
					centerContainer.removeChild(ui);
				}
			}*/
		}
		
		public function respondToChangeStackModeEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			if(type == DataManager.stack_ui){
				centerContainer.setSelectByLabel(DataManager.tabLabel_uiEdit)
			}else if(type == DataManager.stack_code){
				centerContainer.selectedIndex = 0;
			}else if(type == DataManager.stack_css){
				centerContainer.setSelectByLabel(DataManager.tabLabel_cssEdit)
			}
		}
		
		
	}
}