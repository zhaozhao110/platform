package com.editor.d3.cache
{
	import com.air.sql.ConnLocalSqlManager;
	import com.editor.d3.vo.attri.D3ComAttriListVO;
	import com.editor.d3.vo.comp.D3CompListVO;
	import com.editor.d3.vo.group.D3GroupListVO;
	import com.editor.d3.vo.method.D3MethodListVO;
	
	import flash.data.SQLResult;

	public class D3ComponentProxy
	{
		private static var instance:D3ComponentProxy ;
		public static function getInstance():D3ComponentProxy{
			if(instance == null){
				instance =  new D3ComponentProxy();
			}
			return instance;
		}
		
		public function load():void
		{
			var statement:String = "select * from d3_attri";
			var res:SQLResult = ConnLocalSqlManager.getInstance().executeStatement(statement);
			attri_ls = new D3ComAttriListVO(res.data as Array);
			
			statement = "select * from d3_group";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			group_ls = new D3GroupListVO(res.data as Array);
			
			statement = "select * from d3_method";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			method_ls = new D3MethodListVO(res.data as Array);
			
			statement = "select * from d3_comp";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			com_ls = new D3CompListVO(res.data as Array);
			
			statement = "select * from particle_attri";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			particle_attri_ls = new D3ComAttriListVO(res.data as Array,true);
			
			statement = "select * from particle_group";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			particle_group_ls = new D3GroupListVO(res.data as Array,true);
		}
		
		public var com_ls:D3CompListVO;
		public var group_ls:D3GroupListVO;
		public var attri_ls:D3ComAttriListVO;
		public var particle_attri_ls:D3ComAttriListVO;
		public var particle_group_ls:D3GroupListVO;
		public var method_ls:D3MethodListVO;
	}
}