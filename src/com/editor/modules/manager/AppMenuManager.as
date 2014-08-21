package com.editor.modules.manager
{
	import com.air.io.FileUtils;
	import com.air.utils.AIRUtils;
	import com.editor.command.action.DownloadApiFileCommand;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_html.vo.OpenWebPageData;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.editor.modules.proxy.AppModuleProxy;
	import com.editor.popup.plusWin.PlusPopWin;
	import com.editor.proxy.AppPlusProxy;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.global.AppStorageConfFile;
	import com.editor.vo.plus.PlusItemVO;
	import com.editor.vo.pop.AppPopinfoVO;
	import com.editor.vo.xml.AppMenuItemVO;
	import com.editor.vo.xml.AppMenuListVO;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.manager.data.KeyStringCodeConst;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.URLUtils;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;

	
	public class AppMenuManager extends SandyManagerBase
	{
		private static var instance:AppMenuManager ;
		public static function getInstance():AppMenuManager{
			if(instance == null){
				instance =  new AppMenuManager();
			}
			return instance;
		}
		
		
		
		private var listenerKey:Boolean;
		private var listenerKey_ls:Array = [];
		public function registerKey():void
		{
			if(listenerKey ) return ;
			listenerKey = true;
			iManager.iKeybroad.addKeyDownProxyFun(this);
			
			var menuBar_ls:AppMenuListVO = AppModuleProxy.moduleProxy.menuBar_ls;
			var a:Array = menuBar_ls.list2;
			for(var i:int=0;i<a.length;i++){
				var x:XML = XML(a[i]);
				if(!StringTWLUtil.isWhitespace(x.@key)){
					listenerKey_ls[KeyStringCodeConst[x.@key]] = x;
				}
			}
		}
		
		override public function keyDown_f(e:KeyboardEvent):void
		{
			var code:int = e.keyCode;
			if(listenerKey_ls[code]!=null){
				var act:Boolean;
				if(e.ctrlKey){
					act = true;
				}else{
					if(code == KeyStringCodeConst.F1){
						act = true;	
					}
				}
				if(act){
					var popId:int = int(XML(listenerKey_ls[code]).@popId);
					var open:OpenPopwinData = new OpenPopwinData();
					open.data = XML(listenerKey_ls[code]);
					var d:AppPopinfoVO = AppGlobalConfig.instance.popInfo_vo.getData(popId);
					if(d == null) return ;
					open.addData = d.webId;
					open.popupwinSign = d.info;
					var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
					open.openByAirData = opt;
					openPopupwin(open);
				}
			}
		}
		
		/**
		 * 顶部的menubar的菜单
		 */ 
		public function topMenuBarClick(xml:XML):void
		{
			var plus:PlusItemVO = get_AppPlusProxy().list.getItem(xml.@label);
			if(plus!=null){
				var plus_n:String = plus.name;
				if(plus_n == "editor_api"){
					if(DownloadApiFileCommand.api_complete > 0){
						showMessage("api数据库正在更新，但还没下载完成，请等待或者可以进行其他操作");
						return ;
					}
				}
				var plus_w:PlusPopWin = new PlusPopWin();
				plus_w.setItem(plus);
				
				return ;
			}
			
			var d:int = int(xml.@data);
			if(d == 1){
				//新建项目
				createNewProject();return ;
			}else if(d == 2){
				//打开项目
				importSource();return ;
			}else if(d == 3){
				NativeApplication.nativeApplication.exit();return ;
			}else if(d == 4){
				openRecentProject();return ;
			}else if(d == 13){
				//系统日志
				openSystemLog();return ;
			}else if(d == 5){
				//关闭项目
				closeProject();return ;
			}else if(d == 6){
				//缓存目录
				openStorageFile();return ;
			}else if(d == 21){
				//关于
				openAboutWin();return ;
			}else if(d == 22){
				//帮助文档
				var dweb:OpenWebPageData = new OpenWebPageData();
				dweb.webURL = get_AppConfigProxy().help_website;
				sendAppNotification(AppEvent.openWebsite_event,dweb);
				return ;
			}else if(d == 23){
				//as3-api文档
				URLUtils.openLink(get_AppConfigProxy().as3_api);return ;
			}else if(d == 24){
				//截屏
				NativeApplication.nativeApplication.activeWindow.minimize();
				Object(SandyEngineGlobal.application).systrayBackFun();
				return ;
			}else if(d == 229){
				URLUtils.openLink(get_AppConfigProxy().config_hash.find("jsoneditoronline"));
				return ;
			}
			
			if(d >= 200 && d<= 299){
				//窗口
				var popId:int = int(xml.@popId);
				var open:OpenPopwinData = new OpenPopwinData();
				open.data = xml;
				open.addData = AppGlobalConfig.instance.popInfo_vo.getData(popId).webId;
				open.popupwinSign = AppGlobalConfig.instance.popInfo_vo.getData(popId).info;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
				return ;
			}
			
			if(d >= 300 && d<= 399){
				
				
				//窗口
				popId = int(xml.@popId);
				open = new OpenPopwinData();
				open.data = xml;
				open.addData = AppGlobalConfig.instance.popInfo_vo.getData(popId).webId;
				open.popupwinSign = AppGlobalConfig.instance.popInfo_vo.getData(popId).info;
				opt = new OpenPopByAirOptions();
				open.openByAirData = opt;
				openPopupwin(open);
				return ;
			}
			
			if(d >= 100 && d<= 199){
				//视图
				var stackId:int = int(xml.@stackId);
				StackManager.getInstance().changeStack(stackId);
				return ;
			}
			
			if(d == 500){
				URLUtils.openLink(get_AppConfigProxy().config_hash.find("wiki"))
			}else if(d == 501){
				URLUtils.openLink(get_AppConfigProxy().config_hash.find("codeLib"))
			}
		}
		
		private function openAboutWin():void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.AboutPopwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		//缓存目录
		private function openStorageFile():void
		{
			FileUtils.openFold(AppStorageConfFile.getStorageDirt());
		}
		
		//新建项目
		public function createNewProject():void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.AppCreateProjectPopupwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		//系统日志
		public function openSystemLog():void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.AppLogPopupwin_sign;	
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		//导入资源
		public function importSource():void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.AppImportSourcePopupwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open)
		}
		
		//最近打开项目
		public function openRecentProject():void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.AppRecentOpenProjectPopwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open)
		}
		
		public function closeProject():void
		{
			sendAppNotification(AppModulesEvent.closeProject_event);
		}
		
		//create css file
		public function createClassFile(d:AppCreateClassFilePopwinVO):void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.AppCreateClassFilePopwin_sign;
			open.data = d;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open)
		}
		
		
		
		
		
		/**
		 * 编辑文件的菜单
		 */ 
		public function fileMenuClick(call_f:Function):void	
		{
			var dat:SandyMenuData = new SandyMenuData();
			dat.xml  		= get_AppModuleProxy().fileTabMenu.xml;
			dat.click_f  	= call_f;
			iManager.sendAppNotification(SandyExternalEvent.open_system_menu_event ,dat);
		}
		
		private function get_AppConfigProxy():AppGlobalConfig
		{
			return AppGlobalConfig.instance;
		}
		
		private function get_AppModuleProxy():AppModuleProxy
		{
			return iManager.retrieveProxy(AppModuleProxy.NAME) as AppModuleProxy 
		}
		
		private function get_AppPlusProxy():AppPlusProxy
		{
			return iManager.retrieveProxy(AppPlusProxy.NAME) as AppPlusProxy;
		}
	}
}