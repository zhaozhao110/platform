package com.editor.module_sea.vo.dict
{
	import com.editor.module_roleEdit.manager.RoleEditManager;
	import com.sandy.manager.data.SandyDictData;

	public class SeaMapDictListVO
	{
		public function SeaMapDictListVO(x:XML):void
		{
			parser(x);
		}
		
		public static var list:Array = [];
		public static var all_ls:Array = [];
		
		public static function parser(x:XML):void
		{
			for each(var p:XML in x.g)
			{
				if(int(p.@i) == RoleEditManager.resType_dict){
					break;					
				}
			}
			
			for each(var pp:XML in p.i)
			{
				var cell:SandyDictData = new SandyDictData(pp);
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