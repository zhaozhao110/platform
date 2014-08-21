package com.editor.proxy
{
	import com.air.io.ReadFile;
	import com.air.sql.ConnLocalSqlManager;
	import com.editor.module_ui.vo.attri.ComAttriListVO;
	import com.editor.module_ui.vo.component.ComListVO;
	import com.editor.module_ui.vo.style.ComStyleListVO;
	import com.editor.vo.xml.AppXMLListVO;
	import com.sandy.component.controls.SandyLoader;
	
	import flash.data.SQLResult;

	public class AppComponentProxy extends AppProxy
	{
		public static const NAME:String = "AppComponentProxy"
		
		public function AppComponentProxy()
		{
			super(NAME);
			if(instance!=null) return ;
			instance = this;
		}
		
		public static var instance:AppComponentProxy;
		
		public function load():void
		{
			
			statement = "select * from com_attri";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			attri_ls = new ComAttriListVO(res.data as Array);
			
			statement = "select * from com_style";
			res = ConnLocalSqlManager.getInstance().executeStatement(statement);
			style_ls = new ComStyleListVO(res.data as Array);
			
			var statement:String = "select * from component";
			var res:SQLResult = ConnLocalSqlManager.getInstance().executeStatement(statement);
			com_ls = new ComListVO(res.data as Array);
			
		}
		
		public var com_ls:ComListVO;
		public var attri_ls:ComAttriListVO;
		public var style_ls:ComStyleListVO;
		
		//获取有样式的组件
		public function getListHaveStyle():Array
		{
			return com_ls.getListHaveStyle();
		}
		
	}
}