package com.editor.modules.common.app.center
{
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.AppStackMediator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	
	public class AppMiddleCenterTopContainerMediator extends AppMediator
	{	
		public static const NAME:String = "AppMiddleCenterTopContainerMediatorextends";
		public function AppMiddleCenterTopContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get topContainer():AppMiddleCenterTopContainer
		{
			return viewComponent as AppMiddleCenterTopContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
			
		public function respondToOpenViewEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			if(ui == null) return ;
			if(type == DataManager.pop_codeEditor){
				if(StackManager.checkIsCodeStack()){
					topContainer.addChild(ui);
				}
			}
		}
		
		public function respondToCloseViewEvent(noti:Notification):void
		{
			/*var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			if(ui == null) return ;
			if(type == DataManager.pop_codeEditor){
				if(StackManager.checkIsCodeStack()){
					topContainer.removeChild(ui);
				}
			}*/
		}
		
		
	}	
}