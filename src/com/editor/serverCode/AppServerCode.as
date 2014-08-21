package com.editor.serverCode
{
	import com.editor.model.AppSocketReceiveDataProxy;
	import com.sandy.net.interfac.ISandyByteArray;

	public class AppServerCode extends AppServerCodeProxy
	{
		public function AppServerCode()
		{
			super();
			getClassInfo(AppServerCode)
		}
		
		public function chatMsg(buf:ISandyByteArray):AppSocketReceiveDataProxy
		{
			var proxy:AppSocketReceiveDataProxy = createSocketReceiveDataProxy(buf);
			
			if(checkIsError(proxy.getErrorCode()))
			{
				
			}
			else
			{
				proxy.addMutableString(true);
			}
			return proxy;
		}
		
		
	}	
}