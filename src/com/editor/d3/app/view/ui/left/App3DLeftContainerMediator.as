package com.editor.d3.app.view.ui.left
{
	import com.editor.component.controls.UITabBarNav;
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class App3DLeftContainerMediator extends AppMediator
	{
		public static const NAME:String = "App3DLeftContainerMediator"
		public function App3DLeftContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get leftContainer():App3DLeftContainer
		{
			return viewComponent as App3DLeftContainer;
		}
		public function get tabBar():UITabBarNav
		{
			return leftContainer.tabBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToOpenView3dEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
			leftContainer.visible = false;
		}
		
		public function respondToCloseView3dEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
		}
	}
}