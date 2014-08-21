package com.editor.module_map.vo.project
{
	public class MapEditorProjectListVO
	{
		public function MapEditorProjectListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.project){
				var item:MapEditorProjectItemVO = new MapEditorProjectItemVO(p);
				list.push(item);
			}
		}
		
		public function getProjectItemByType(tp:String):MapEditorProjectItemVO
		{
			for(var i:int=0;i<list.length;i++)
			{
				if(MapEditorProjectItemVO(list[i]).data == tp){
					return MapEditorProjectItemVO(list[i]);
				}
			}
			return null;
		}
	}
}