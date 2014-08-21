package com.editor.module_api.manager
{
	import com.air.event.AIREvent;
	import com.air.sql.SQLiteDBHelper;
	import com.air.sql.SqlConn;
	import com.editor.module_api.EditorApiFacade;
	import com.editor.module_api.event.ApiEvent;
	import com.sandy.event.SandyEvent;
	import com.sandy.manager.SandyManagerBase;
	
	import flash.data.SQLResult;
	import flash.filesystem.File;
	
	public class ApiSqlConn extends SandyManagerBase
	{
		private static var instance:ApiSqlConn ;
		public static function getInstance():ApiSqlConn{
			if(instance == null){
				instance = new ApiSqlConn();
			}
			return instance;
		}
		
		
		
		public static const api_local_url:String = File.applicationDirectory.nativePath+File.separator+"assets"+File.separator+"api";
				
		private var conn:SqlConn;
		public var sqlHelper:SQLiteDBHelper;
		
		public function connSql():void
		{
			if(conn == null){
				conn = new SqlConn();
				conn.addEventListener(AIREvent.SQLConn_suc_event,connSucHandle);
				conn.addEventListener(AIREvent.SQLConn_fault_event,connFaultHandle)
			}
		
			var s:String = "/0ip2YhUE1xIw6gCLara3Q=="
			conn.connSql(api_local_url,s);
		}
		
		public function closeSql():void
		{
			if(conn!=null){
				conn.closeSql();
			}
			conn = null
		}
		  
		private function connSucHandle(e:SandyEvent):void
		{
			sqlHelper = new SQLiteDBHelper();
			sqlHelper.setConnect(conn.conn);
			EditorApiFacade.getInstance().moduleFacade.sendNotification(ApiEvent.api_connect_event);
		}
		
		private function connFaultHandle(e:SandyEvent):void
		{
			EditorApiFacade.getInstance().moduleFacade.sendNotification(ApiEvent.api_error_event);
		}
		
		public function executeStatement(pStatement:String):SQLResult
		{
			return conn.executeStatement(pStatement);
		}
		
	}
}