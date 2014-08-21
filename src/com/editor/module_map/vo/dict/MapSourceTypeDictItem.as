package com.editor.module_map.vo.dict
{
	import com.sandy.common.lang.StringUtils;
	import com.sandy.manager.data.SandyData;
	import com.sandy.utils.ToolUtils;

	public class MapSourceTypeDictItem extends SandyData
	{
		public function MapSourceTypeDictItem(x:XML = null)
		{
			if(x==null) return 
			
			key = String(x.@c)
			value = String(x.@v);
			if(!StringUtils.isWhitespace(x.@a)){
				attri_ls = String(x.@a).split(",");
			}
		}
		
		public var attri_ls:Array = []
		
		
		public function parserAttri():void
		{
			var a:Array = [];
			for(var i:int=0;i<attri_ls.length;i++)
			{
				var type:String = attri_ls[i];
				a.push(MapSourceAttriDictList.getItem(type))
			}
			attri_ls = null
			attri_ls = a;
		}
		
		public function clone():MapSourceTypeDictItem
		{
			var it:MapSourceTypeDictItem = new MapSourceTypeDictItem();
			ToolUtils.clone(this,it);
			return it;
		}
		
	}
}