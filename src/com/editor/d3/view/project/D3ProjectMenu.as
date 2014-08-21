package com.editor.d3.view.project
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.modules.proxy.AppModuleProxy;
	import com.editor.vo.global.AppMenuConfig;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.manager.SandyManagerBase;
	
	import flash.filesystem.File;

	public class D3ProjectMenu extends SandyManagerBase
	{
		private static var instance:D3ProjectMenu ;
		public static function getInstance():D3ProjectMenu{
			if(instance == null){
				instance =  new D3ProjectMenu();
			}
			return instance;
		}
		
		public function openRightMenu(f:File,fromFile:Boolean):void
		{
			D3ProjectCache.disabledDataChange = false;
			var a:Array = [];
			var x:XML = AppMenuConfig.instance.d3ProjectMenu_xml;
			
			var dat:SandyMenuData = new SandyMenuData();
			dat.xml  		= XML(x);
			dat.click_f  	= onMenuHandler;
			dat.data 		= f
			iManager.sendAppNotification(SandyExternalEvent.open_system_menu_event ,dat);
		}
		
		private function onMenuHandler(btn:IASMenuButton):void
		{
			var evt:XML = btn.getMenuXML()
			var d:int = int(evt.@data);
			var dd:D3CompItemVO = D3ComponentProxy.getInstance().com_ls.getItemById(d);
			if(d == -1){
				get_D3ProjectPopViewMediator().delFile(btn.getMenuData());
				return ;
			}
			
			get_D3ProjectPopViewMediator().popButtonChange(dd);
		}
		
		private function get_D3ProjectPopViewMediator():D3ProjectPopViewMediator
		{
			return iManager.retrieveMediator(D3ProjectPopViewMediator.NAME) as D3ProjectPopViewMediator;
		}
		
		private function get_AppModuleProxy():AppModuleProxy
		{
			return iManager.retrieveProxy(AppModuleProxy.NAME) as AppModuleProxy 
		}
		
		private function get_AppMenuConfigProxy():AppMenuConfig
		{
			return AppMenuConfig.instance;
		}
	}
}