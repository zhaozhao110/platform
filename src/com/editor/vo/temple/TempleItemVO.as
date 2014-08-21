package com.editor.vo.temple
{
	public class TempleItemVO
	{
		public function TempleItemVO(obj:Object)
		{
			id = int(obj.id);
			data = obj.data;
		}
		
		public var id:int;
		public var data:String;
	}
}