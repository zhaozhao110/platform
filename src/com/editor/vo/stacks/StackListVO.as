package com.editor.vo.stacks
{
	public class StackListVO
	{
		public function StackListVO(a:Array)
		{
			for(var i:int=0;i<a.length;i++){
				var obj:Object = a[i];
				var d:StackDataVO = new StackDataVO(obj);
				if(d.isStacks){
					stack_ls.push(d)
				}
				all_ls.push(d);
				hash_ls[d.id.toString()] = d;
			}
		}
		
		private var hash_ls:Array = [];
		public var all_ls:Array = [];
		public var stack_ls:Array = [];
		
		public function getData(id:int):StackDataVO
		{
			return hash_ls[id.toString()] as StackDataVO;
		}
		
		
	}
}