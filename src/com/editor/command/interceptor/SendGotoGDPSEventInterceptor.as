package com.editor.command.interceptor
{
	import com.editor.modules.app.mediator.AppMainPopupwinMediator;

	public class SendGotoGDPSEventInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			
			get_AppMainPopupwinMediator().initGDPS();
			
			proceed();
		}
		
		private function get_AppMainPopupwinMediator():AppMainPopupwinMediator
		{
			return retrieveMediator(AppMainPopupwinMediator.NAME) as AppMainPopupwinMediator;
		}
	}
}