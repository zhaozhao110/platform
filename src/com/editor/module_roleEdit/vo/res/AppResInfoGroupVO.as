package com.editor.module_roleEdit.vo.res
{
	import com.editor.module_roleEdit.vo.dict.RoleEditResTypeListVO;

	public class AppResInfoGroupVO
	{
		public function AppResInfoGroupVO(x:XML,all_ls:Array)
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
			type_str = RoleEditResTypeListVO.getValue(_type);
		}
		
		public var type_str:String;
				
		private function parser(x:XML,all_ls:Array):void
		{
			type = Number(x.@c);
			
			for each(var p:XML in x.i)
			{
				var item:AppResInfoItemVO = new AppResInfoItemVO(p,type)
				item_ls.push(item);
				all_ls[item.id] = item;
			}
		}
		
		
	}
}