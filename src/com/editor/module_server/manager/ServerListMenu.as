package com.editor.module_server.manager
{
	import com.air.io.ReadFile;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.popup.input.InputTextPopwinVO;
	import com.editor.vo.user.UserInfoVO;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.filesystem.File;

	public class ServerListMenu extends SandyManagerBase
	{
		private static var instance:ServerListMenu ;
		public static function getInstance():ServerListMenu{
			if(instance == null){
				instance =  new ServerListMenu();
				instance.init_inject();
			}
			return instance;
		}
		
		private static const menu_xml:XML = <root>
												<menuitem label="查询错误信息" data="1"/>
											</root>
		
		//打开右键菜单
		public function openRightMenu(user:UserInfoVO):void
		{
			var dat:SandyMenuData = new SandyMenuData();
			dat.xml  		= menu_xml
			dat.click_f  	= onMenuHandler;
			dat.data 		= user
			iManager.sendAppNotification(SandyExternalEvent.open_system_menu_event ,dat);
		}
		
		private function onMenuHandler(btn:IASMenuButton):void
		{
			var evt:XML = btn.getMenuXML()
			var args:UserInfoVO = btn.getMenuData() as UserInfoVO;
			
			if(evt.@data == "1"){ 
				var open:OpenPopwinData = new OpenPopwinData();
				open.popupwinSign = PopupwinSign.InputTextAreaPopwin_sign
				var d:InputTextPopwinVO = new InputTextPopwinVO();
				d.title = args.name + "的本地错误信息"
				var read:ReadFile = new ReadFile();
				var file:File = new File(File.applicationStorageDirectory.nativePath+File.separator+"uerror"+File.separator+args.name+"_error.txt");
				d.text = read.readFromFile(file);
				open.data = d;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
			}
		}
		
	}
}