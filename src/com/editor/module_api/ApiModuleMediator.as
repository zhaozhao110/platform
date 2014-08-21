package com.editor.module_api
{
	import com.editor.module_api.manager.ApiSqlConn;
	import com.editor.module_api.mediator.ApiModuleLeftContMediator;
	import com.editor.module_api.mediator.ApiModuleManagerMediator;
	import com.editor.module_api.mediator.ApiModuleRightContMediator;
	import com.editor.module_api.mediator.ApiModuleTopBarMediator;
	import com.editor.module_api.view.ApiModuleLeftCont;
	import com.editor.module_api.view.ApiModuleManager;
	import com.editor.module_api.view.ApiModuleRightCont;
	import com.editor.module_api.view.ApiModuleTopBar;
	import com.sandy.fabrication.SandyMediator;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class ApiModuleMediator extends SandyMediator
	{
		public static const NAME:String = "ApiModuleMediator"
		public function ApiModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get api():ApiModule
		{
			return viewComponent as ApiModule;
		}
		public function get toolBar():ApiModuleTopBar
		{
			return api.toolCont;
		}
		public function get leftCont():ApiModuleLeftCont
		{
			return api.leftCont;
		}
		public function get rightCont():ApiModuleRightCont
		{
			return api.rightCont;
		}
		public function get managerCont():ApiModuleManager
		{
			return api.managerCont;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			respondToDownloadApifileCompleteEvent();
		}
		
		public function respondToDownloadApifileCompleteEvent(noti:Notification=null):void
		{
			if(retrieveMediator(ApiModuleTopBarMediator.NAME)) return ;
			registerMediator(new ApiModuleTopBarMediator(toolBar));
			registerMediator(new ApiModuleLeftContMediator(leftCont));
			registerMediator(new ApiModuleRightContMediator(rightCont));
			registerMediator(new ApiModuleManagerMediator(managerCont));	
			
			ApiSqlConn.getInstance().connSql();
		}
		
		
		
	}
}