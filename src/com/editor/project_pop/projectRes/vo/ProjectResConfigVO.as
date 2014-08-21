package com.editor.project_pop.projectRes.vo
{
	import com.editor.module_roleEdit.vo.project.RoleEditProjectListVO;
	import com.sandy.error.SandyError;

	public class ProjectResConfigVO
	{
		public function ProjectResConfigVO(x:XML)
		{
			if(instance != null){
				SandyError.error("instance must only");
			}
			instance = this;
			parser(x);
		}
		
		public static var instance:ProjectResConfigVO ;
		
		public var project_ls:ProjectResListVO;
		public var serverDomain:String;
		
		private function parser(x:XML):void
		{
			serverDomain = XML(x.child("serverDomain")[0]).text();
			project_ls = new ProjectResListVO(XML(x.child("projects")[0]))
		}
		
	}
}