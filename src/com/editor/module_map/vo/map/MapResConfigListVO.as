package com.editor.module_map.vo.map
{
	public class MapResConfigListVO
	{
		public var list:Array = [];
		public function MapResConfigListVO(x:XML)
		{
			parser(x);
		}
		
		private function parser(x:XML):void
		{
			for each(var itmeX:XML in x.g)
			{
				parserSub(itmeX);
			}
		}
		
		private function parserSub(x:XML):void
		{
			for each(var itemX:XML in x.i)
			{
				var vo:MapResConfigItemVO = new MapResConfigItemVO(itemX);								
				vo.type = x.@c;
				
				list.push(vo);
				
			}
		}
		/**获取资源配置**/
		public function getItemById(id:int):MapResConfigItemVO
		{
			var outVO:MapResConfigItemVO;
			
			var len:int = list.length;
			for(var i:int=0;i<len;i++)
			{
				var vo:MapResConfigItemVO = list[i] as MapResConfigItemVO;
				if(vo && vo.id == id)
				{
					outVO = vo;
					break;
				}
			}
			
			return outVO;
		}
		/**获取当前地图所有资源配置**/
		public function getListByMap(mapid:int):Array
		{
			var a:Array = [];
			
			var len:int = list.length;
			for(var i:int=0;i<len;i++)
			{
				var v:MapResConfigItemVO = list[i] as MapResConfigItemVO;
				if(v && v.mapId == mapid)
				{
					a.push(v);
				}
			}
			
			return a;			
		}
		
		
	}
}