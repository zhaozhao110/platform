package com.editor.module_map.vo.map
{
	public class MapResConfigItemVO
	{		
		/**ID**/
		public var id:int;		
		/**资源ID**/
		public var sourceId:int;
		/**资源类型 1-npc 2-传送点**/
		public var type:int;
		/**资源名称**/
		public var name:String;		
		/**所在地图ID**/
		public var mapId:int;
		public function MapResConfigItemVO(x:XML)
		{
			parser(x);
		}
		
		private function parser(x:XML):void
		{
			id = Number(x.@i);
			sourceId = int(x.@q);
			mapId = int(x.@m);
			name = String(x.@n);		
		}
		
		public function get name1():String
		{
			return id + " / " + name;
		}
		
		
	}
}