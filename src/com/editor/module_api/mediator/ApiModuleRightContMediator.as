package com.editor.module_api.mediator
{
	import com.editor.module_api.view.ApiModuleRightCont;
	import com.sandy.fabrication.SandyMediator;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	
	public class ApiModuleRightContMediator extends SandyMediator
	{
		public static const NAME:String = "ApiModuleRightContMediator"
		public function ApiModuleRightContMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get api():ApiModuleRightCont
		{
			return viewComponent as ApiModuleRightCont;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToParserApiCodeCodeEvent(noti:Notification):void
		{
			api.editor.codeText.codeColor(noti.getBody() as Array);
		}
	}
}