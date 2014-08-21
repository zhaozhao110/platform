package com.editor.vo.stacks
{
	public class StackDataVO
	{
		public function StackDataVO(obj:Object=null)
		{
			if(obj == null) return ;
			id = int(obj.id);
			name = obj.name;
			isStacks = Boolean(obj.isStacks);
			power = String(obj.power).split(",");
		}
		
		public var power:Array;
		public var id:int;
		public var name:String;
		public var isStacks:Boolean;
	}
}