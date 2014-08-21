package com.editor.vo.dict
{
	public class DictGroupVO
	{
		public function DictGroupVO()
		{
		}
		
		public var id:int;
		public var list:Array = [];
		
		public function parser():void
		{
			
		}
		
		public function addItem(item:DictItemVO):void
		{
			list.push(item);
		}
		
		public function getValue(key:*):*
		{
			for(var i:int=0;i<list.length;i++){
				if(DictItemVO(list[i]).key == key){
					return DictItemVO(list[i]).value;
				}
			}
			return null;
		}
		
		
	}
}