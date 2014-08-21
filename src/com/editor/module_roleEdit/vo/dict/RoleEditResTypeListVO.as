package com.editor.module_roleEdit.vo.dict
{
	import com.sandy.manager.data.SandyDictData;

	public class RoleEditResTypeListVO
	{
		public function RoleEditResTypeListVO()
		{
		}
		
		public static var list:Array = [];
		public static var all_ls:Array = [];
		
		public static function parser(x:XML):void
		{
			for each(var p:XML in x.i)
			{
				var cell:SandyDictData = new SandyDictData(p);
				list[cell.c] = cell;
				all_ls.push(cell);
			}
		}
		
		public static function getValue(id:*):String
		{
			if(list[id] == null) return "";
			return SandyDictData(list[id]).v;
		}
		
		public static function getItem(id:*):SandyDictData
		{
			return SandyDictData(list[id]);
		}
	}
}