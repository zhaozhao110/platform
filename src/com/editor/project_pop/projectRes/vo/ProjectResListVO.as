package com.editor.project_pop.projectRes.vo
{
	import com.editor.module_roleEdit.vo.project.RoleEditProjectItemVO;

	public class ProjectResListVO
	{
		public function ProjectResListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.project){
				var item:ProjectResItemVO = new ProjectResItemVO(p);
				list.push(item);
			}
		}
		
		public function getProjectItemByType(tp:String):ProjectResItemVO
		{
			for(var i:int=0;i<list.length;i++)
			{
				if(ProjectResItemVO(list[i]).data == tp){
					return ProjectResItemVO(list[i]);
				}
			}
			return null;
		}
	}
}