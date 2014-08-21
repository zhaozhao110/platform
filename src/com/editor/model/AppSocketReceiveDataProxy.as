package com.editor.model
{
	import com.sandy.net.SandySocketReceiveDataProxy;
	import com.sandy.net.interfac.ISandyByteArray;
	
	public class AppSocketReceiveDataProxy extends SandySocketReceiveDataProxy
	{
		public function AppSocketReceiveDataProxy()
		{
			super();
		}
		
		/**
		 * 是错误消息
		 */ 
		public var isError:Boolean = false
		
		public var byteArray:ISandyByteArray;
			
		
		/**
		 * 是否是错误码
		 */ 
		public function checkIsError():Boolean
		{
			return getErrorCode() > 100
		}
		
		override public function createReceiveByteArray():Object
		{
			var obj:Object = super.createReceiveByteArray();
			obj.log = "receive msg at:" + getMsgHead() + " , cont: " + obj.log;
			return obj;
		}
		
	}
}