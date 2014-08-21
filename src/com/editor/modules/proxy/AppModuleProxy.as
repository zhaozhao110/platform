package com.editor.modules.proxy
{
	
	import com.editor.modules.manager.AppMenuManager;
	import com.editor.proxy.AppProxy;
	import com.editor.vo.global.AppMenuConfig;
	import com.editor.vo.xml.AppMenuListVO;
	import com.editor.vo.xml.AppXMLListVO;

	public class AppModuleProxy extends AppProxy
	{
		public static const NAME:String = "AppModuleProxy"
		
		public function AppModuleProxy()
		{
			super(NAME);
			moduleProxy = this;
			parser()
		}
		
		
		public static var moduleProxy:AppModuleProxy;
		public var action_ls:AppMenuListVO;
		public var projectDirectory_ls:AppMenuListVO;
		public var menuBar_ls:AppMenuListVO;
		public var fileTabMenu:AppMenuListVO;
		
		
		public function parser():void
		{
			action_ls = new AppMenuListVO(get_AppMenuConfigProxy().consol_xml);
			projectDirectory_ls = new AppMenuListVO(get_AppMenuConfigProxy().projectMenu_xml)
			menuBar_ls = new AppMenuListVO(get_AppMenuConfigProxy().topMenu_xml);
			fileTabMenu = new AppMenuListVO(get_AppMenuConfigProxy().fileTabMenu_xml);
			
			AppMenuManager.getInstance().registerKey();
		}
		
		private function get_AppMenuConfigProxy():AppMenuConfig
		{
			return AppMenuConfig.instance;
		}
	}
}