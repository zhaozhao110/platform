package com.editor.proxy
{
	import com.sandy.fabrication.SandyOperationProxy;
	
	import flash.utils.setTimeout;
	
	public class AppProxy extends SandyOperationProxy
	{
		public function AppProxy(proxyName:String=null)
		{
			super(proxyName);
		}
		
		protected function getXML(type:String):XML
		{
			return XML(iCacheManager.getCompleteLoadSource(type))
		}
		
		override protected function operationEnd():void
		{
			if(operationEndCall!=null){
				setTimeout(operationEndCall,200);
			}
		}
		
	}
}