package com.editor.modules.app.view.ui.bottom
{
	import com.air.net.NetworkIsWorking;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.manager.RPGSocketManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.module_server.pop.systemRightBotTip.SystemRightTipVO;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class AppBottomContainerMediator extends AppMediator
	{
		public static const NAME:String = "AppBottomContainerMediator"
		public function AppBottomContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get bottomContainer():AppBottomContainer
		{
			return viewComponent as AppBottomContainer;
		}
		public function get logTxt():UILabel
		{
			return bottomContainer.logtxt;
		}
		public function get networkLB():UILabel
		{
			return bottomContainer.networkLB;
		}
		public function get netIcon():UIImage
		{
			return bottomContainer.netIcon;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			NetworkIsWorking.start();
		}
		
		public function addLog2(s:String):void
		{
			reflashStatus()
			logTxt.text += s;
		}
		
		private function reflashStatus():void
		{
			if(AppMainModel.getInstance().user.checkIsSystem()) return ;
			logTxt.text = "(服务器地址:"+AppGlobalConfig.instance.socket_url+","+AppGlobalConfig.instance.socket_port+")";
			if(RPGSocketManager.getInstance().conected){
				logTxt.text = ",服务器连接成功"
			}else{
				logTxt.text = ",服务器连接失败，每30秒将会重连,直到连接成功"
			}
			
		}
		
		public function respondToNetworkAvailableEvent(noti:Notification):void
		{
			netWorking(Boolean(noti.getBody()))
		}
		
		private function netWorking(b:Boolean):void
		{
			if(b){
				networkLB.text = "网络可用"
				netIcon.source = "net_a"
			}else{
				networkLB.text = "网络不可用,请检查网络"
				netIcon.source = "net2_a"
			}
		}
	}
}