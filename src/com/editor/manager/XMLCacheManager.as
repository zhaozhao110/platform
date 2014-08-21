package com.editor.manager
{
	public class XMLCacheManager
	{
		public function XMLCacheManager()
		{
		}
		
		private static var list:Array = [];
		
		public static function add(xml:String,moduleName:String):void
		{
			if(list[xml] == null){
				list[xml] = new XMLCache(xml);
			}
			(list[xml] as XMLCache).add(moduleName);
		}
		
		public static function getXML(xml:String):XMLCache
		{
			return list[xml] as XMLCache;
		}
		
	}
}