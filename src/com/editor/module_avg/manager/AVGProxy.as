package com.editor.module_avg.manager
{
	import com.air.sql.ConnLocalSqlManager;
	import com.editor.module_avg.vo.attri.AVGComAttriListVO;
	import com.editor.module_avg.vo.comp.AVGCompListVO;
	
	import flash.data.SQLResult;

	public class AVGProxy
	{
		public static const NAME:String = "AppComponentProxy"
		
		public function AVGProxy()
		{
			if(instance!=null) return ;
			instance = this;
		}
		
		public static var instance:AVGProxy;
		
		public function load():void
		{
			var statement:String = "select * from avg_attri";
			var res:SQLResult = ConnLocalSqlManager.getInstance().executeStatement(statement);
			attri_ls = new AVGComAttriListVO(res.data as Array);
			
			statement = "select * from avg_comp";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			com_ls = new AVGCompListVO(res.data as Array);
		}
		
		public var com_ls:AVGCompListVO;
		public var attri_ls:AVGComAttriListVO;
		
	}
}