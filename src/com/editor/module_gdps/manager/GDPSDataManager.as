package com.editor.module_gdps.manager
{
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.module_gdps.vo.user.GDPSUserInfoVO;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.net.interfac.IXMLSocketManager;

	public class GDPSDataManager
	{
		private static var instance:GDPSDataManager;
		
		public static function getInstance():GDPSDataManager
		{
			if (instance == null)
			{
				instance = new GDPSDataManager();
			}
			return instance;
		}
		
		public function GDPSDataManager()
		{
			initData();
		}
		
		private var userInfo:GDPSUserInfoVO;
		private var serverAddress:String;
		private var projects:Array;
		private var serversList:Array;
		private var scopeList:Array;
		private var stateList:Array;
		
		/**
		 * 设置登录用户基本信息
		 */
		public function set setUserInfo(userInfo:GDPSUserInfoVO):void
		{
			this.userInfo = userInfo;
		}
		
		public function get getUserInfo():GDPSUserInfoVO
		{
			return this.userInfo;
		}
		
		/**
		 * 设置当前登录服务器地址 
		 */
		public function set setServerAddress(serverAddress:String):void
		{
			this.serverAddress = serverAddress;
		}
		
		public function get getServerAddress():String
		{
			return this.serverAddress;
		}
		
		/**
		 * 项目数据
		 */
		public function set setProjects(a:Array):void
		{
			projects = a;
		}
		
		public function get getProjects():Array
		{
			return projects;
		}
		
		/**
		 * 平台数据
		 */
		public function set setServersList(a:Array):void
		{
			serversList = a;
		}
		
		public function get getServerList():Array
		{
			return serversList;
		}
		
		public function getStateName(type:int):String
		{
			if(!stateList[type]){
				return "";
			}
			return stateList[type];
		}
		
		public function getCropeName(type:int):String
		{
			if(!scopeList[type]){
				return "";
			}
			return scopeList[type];
		}
		
		public static const dataGridDefaultTheme:String = "dataGrid2";
		
		public static const systemManagerType:int = 10000;//系统管理账号
		
		public static const tableDataType:String = "1";//基础表数据类型
		public static const fileDataType:String = "2";//文件数据类型
		public static const sqlDataType:String = "3";//db sql 数据类型
		
		public static const base_data_type:String = "1";//1-基础数据类型
		public static const res_data_type:String = "2";//2-RES数据类型
		public static const client_data_type:String = "3";//3-客户端数据类型
		public static const server_data_type:String = "4";//4-服务端数据类型
		
		public static const resultFor_text_type:String 	= "text";
		public static const resultFor_xml_type:String 	= "xml";
		public static const resultFor_obj_type:String  	= "object";
		
		public static const colorsLib:Array = [0x1178df , 0x7e0f4e , 0x900a23, 0x165a18 , 
			0xbd3624 , 0x5a1390 , 0x481fbe , 0x22993b,0x24820e];//颜色库
		
		public static const sexList:Array = [{label:"女[0]",value:0},{label:"男[1]" , value:1}];
		public static const statusList:Array = [{label:"禁用[0]",value:0},{label:"启用[1]" , value:1}];
		public static const typeList:Array = [{label:"webgame[1]",value:1},{label:"mobilegame[2]" , value:2}];
		
		public static const serverNames:Array = [{label:"测试服务器[0]",value:0},{label:"常规服务器[1]" , value:1},
												  {label:"跨服服务器[2]",value:2},{label:"CDN服务器[3]" , value:3}];
		
		public static const netLines:Array = [{label:"双线[0]",value:0},{label:"电信[1]" , value:1},
											  {label:"网通[2]",value:2},{label:"虚拟[9]" , value:9}];
		
		public static const serverStates:Array = [{label:"禁用[0]",value:0},
												  {label:"已开服[1]" , value:1},
												  {label:"未部署[2]",value:2},
												  {label:"部署中[3]" , value:3},
												  {label:"已部署(未清挡)[4]" , value:4},
												  {label:"已清挡(未开服)[5]" , value:5},
												  {label:"清挡中[6]" , value:6}];
		
		
		public static const tableSpaceType:String = "com/gdps/module/tableSpace/TableSpaceModule.swf";
		public static const columnProfileStye:String = "com/gdps/module/columnProfile/ColumnProfileModule.swf";
		public static const fileDataManagerType:String = "com/gdps/module/fileManage/FileDataManageModule.swf";
		public static const dataManagerType:String = "com/gdps/module/dataManage/DataManageModule.swf";
		public static const dataBaseFileType:String = "com/gdps/module/databaseManage/DatabaseFileModule.swf";
		public static const publishType:String = "com/gdps/module/publish/PublishModule.swf";
		public static const packagingType:String = "com/gdps/module/packaging/PackagingModule.swf";
		public static const publishResType:String = "com/gdps/module/publishres/PublishResModule.swf";
		public static const publishClientType:String = "com/gdps/module/publishclient/PublishClientModule.swf";
		public static const publishServerType:String = "com/gdps/module/publishserver/PublishServerModule.swf";
		public static const userManagerType:String = "com/gdps/module/system/UserManageModule.swf";
		public static const roleManagerType:String = "com/gdps/module/system/RoleManageModule.swf";
		public static const productManagerType:String = "com/gdps/module/system/ProductManageModule.swf";
		public static const serverManagerType:String = "com/gdps/module/system/ServerManageModule.swf";
		
		private function initData():void
		{
			stateList = [];
			scopeList = [];
			
			scopeList[base_data_type] = "基础数据更新";
			scopeList[res_data_type] = "RES资源更新";
			scopeList[client_data_type] = "客户端更新";
			scopeList[server_data_type] = "服务端更新";
			
			stateList[1] = "未检测";
			stateList[2] = "已检测未打包";
			stateList[3] = "已打包未发布";
			stateList[4] = "已更新测试服";
			stateList[5] = "已更新体验服";
			stateList[6] = "已发布正式服";
			stateList[9] = "禁用（当前类型的版本禁用）";
		}
		
		public static var msgInfo:String = "";
		
		public function getXMLSocketData(msgHead:String):GDPSXmlSocketData
		{
			var dat:GDPSXmlSocketData = new GDPSXmlSocketData();
			dat.addItem(msgHead);
			return dat;
		}
		
		public function sendXMLSocketData(buf:GDPSXmlSocketData):void
		{
			SandyManagerBase.getInstance().iXMLSocket.send(buf);
		}
		
		/**
		 * 注册flash xmlsocket
		 * @param clientType 注册的客户端类型
		 * 
		 */
		public function registerXMLSocket(clientType:String):void
		{
			var buf:GDPSXmlSocketData = getXMLSocketData(GdpsXmlSocketConst.register_msg);
			buf.addItem(GdpsXmlSocketConst.received_msg);
			buf.addItem(GDPSDataManager.getInstance().getUserInfo.jsessionid);
			buf.addItem(clientType);
			buf.addItem("注册消息内容~~~~~~~");
			sendXMLSocketData(buf);
		}
	}
}