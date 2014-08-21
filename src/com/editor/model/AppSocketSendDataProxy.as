package com.editor.model
{
	import com.sandy.net.SandySocketSendDataProxy;

	public class AppSocketSendDataProxy extends SandySocketSendDataProxy
	{
		public function AppSocketSendDataProxy()
		{
			super()
		}
		
		/**
		 * 是错误消息
		 */ 
		public var isError:Boolean = false;
		
		
		
		override public function createSendByteArray():Object
		{
			var obj:Object = super.createSendByteArray();
			obj.log = "send msg at:" + getHead() + " , cont: " + obj.log;
			return obj;
		}
		
	}
}