package com.editor.module_roleEdit.vo.project
{
	public class RoleEditProjectListVO
	{
		public function RoleEditProjectListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.project){
				var item:RoleEditProjectItemVO = new RoleEditProjectItemVO(p);
				list.push(item);
			}
		}
		
		public function getProjectItemByType(tp:String):RoleEditProjectItemVO
		{
			for(var i:int=0;i<list.length;i++)
			{
				if(RoleEditProjectItemVO(list[i]).data == tp){
					return RoleEditProjectItemVO(list[i]);
				}
			}
			return null;
		}
		
		
	}
}