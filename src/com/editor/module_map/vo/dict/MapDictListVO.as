package com.editor.module_map.vo.dict
{
	
	public class MapDictListVO
	{
		public function MapDictListVO(x:XML)
		{
			parser(x)
		}
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.g)
			{
				if(int(p.@i) == 17)
				{
					//地图资源属性
					MapSourceAttriDictList.parser(p);
				}
			}
			
			MapSourceTypeDictList.parserAttri();
		}
	}
}