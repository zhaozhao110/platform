package com.editor.module_gdps.services
{
	public class GDPSServices
	{
		
		public static var SOCKET_PORT:Number = 8888;
		
		public static var CLIENT_DOMAIN:String = "dev.hunter.bojoy.net/Hunter_cn_cn_CLIENT";
		public static var CLIENT_DOMAIN2:String = "dev.hunter2.bojoy.net/Hunter2_cn_cn_CLIENT";
		
		public static function cilentDomain():String
		{
			if(serverDomain == "http://192.168.0.9:83"){
				return "http://" + CLIENT_DOMAIN2;
			}
			return "http://" + CLIENT_DOMAIN;
		}
		
		public static var serverDomain:String = "http://127.0.0.1:8080";
		public static var socketDomain:String = "127.0.0.1";
		
		public static function init(domain:String = "127.0.0.1:8080"):void
		{
			serverDomain = "http://" + domain;
			socketDomain = domain.split(':')[0];
			
			getLoginVerify_url = serverDomain + "/login.do?m=login";
			getRefSession_url = serverDomain + "/login.do?m=refSession";
			getLoginProject_url = serverDomain + "/login.do?m=project";
			getLoginProject_opr_url = serverDomain + "/gdps/system/server.do?m=oprList";
			
			getCacheDictData_url = serverDomain + "/gdps/system/cache.do?m=dict";
			getCacheProjectData_url = serverDomain + "/gdps/system/cache.do?m=project";
			getCacheServerConfigData_url = serverDomain + "/gdps/system/cache.do?m=serverConfig";
			
			getLeftTreeData_url = serverDomain + "/system/menu.do?m=query";
			getLeftTreeMoreInfo_url = serverDomain + "/system/menu.do?m=queryDetail";
			
			exportPropsExcel_url = serverDomain + "/gdps/prop.do?m=exportProps";
			getPublishPropData_url = serverDomain + "/gdps/prop.do?m=publishProps";
			
			getDataGridColumn_url = serverDomain + "/gdps/sub/tableSpace.do?m=queryColumns";
			getTableData_url = serverDomain + "/gdps/sub/tableSpace.do?m=tableList";
			getSaveTableData_url = serverDomain + "/gdps/sub/tableSpace.do?m=saveTable";
			getDeleteTableData_url = serverDomain + "/gdps/sub/tableSpace.do?m=deleteTable";
			getColumnData_url = serverDomain + "/gdps/sub/tableSpace.do?m=columnList";
			getSaveColumnData_url = serverDomain + "/gdps/sub/tableSpace.do?m=saveColumn";
			getDeleteColumnData_url = serverDomain + "/gdps/sub/tableSpace.do?m=deleteColumn";
			getCreateTableData_url = serverDomain + "/gdps/sub/tableSpace.do?m=createTable";
			getTableDataTemplete_url = serverDomain + "/gdps/sub/tableSpace.do?m=templete";
			getPublishTableData_url = serverDomain + "/gdps/sub/tableSpace.do?m=publishTableList";
			
			getPrepareTableData_url = serverDomain + "/gdps/sub/tableData.do?m=prepare";
			getVersionTableData_url = serverDomain + "/gdps/sub/tableData.do?m=version";
			getComparisonTableData_url = serverDomain + "/gdps/sub/tableData.do?m=comparison";
			submitTableData_url = serverDomain + "/gdps/sub/tableData.do?m=submit";
			importTableData_url = serverDomain + "/gdps/sub/tableData.do?m=import";
			testTableData_url = serverDomain + "/gdps/sub/tableData.do?m=test";
			profileData_url = serverDomain + "/gdps/sub/columnProfile.do?m=profileList";
			profileSaveData_url = serverDomain + "/gdps/sub/columnProfile.do?m=saveProfile";
			profileDeleteData_url = serverDomain + "/gdps/sub/columnProfile.do?m=deleteProfile";
			profileGenerateDoc_url = serverDomain + "/gdps/sub/columnProfile.do?m=generateDoc";
			
			saveHunterMapData_url = serverDomain + "/gdps/sub/hunter/fileData.do?m=saveMap";
			saveHunterMotionImageData_url = serverDomain + "/gdps/sub/hunter/fileData.do?m=saveMotion";
			submitHunterFileData2version_url = serverDomain + "/gdps/sub/hunter/fileData.do?m=version";
			uploadMapEditorPng_url = serverDomain + "/gdps/sub/hunter/fileData.do?m=uploadMapPng";
			uploadMapXml_url = serverDomain + "/gdps/sub/hunter/fileData.do?m=uploadMapXml";
			getPrepareSqlData_url = serverDomain + "/gdps/sub/sqlData.do?m=prepare";
			getVersionSqlData_url = serverDomain + "/gdps/sub/sqlData.do?m=version";
			submitSqlData2Version_url = serverDomain + "/gdps/sub/sqlData.do?m=submit";
			uploadSqlData2Prepare_url = serverDomain + "/gdps/sub/sqlData.do?m=upload";
			deleteSqlDataRecord_url = serverDomain + "/gdps/sub/sqlData.do?m=delete";
			
			getDataVersionRecord_url = serverDomain + "/gdps/sub/logging/dataVersionRecord.do?m=list";
			
			getDetectBatchDetail_url = serverDomain + "/gdps/sub/packaging.do?m=detect";
			getPackagingBatchDetail_url = serverDomain + "/gdps/sub/packaging.do?m=packaging";
			
			getCloneBatchRecordData_url = serverDomain + "/gdps/sub/packaging.do?m=clone";
			
			getPublishTest_url = serverDomain + "/gdps/sub/publish.do?m=uploadTest";
			getPublishTiyan_url = serverDomain + "/gdps/sub/publish.do?m=uploadTiyan";
			getPublish_url = serverDomain + "/gdps/sub/publish.do?m=publish";
			getPublishServerProgress_url = serverDomain + "/gdps/sub/publish.do?m=progress";
			
			get_baseData_publish_url = serverDomain + "/gdps/sub/publish.do?m=uploadBasedata"; //更新基础数据至外网
			get_resData_publish_url = serverDomain + "/gdps/sub/publish.do?m=uploadResdata"; //更新RES数据至外网
			get_clientData_publish_url = serverDomain + "/gdps/sub/publish.do?m=uploadClientdata"; //更新Client数据至外网
			get_serverData_publish_url = serverDomain + "/gdps/sub/publish.do?m=uploadServerdata"; //更新Server数据至外网
			
			getBatchRecord_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=batch";
			getBatchRecordDetail_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=batchDetail";
			getSaveBatchRecord_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=save";
			getSaveDetailBatchRecord_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=saveDetail";
			getSaveEditDetail2BatchRecord_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=saveEditDetail";
			getDeleteBatchRecordData_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=delete";
			getAuditBatchRecordData_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=audit";
			getDeleteBatchDetail_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=deleteDetail";
			
			getBatchDetail_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=detail";
			getBatchExecuteRecordData_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=execute";
			getSaveBatchExecuteRecord_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=saveExecute";
			getDeleteBatchExecuteRecord_url = serverDomain + "/gdps/sub/publish/batchRecord.do?m=deleteExecute";
			
			getShowSvnlog_url = serverDomain + "/gdps/sub/svn.do?m=svnlog";
			getSvnSubmit_url = serverDomain + "/gdps/sub/svn.do?m=svnSubmit";
			
			
			getUserMamangeList_url = serverDomain + "/user.do?m=find";
			getUserMamangeSave_url = serverDomain + "/user.do?m=save";
			getUserMamangeDelete_url = serverDomain + "/user.do?m=delete";
			getUserMamangeRoles_url = serverDomain + "/user.do?m=findUserRoles";
			getUserManageSaveRole_url = serverDomain + "/user.do?m=saveUserRole";
			getuserManageProducts_url = serverDomain + "/user.do?m=findUserAreas";
			getuserManageSaveProducts_url = serverDomain + "/user.do?m=saveUserArea";
			
			getRoleMamangeGet_url = serverDomain + "/user.do?m=findByRole";
			getRoleMamangeList_url = serverDomain + "/role.do?m=find";
			getRoleMamangeSave_url = serverDomain + "/role.do?m=save";
			getRoleMamangeDelete_url = serverDomain + "/role.do?m=delete";
			
			getProductMamangeList_url = serverDomain + "/system/area.do?m=find";
			getProductMamangeSave_url = serverDomain + "/system/area.do?m=save";
			getProductMamangeDelete_url = serverDomain + "/system/area.do?m=delete";
			
			getServerMamangeList_url = serverDomain + "/system/gameServer.do?m=find";
			getServerMamangeSave_url = serverDomain + "/system/gameServer.do?m=save";
			getServerMamangeDelete_url = serverDomain + "/system/gameServer.do?m=delete";
			
		}
		//模块swf定义
		// gdps项目模块
		public static var loginModule_swf_url:String = "com/gdps/module/login/LoginModule.swf"
		// gdps子项目模块
		public static var mapModule_swf_url:String = "com/gdps/module/map/MapModule.swf"
		public static var peopleImageModule_swf_url:String = "com/gdps/module/peopleImage/PeopleImageModule.swf"
		public static var propModule_swf_url:String = "com/gdps/module/prop/PropModule.swf";
		public static var dataManageModule_swf_url:String = "com/gdps/module/dataManage/DataManageModule.swf";
		public static var tableSpaceModule_swf_url:String = "com/gdps/module/tableSpace/TableSpaceModule.swf";
		
		//登陆
		public static var getLoginVerify_url:String = null;
		public static var getRefSession_url:String = null;
		public static var getLoginProject_url:String = null;
		public static var getLoginProject_opr_url:String = null;
		//查询公用缓存数据等
		public static var getCacheDictData_url:String = null;
		public static var getCacheProjectData_url:String = null;
		public static var getCacheServerConfigData_url:String = null;
		//获取左边树型菜单结构数据
		public static var getLeftTreeData_url:String = null;
		public static var getLeftTreeMoreInfo_url:String = null;
		//props版本管理
		public static var exportPropsExcel_url:String = null;
		public static var getPublishPropData_url:String = null;
		//****************************************************表对象模块********************************************************/
		/**
		 * 表对象管理
		 */
		public static var getDataGridColumn_url:String = null;
		public static var getTableData_url:String = null;
		public static var getSaveTableData_url:String = null;
		public static var getDeleteTableData_url:String = null;
		public static var getColumnData_url:String = null;
		public static var getSaveColumnData_url:String = null;
		public static var getDeleteColumnData_url:String = null;
		public static var getCreateTableData_url:String = null;
		public static var getTableDataTemplete_url:String = null;
		public static var getPublishTableData_url:String = null;
		//****************************************************基础数据模块********************************************************/
		/*道具定义管理-废弃*/
		public static var getPrePropData_url:String = "/gdps/sub/dataManage/props.do?m=preProps";
		public static var getVersionPropData_url:String = "/gdps/sub/dataManage/props.do?m=versionProps";
		public static var getComparisonPropData_url:String = "/gdps/sub/dataManage/props.do?m=comparisonProps";
		public static var submitPropData_url:String = "/gdps/sub/dataManage/props.do?m=submitProps";
		public static var importPropsExcel_url:String = "/gdps/sub/dataManage/props.do?m=importProps";
		public static var testPropsHasCommit_url:String = "/gdps/sub/dataManage/props.do?m=testProps";
		/*基础数据管理*/
		public static var getPrepareTableData_url:String = null;
		public static var getVersionTableData_url:String = null;
		public static var getComparisonTableData_url:String = null;
		public static var submitTableData_url:String = null;
		public static var importTableData_url:String = null;
		public static var testTableData_url:String = null;
		public static var profileData_url:String = null;
		public static var profileSaveData_url:String = null;
		public static var profileDeleteData_url:String = null;
		public static var profileGenerateDoc_url:String = null;
		//*************************************************文件数据模块相关********************************************************/
		public static var saveHunterMapData_url:String = null; //地图场景 mapid.xml
		public static var saveHunterMotionImageData_url:String = null //动画资源
		public static var submitHunterFileData2version_url:String = null //加入版本库
		public static var uploadMapEditorPng_url:String = null //上传地图编辑器图片
		public static var uploadMapXml_url:String = null //上传地图编辑器图片
		public static var getPrepareSqlData_url:String = null;
		public static var getVersionSqlData_url:String = null;
		public static var submitSqlData2Version_url:String = null;
		public static var uploadSqlData2Prepare_url:String = null;
		public static var deleteSqlDataRecord_url:String = null;
		//****************************************************版本日志模块********************************************************/
		/*基础数据历史版本记录*/
		public static var getDataVersionRecord_url:String = null;
		//****************************************************批次检测打包********************************************************/
		//批次检测打包
		public static var getDetectBatchDetail_url:String = null;
		public static var getPackagingBatchDetail_url:String = null;
		//克隆批次 add on 2013-07-12
		public static var getCloneBatchRecordData_url:String = null;
		//****************************************************更新发布批次模块*****************************************************/
		public static var getPublishTest_url:String = null; //更新发布测试服
		public static var getPublishTiyan_url:String = null; //更新体验服
		public static var getPublish_url:String = null; //发布正式服
		public static var getPublishServerProgress_url:String = null; //发布正式服务器进度
		
		public static var get_baseData_publish_url:String = null; //更新基础数据至外网
		public static var get_resData_publish_url:String = null; //更新RES数据至外网
		public static var get_clientData_publish_url:String = null; //更新Client数据至外网
		public static var get_serverData_publish_url:String = null; //更新Server数据至外网
		/*总更新批次记录*/
		public static var getBatchRecord_url:String = null;
		/**元数据明细***/
		public static var getBatchRecordDetail_url:String = null;
		public static var getSaveBatchRecord_url:String = null;
		public static var getSaveDetailBatchRecord_url:String = null;
		public static var getDeleteBatchRecordData_url:String = null;
		public static var getAuditBatchRecordData_url:String = null;
		public static var getDeleteBatchDetail_url:String = null;
		public static var getSaveEditDetail2BatchRecord_url:String = null;
		/**数据相关明细***/
		public static var getBatchDetail_url:String = null;
		public static var getBatchExecuteRecordData_url:String = null;
		public static var getSaveBatchExecuteRecord_url:String = null;
		public static var getDeleteBatchExecuteRecord_url:String = null;
		//***************************************************svn管理模块*************************************************************/
		public static var getShowSvnlog_url:String = null;
		public static var getSvnSubmit_url:String = null;
		
		/***用户管理模块***/
		public static var getUserMamangeList_url:String;
		public static var getUserMamangeSave_url:String;
		public static var getUserMamangeDelete_url:String;
		public static var getUserMamangeRoles_url:String;
		public static var getUserManageSaveRole_url:String;
		public static var getuserManageProducts_url:String;
		public static var getuserManageSaveProducts_url:String;
		
		/***角色管理模块***/
		public static var getRoleMamangeList_url:String;
		public static var getRoleMamangeSave_url:String;
		public static var getRoleMamangeGet_url:String;
		public static var getRoleMamangeDelete_url:String;
		
		/**项目定义模块****/
		public static var getProductMamangeList_url:String;
		public static var getProductMamangeSave_url:String;
		public static var getProductMamangeDelete_url:String;
		
		/***服务器定义模块***/
		public static var getServerMamangeList_url:String;
		public static var getServerMamangeSave_url:String;
		public static var getServerMamangeDelete_url:String;
		
	}
}