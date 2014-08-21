package com.editor.command.d3Action
{
	import com.editor.command.interceptor.AppAbstractInterceptor;
	import com.editor.modules.app.mediator.AppMainPopupwinMediator;

	public class D3SceneInitEventInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			
			get_AppMainPopupwinMediator().init3DMainUI();
			
			proceed();
		}
		
		private function get_AppMainPopupwinMediator():AppMainPopupwinMediator
		{
			return retrieveMediator(AppMainPopupwinMediator.NAME) as AppMainPopupwinMediator;
		}
	}
}