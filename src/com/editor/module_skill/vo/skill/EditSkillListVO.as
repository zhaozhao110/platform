package com.editor.module_skill.vo.skill
{
	public class EditSkillListVO
	{
		public function EditSkillListVO(x:XML)
		{
			parser(x)
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.g){
				var item:EditSkillItemVO = new EditSkillItemVO(p);
				list.push(item);
			}
		}
	}
}