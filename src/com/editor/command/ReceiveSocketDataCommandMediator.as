package com.editor.command
{
	
	import com.sandy.net.interfac.ISandySocketReceiveDataProxy;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class ReceiveSocketDataCommandMediator extends AppCommandMediator
	{
		public static const NAME:String = "ReceiveSocketDataCommandMediator"
		public function ReceiveSocketDataCommandMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);			
		}
		
		/**
		 * 接受服务器传来的数据
		 */ 
		public function respondToReceiveDataFromSocketEvent(noti:Notification):void
		{
			var buf:ISandySocketReceiveDataProxy = noti.getBody() as ISandySocketReceiveDataProxy;
			if(buf.getMsgHead() == 5000){
				trace(buf.getItemData(3));
			}
		}
	}
}