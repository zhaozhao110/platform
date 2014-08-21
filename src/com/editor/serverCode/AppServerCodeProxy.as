package com.editor.serverCode
{
	
	import com.editor.model.AppSocketReceiveDataProxy;
	import com.sandy.net.ServerCodeProxy;
	import com.sandy.net.interfac.ISandyByteArray;
	
	public class AppServerCodeProxy extends ServerCodeProxy
	{
		public function AppServerCodeProxy()
		{
			super();
		}
		
		/**
		 * 检测是否是错误码
		 */ 
		protected function checkIsError(error:int):Boolean
		{
			return error > 100
		}
		
		protected function createSocketReceiveDataProxy(buf:ISandyByteArray):AppSocketReceiveDataProxy
		{
			var proxy:AppSocketReceiveDataProxy = iSocket.getSocketReceiveDataProxy() as AppSocketReceiveDataProxy;
			proxy.setByteArray(buf);
			
			//消息吗
			proxy.addShortData()
			//消息回执码
			proxy.addShortData()
			//错误码
			proxy.addShortData()
			
			return proxy;
		}
		
		protected function parserError(proxy:AppSocketReceiveDataProxy):void
		{
			while(proxy.bytesAvailable()){
				proxy.addMutableString();
			}
		}
	}
}