package com.editor.command
{
	import com.air.io.DownloadFile;
	import com.air.io.FileUtils;
	import com.air.io.WriteFile;
	import com.air.logging.CatchLog;
	import com.air.sql.ConnLocalSqlManager;
	import com.air.utils.AIRUtils;
	import com.editor.event.AppEvent;
	import com.editor.manager.AppTimerManager;
	import com.editor.manager.DataManager;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.model.ServerInterfaceConst;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.proxy.AppPlusProxy;
	import com.editor.services.Services;
	import com.editor.view.preloader.AppPreLoaderContainerMediator;
	import com.editor.vo.dict.DictListVO;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.global.AppMenuConfig;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.common.zip.ZIP;
	import com.sandy.common.zip.ZIPFileVO;
	import com.sandy.component.controls.SandyLoader;
	import com.sandy.net.interfac.ISandySocketSendDataProxy;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.interfaces.INotification;
	import com.sandy.resource.LoadQueueConst;
	import com.sandy.resource.LoadQueueEvent;
	import com.sandy.resource.interfac.ILoadMultSourceData;
	import com.sandy.resource.interfac.ILoadQueueDataProxy;
	import com.sandy.resource.interfac.ILoadSourceData;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.version.VersionUtils;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	
	public class AppStartLoadCommand extends AppSimpleCommand
	{
		
		
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var sign:String = String(notification.getBody());
			if(StringTWLUtil.isWhitespace(sign)){			
				sendAppNotification(AppEvent.add_preLoader_msg_event,"启动中.....");
				load();
			}else if(sign == "loginSystem"){
				parserProject();
			}
		}
		
		private function load():void
		{
			var local_fl:File = new File(File.applicationDirectory.nativePath+File.separator+"plus"+File.separator+"plus.xml");
			if(!local_fl.exists){
				var c:String = '<?xml version="1.0" encoding="utf-8"?>';
				c += '<l>'
				c += "</l>"
				var write:WriteFile = new WriteFile();
				write.write(local_fl,c);
			}
			
			var mutltLoadData:ILoadMultSourceData = iResource.getMultLoadSourceData();
			
			var loadData:ILoadSourceData = iResource.getLoadSourceData();
			loadData.url = Services.assets_fold_url + "component.swf";
			loadData.type = LoadQueueConst.swf_type;
			mutltLoadData.addSWFData(loadData);
			
			loadData = iResource.getLoadSourceData();
			loadData.url = Services.assets_fold_url + "assets.swf";
			loadData.type = LoadQueueConst.swf_type;
			mutltLoadData.addSWFData(loadData);
			
			loadData = iResource.getLoadSourceData();
			loadData.url = Services.plus_fold_url + "plus.xml";
			loadData.type = LoadQueueConst.xml_type;
			loadData.cacheMode = LoadQueueConst.sourceCache_mode1
			mutltLoadData.addXMLData(loadData);
			
			var dt:ILoadQueueDataProxy = iResource.getLoadQueueDataProxy();
			dt.multSourceData = mutltLoadData;
			dt.allLoadComplete_f = _loadCompletehandle;
			dt.loadProgressF = _loadProgresshandle;
			iResource.loadMultResource(dt);
		}
		
		private function _loadProgresshandle(e:LoadQueueEvent):void
		{
			//sendNotification(HuntLoadingEvent.load_config2_progress_event,e)
		}
		
		private function get_AppPlusProxy():AppPlusProxy
		{
			return retrieveProxy(AppPlusProxy.NAME) as AppPlusProxy;
		}
		
		private function _loadCompletehandle(e:LoadQueueEvent):void
		{
			get_AppPlusProxy().load()
			checkDB_ver();
		}
		
		private var loadDB_loader:SandyLoader;
		private function checkDB_ver():void
		{
			if(!engineEditor.instance.isRelease){
				loadDB_error();
				return 
			}
			sendAppNotification(AppEvent.add_preLoader_msg_event,"检测本地数据库版本.....");
			loadDB_loader = new SandyLoader();
			loadDB_loader.complete_fun = loadDB_complete;
			loadDB_loader.ioError_fun = loadDB_error;
			loadDB_loader.load(Services.update_xml);
		}
		
		private var db_new_v:Number;
		private var version_xml:XML;
		private var db_complete:int
		
		
		private function loadDB_complete():void
		{
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			version_xml = XML(loadDB_loader.content);
			AppTimerManager.version_xml = version_xml;
			
			var pass1:Boolean;
			
			db_new_v = Number(version_xml.dbVer)
			var curr_v:Number = Number(iSharedObject.find("","dbVer"));
			if(curr_v == 0){
				pass1 = true;
				iSharedObject.put("","dbVer",db_new_v)
			}else{
				if(curr_v<db_new_v){
					downDB();
				}else{
					pass1 = true;
				}
			}
						
			if(pass1){
				checkMainVersion();
			}
			
			sendAppNotification(AppEvent.download_apifile_event);
			sendAppNotification(AppEvent.download_tempAS_event);
			//sendAppNotification(AppEvent.download_changeLog_event);
		}
		
		private function loadDB_error(e:Event=null):void
		{
			connLocalSql();
		}
				
		
		/////////////////////////////////////
		private var download:DownloadFile;
		private function downDB():void
		{
			db_complete = 1;
			if(download == null){
				download = new DownloadFile();
				download.addEventListener(ASEvent.PROGRESS,onDownDB_progress);
				download.addEventListener(ASEvent.COMPLETE,onDownDB_complete)
			}
			download.download(Services.db_url,Services.db_local_url)
		}
		
		private function onDownDB_progress(e:ASEvent):void
		{
			sendAppNotification(AppEvent.add_preLoader_msg_event,"更新db数据库....."+Math.ceil(e.data*100)+"%");
		}
		
		private function onDownDB_complete(e:ASEvent):void
		{
			iSharedObject.put("","dbVer",db_new_v);
			db_complete = 0;
			if(db_complete == 0){ 
				checkMainVersion();
			}
		}
		
		///////////////////////////////////////////////
		
		
		private function checkMainVersion():void
		{
			namespace ns = "http://ns.adobe.com/air/framework/update/description/1.0"
			use namespace ns;
			
			var new_vv:String = version_xml.versionNumber;
			
			iSharedObject.put("","versionNumber",AIRUtils.getAPP_version());
			var now_v:String = AIRUtils.getAPP_version()
			
			if(StringTWLUtil.isWhitespace(now_v)){
				iSharedObject.put("","versionNumber",new_vv);
				connLocalSql();
			}else{
				if(VersionUtils.checkVersion(now_v,new_vv)){
					openUpdate();
				}
				connLocalSql();
			}		
		}
		 
		private function openUpdate():void
		{
			closePoupwin(PopupwinSign.AppUpdateWinPopwin_sign);
			var open:OpenPopwinData = new OpenPopwinData();
			open.data = AppTimerManager.version_xml;
			open.popupwinSign = PopupwinSign.AppUpdateWinPopwin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		private function connLocalSql():void
		{
			sendAppNotification(AppEvent.add_preLoader_msg_event,"连接本地数据库.....");
			ConnLocalSqlManager.getInstance().connSuc_f = connLocalSql_suc;
			ConnLocalSqlManager.getInstance().connFault_f = connLocalSql_fault
			ConnLocalSqlManager.getInstance().connSql(Services.db_local_url,DataManager.pass);
		}

		private function connLocalSql_fault():void
		{
			sendAppNotification(AppEvent.add_preLoader_msg_event,"连接本地数据库失败");
		}
		
		private function connLocalSql_suc():void
		{
			sendAppNotification(AppEvent.add_preLoader_msg_event,"连接本地数据库成功");
			DictListVO.parser();
			AppGlobalConfig.instance.querySql();
			AppMenuConfig.instance.querySql();
			get_AppComponentProxy().load();
			AppTimerManager.getInstance().start();
			copyTool();
			
			
			appCreateComplete();
		}
		
		
		////////////////////////// 程序员////////////////////////////
				
		private function parserProject():void
		{
			sendAppNotification(AppEvent.add_preLoader_msg_event,"请等待...");
			var url:String = AppMainModel.getInstance().applicationStorageFile.curr_project;
			if(StringTWLUtil.isWhitespace(url)){
				AppPreLoaderContainerMediator.applogin();
				return ;
			}
			var file:File = new File(url);
			if(!file.exists){
				AppPreLoaderContainerMediator.applogin();
				return ;
			}
			if(AppMainModel.getInstance().enter3DScene){
				AppPreLoaderContainerMediator.applogin();
				return;
			}
			ProjectCache.getInstance().currEditProjectFile = file;
			parserLocale();
		}
		
		private function _parserProject():void
		{
			sendAppNotification(AppEvent.add_preLoader_msg_event,"后台线程解析本地项目目录"+"/"+getTimer());
			var url:String = AppMainModel.getInstance().applicationStorageFile.curr_project;
			var file:File = new File(url);		
			//后台线程开始运行
			sendAppNotification(AppEvent.importProject_event,file);
			AppPreLoaderContainerMediator.applogin();
		}
		
		private function parserLocale():void
		{
			sendAppNotification(AppEvent.add_preLoader_msg_event,"解析多国语言版本文件"+"/"+getTimer());
			//trace(getTimer())
			sendAppNotification(AppEvent.parserLocale_event);
			setTimeout(_parserProject,1000);
		}
		
		private function copyTool():void
		{
			sendAppNotification(AppEvent.download_tool_event);
		}
		
		private function appCreateComplete():void
		{
			sendAppNotification(AppEvent.app_createComplete_event);
		}
		
		private function get_AppComponentProxy():AppComponentProxy
		{
			return retrieveProxy(AppComponentProxy.NAME) as AppComponentProxy;
		}
	}
}