package com.editor.vo.dict
{
	public class DictItemVO
	{
		public function DictItemVO(obj:Object=null)
		{
			if(obj == null) return 
			group_id = obj.id
			key = obj.key;
			value = obj.value;
		}
		
		public var group_id:int;
		public var key:*;
		public var value:*;
	}
}