package com.editor.module_server.mediator
{
	import com.air.event.AIREvent;
	import com.air.server.SandySocketServer;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.manager.RPGSocketManager;
	import com.editor.mediator.AppMediator;
	import com.editor.module_server.view.ServerMod_socket;
	import com.sandy.event.SandyEvent;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.MouseEvent;

	public class ServerModSocketMediator  extends AppMediator
	{
		public static const NAME:String = "ServerModSocketMediator"
		public function ServerModSocketMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get socketWin():ServerMod_socket
		{
			return viewComponent as ServerMod_socket;
		}
		public function get startBtn():UIButton
		{
			return socketWin.startBtn;
		}
		public function get stopBtn():UIButton
		{
			return socketWin.stopBtn;
		}
		public function get restartBtn():UIButton
		{
			return socketWin.restartBtn;
		}
		public function get logTxt():UITextArea
		{
			return socketWin.logTxt;
		}
		public function get infoTxt():UIText
		{
			return socketWin.infoTxt;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			socket = new SandySocketServer();
			socket.addEventListener(AIREvent.CLIENT_SOCKETDATA,onClientSocketData)
			socket.addEventListener(AIREvent.CLOSE_EVENT,onClose);
			socket.addEventListener(AIREvent.CONNECT_EVENT,onConnect);
			socket.addEventListener(AIREvent.LISTENER_EVENT,onListener);
			socket.addEventListener(AIREvent.CLIENT_CLOSE_EVENT,onClientClose);
			
			RPGSocketManager.getInstance().socket = socket;
		}
		
		private var socket:SandySocketServer;
		
		public function reactToStartBtnClick(e:MouseEvent):void
		{
			socket.start(7000);
			reflashInfo()
		}
		
		public function reactToStopBtnClick(e:MouseEvent):void
		{
			socket.stop();
			reflashInfo()
		}
		
		public function reactToRestartBtnClick(e:MouseEvent):void
		{
			socket.restart();
			reflashInfo()
		}
		
		private function onClose(e:SandyEvent):void
		{
			appendHtmlText("连接已经关闭");
			RPGSocketManager.getInstance().clearOnlineList();
			RPGSocketManager.getInstance().clearSelectedList();
			reflashInfo()
		}
		
		private function onConnect(e:SandyEvent):void
		{
			appendHtmlText("有新的连接: " + e.data);	
			reflashInfo()
		}
		
		private function onListener(e:SandyEvent):void
		{
			appendHtmlText("服务器已经开始监听");
			reflashInfo()
		}
		
		private function onClientClose(e:SandyEvent):void
		{
			appendHtmlText("客户端连接关闭: " + e.data);
			RPGSocketManager.getInstance().removeOnline(String(e.data));
			reflashInfo();
		}
		
		private function onClientSocketData(e:SandyEvent):void
		{
			var msg:String = String(e.data);
			var address:String = String(e.addData);
			RPGSocketManager.getInstance().addMsg(msg,address);
		}
		
		private function appendHtmlText(s:String):void
		{
			logTxt.appendHtmlText(TimerUtils.getSec_hour(":",NaN,true)+" - " + s);
		}
				
		private function reflashInfo():void
		{
			infoTxt.text = "连接数: " + socket.clientConnectTotal + ",";
			get_ServerModBroadcastMediator().reflashUserList();
		}
		
		private function get_ServerModBroadcastMediator():ServerModBroadcastMediator
		{
			return retrieveMediator(ServerModBroadcastMediator.NAME) as ServerModBroadcastMediator;
		}
	}
}