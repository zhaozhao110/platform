package com.editor.module_server
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_server.mediator.ServerModBroadcastMediator;
	import com.editor.module_server.mediator.ServerModSocketMediator;
	import com.editor.module_server.view.ServerMod_broadcast;
	import com.editor.module_server.view.ServerMod_socket;

	public class ServerModuleMediator extends AppMediator
	{
		public static const NAME:String = "ServerModuleMediator";
		public function ServerModuleMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		public function get serverMod():ServerModule
		{
			return viewComponent as ServerModule;
		}
		public function get broadcast():ServerMod_broadcast
		{
			return serverMod.broadcast;
		}
		public function get socket():ServerMod_socket
		{
			return serverMod.socket;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new ServerModBroadcastMediator(broadcast));
			registerMediator(new ServerModSocketMediator(socket));
		}
		
		
	}
}