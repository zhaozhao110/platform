package com.editor.module_server
{
	import com.editor.component.UIModule2;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.module_server.view.ServerMod_broadcast;
	import com.editor.module_server.view.ServerMod_socket;
	
	public class ServerModule extends UIVBox
	{
		public function ServerModule()
		{
			super();
			create_init();
		}
		
		public static const MODULENAME:String = "ServerModule";
		
		
		public var broadcast:ServerMod_broadcast;
		public var socket:ServerMod_socket;
		public var tabNav:UITabBarNav;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas";
			padding = 10;
			
			tabNav = new UITabBarNav();
			tabNav.enabledPercentSize = true;
			addChild(tabNav);
			
			socket = new ServerMod_socket();
			socket.label = "服务器"
			tabNav.addChild(socket);
			
			broadcast = new ServerMod_broadcast();
			broadcast.label = "在线人员"
			tabNav.addChild(broadcast);
			
			tabNav.selectedIndex = 0;
			
		}
	}
}