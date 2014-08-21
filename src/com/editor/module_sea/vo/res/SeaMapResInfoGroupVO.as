package com.editor.module_sea.vo.res
{
	import com.editor.module_roleEdit.vo.dict.RoleEditResTypeListVO;
	import com.editor.module_sea.vo.dict.SeaMapDictListVO;

	public class SeaMapResInfoGroupVO
	{
		public function SeaMapResInfoGroupVO(x:XML,all_ls:Array)
		{
			parser(x,all_ls);
		}
		
		public var item_ls:Array = [];
		
		//(1:怪物 2:NPC 3:采集物)
		private var _type:Number;
		public function get type():Number
		{
			return _type;
		}
		public function set type(value:Number):void
		{
			_type = value;
			type_str = SeaMapDictListVO.getValue(_type);
		}
		
		public var type_str:String;
				
		private function parser(x:XML,all_ls:Array):void
		{
			type = Number(x.@c);
			
			for each(var p:XML in x.i)
			{
				var item:SeaMapResInfoItemVO = new SeaMapResInfoItemVO(p)
				item_ls.push(item);
				all_ls[item.id] = item;
			}
		}
		
		
	}
}