package com.editor.module_api.mediator
{
	import com.editor.module_api.view.ApiModuleManager;
	import com.sandy.fabrication.SandyMediator;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	public class ApiModuleManagerMediator extends SandyMediator
	{
		public static const NAME:String = "ApiModuleManagerMediator"
		public function ApiModuleManagerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get api():ApiModuleManager
		{
			return viewComponent as ApiModuleManager;
		}
				
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToApiAddLogEvent(noti:Notification):void
		{
			api.log_proxy(String(noti.getBody()));
		}
		
		public function respondToParserApiEndEvent(noti:Notification):void
		{
			api.parserApiEnd();
		}
	}
}