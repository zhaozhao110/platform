package com.editor.module_skill.vo.project
{
	public class EditSkillProjectListVO
	{
		public function EditSkillProjectListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.project){
				var item:EditSkillProjectItemVO = new EditSkillProjectItemVO(p);
				list.push(item);
			}
		}
		
		public function getProjectItemByType(tp:String):EditSkillProjectItemVO
		{
			for(var i:int=0;i<list.length;i++)
			{
				if(EditSkillProjectItemVO(list[i]).data == tp){
					return EditSkillProjectItemVO(list[i]);
				}
			}
			return null;
		}
	}
}