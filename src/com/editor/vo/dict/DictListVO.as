package com.editor.vo.dict
{
	import com.air.sql.ConnLocalSqlManager;
	
	import flash.data.SQLResult;

	public class DictListVO
	{
		public function DictListVO()
		{
		}
		
		public static var list:Array = [];
		public static var all_ls:Array = [];
		
		public static var dict_ls:DictListVO
		
		public static function parser():void
		{
			var statement:String = "select * from data";
			var res:SQLResult = ConnLocalSqlManager.getInstance().executeStatement(statement);
			
			var a:Array = res.data as Array;
			for(var i:int=0;i<a.length;i++){
				var item:DictItemVO = new DictItemVO(a[i]);
				var g:DictGroupVO;
				if(getGroup(item.group_id)==null){
					g = new DictGroupVO();
					g.id = item.group_id;
					list[g.id.toString()] = g;
				}else{
					g = getGroup(item.group_id);
				}
				g.addItem(item);
				all_ls[item.group_id.toString()] = item;
			}
		}
		
		public static function getGroup(groupId:int):DictGroupVO
		{
			return list[groupId.toString()] as DictGroupVO
		}
	}
}