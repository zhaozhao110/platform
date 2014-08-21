package com.editor.module_roleEdit.vo.dict
{
	import com.editor.module_roleEdit.manager.RoleEditManager;

	public class RoleEditDictListVO
	{
		public function RoleEditDictListVO(x:XML)
		{
			parser(x)
		}
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.g)
			{
				if(int(p.@i) == RoleEditManager.resType_dict)
				{
					//资源类型
					RoleEditResTypeListVO.parser(p);
				}
			}
			
		}
	}
}