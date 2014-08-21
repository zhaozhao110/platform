package com.editor.module_map.vo.dict
{
	public class MapSourceTypeDictList
	{
		public function MapSourceTypeDictList()
		{
		}
		
		//
		public static var list:Array = [];
		public static var all_ls:Array = [];
		
		public static function parser(x:XML):void
		{
			for each(var p:XML in x.i)
			{
				var cell:MapSourceTypeDictItem = new MapSourceTypeDictItem(p);
				list[cell.key] = cell;
				all_ls.push(cell);
			}
		}
		
		public static function getValue(id:String):String
		{
			return MapSourceTypeDictItem(list[id]).value;
		}
		
		public static function getItem(id:String):MapSourceTypeDictItem
		{
			return MapSourceTypeDictItem(list[id]);
		}
		
		public static function parserAttri():void
		{
			for each(var it:MapSourceTypeDictItem in list)
			{
				it.parserAttri();
			}
		}
		
	}
}