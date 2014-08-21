package com.editor.module_skill.vo
{
	import com.editor.module_skill.vo.project.EditSkillProjectListVO;
	import com.sandy.manager.data.SandyXMLListVO;

	public class EditSkillConfigVO
	{
		public function EditSkillConfigVO(x:XML)
		{
			instance = this
			parser(x);
		}
		
		public static var instance:EditSkillConfigVO;
		
		public var serverDomain:String;
		public var project_ls:EditSkillProjectListVO;
		
		private function parser(xml:XML):void
		{
			serverDomain = XML(xml.child("serverDomain")[0]).toString();
			
			project_ls = new EditSkillProjectListVO(XML(xml.child("projects")[0]))
		}
	}
}