package com.editor.d3.app.view.ui.bottom
{
	import com.air.net.NetworkIsWorking;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.manager.DataManager;
	import com.editor.manager.RPGSocketManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.module_server.pop.systemRightBotTip.SystemRightTipVO;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class App3DBottomContainerMediator extends AppMediator
	{
		public static const NAME:String = "App3DBottomContainerMediator"
		public function App3DBottomContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get bottomContainer():App3DBottomContainer
		{
			return viewComponent as App3DBottomContainer;
		}
		public function get tabBar():UITabBarNav
		{
			return bottomContainer.tabBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToOpenView3dEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
			if(type == DataManager.pop3d_project){
				if(!tabBar.contains(ui)){
					tabBar.addChild(ui);
				}
			}else if(type == DataManager.pop3d_console){
				if(!tabBar.contains(ui)){
					tabBar.addChild(ui);
				}
			}else if(type == DataManager.pop3d_outline){
				if(!tabBar.contains(ui)){
					tabBar.addChild(ui);
				}
			}
		}
		
		public function respondToCloseView3dEvent(noti:Notification):void
		{
			var type:int = int(noti.getType());
			var ui:ASComponent = noti.getBody() as ASComponent;
			
		}
	}
}