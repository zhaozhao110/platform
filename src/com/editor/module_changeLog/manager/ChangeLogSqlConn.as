package com.editor.module_changeLog.manager
{
	import com.air.event.AIREvent;
	import com.air.sql.SQLiteDBHelper;
	import com.air.sql.SqlConn;
	import com.editor.manager.DataManager;
	import com.editor.model.AppMainModel;
	import com.editor.module_changeLog.event.ChangeLogEvent;
	import com.editor.services.Services;
	import com.sandy.event.SandyEvent;
	import com.sandy.manager.SandyManagerBase;
	
	import flash.data.SQLResult;

	public class ChangeLogSqlConn extends SandyManagerBase
	{
		private static var instance:ChangeLogSqlConn ;
		public static function getInstance():ChangeLogSqlConn{
			if(instance == null){
				instance = new ChangeLogSqlConn();
			}
			return instance;
		}
		
				
		private var conn:SqlConn;
		public var sqlHelper:SQLiteDBHelper;
		
		public function connSql():void
		{
			if(conn!=null) return ;
			if(conn == null){
				conn = new SqlConn();
				conn.addEventListener(AIREvent.SQLConn_suc_event,connSucHandle);
				conn.addEventListener(AIREvent.SQLConn_fault_event,connFaultHandle)
			}
			if(AppMainModel.getInstance().user.checkIsSystem()){
				conn.connSql(Services.changeLog_edit_local_url,DataManager.pass);
			}else{
				conn.connSql(Services.changeLog_local_url,DataManager.pass);
			}
		}
		
		public function get connected():Boolean
		{
			if(conn == null) return false;
			return conn.connected;
		}
		
		private function connSucHandle(e:SandyEvent):void
		{
			sqlHelper = new SQLiteDBHelper();
			sqlHelper.setConnect(conn.conn);
			iManager.sendAppNotification(ChangeLogEvent.changeLog_connect_event);
		}
		
		private function connFaultHandle(e:SandyEvent):void
		{
			iManager.sendAppNotification(ChangeLogEvent.changeLog_error_event);
		}
		
		public function executeStatement(pStatement:String):SQLResult
		{
			return conn.executeStatement(pStatement);
		}
		
	}
}