package com.editor.module_gdps.command
{
	import com.editor.command.AppCommandMediator;
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.sandy.net.XmlSocketData;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class GdpsXMLSocketCommand extends AppCommandMediator
	{
		public static const NAME:String = "GdpsXMLSocketCommand"
		public function GdpsXMLSocketCommand(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			initMsgList();
		}
		
		/**
		 * 接受服务器传来的数据
		 */ 
		public function respondToReceiveDataFromXmlSocketEvent(noti:Notification):void
		{
			var buf:GDPSXmlSocketData = noti.getBody() as GDPSXmlSocketData;
			
			switch(buf.getMsgType())
			{
				default:
					sendNotification(getMsgEvent(buf.getMsgType()) , buf);
					break;
			}
		}
		
		private var msgList:Array;
		
		private function getMsgEvent(msg:String):String
		{
			return msgList[msg];
		}
		
		private function initMsgList():void
		{
			msgList = [];
			msgList[GdpsXmlSocketConst.publish_adddetail_msg] = "publishAdddetailMsg";
			msgList[GdpsXmlSocketConst.publish_server_msg] = "publishServerMsg";
			msgList[GdpsXmlSocketConst.publish_client_msg] = "publishClientMsg";
			msgList[GdpsXmlSocketConst.publish_res_msg] = "publishResMsg";
			msgList[GdpsXmlSocketConst.publish_config_msg] = "publishConfigMsg";
			msgList[GdpsXmlSocketConst.packaging_msg] = "packagingMsg";
			msgList[GdpsXmlSocketConst.detect_msg] = "detectMsg";
			msgList[GdpsXmlSocketConst.received_msg] = "receivedMsg";
			msgList[GdpsXmlSocketConst.register_msg] = "registerMsg";
			msgList[GdpsXmlSocketConst.timer_msg] = "timerMsg";
		}
	}
}