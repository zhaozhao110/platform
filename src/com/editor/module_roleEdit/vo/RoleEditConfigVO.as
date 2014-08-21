package com.editor.module_roleEdit.vo
{
	import com.editor.module_roleEdit.vo.project.RoleEditProjectListVO;
	import com.sandy.error.SandyError;

	public class RoleEditConfigVO
	{
		public function RoleEditConfigVO(x:XML)
		{
			if(instance != null){
				SandyError.error("instance must only");
			}
			instance = this;
			parser(x);
		}
		
		public static var instance:RoleEditConfigVO ;
		
		public var project_ls:RoleEditProjectListVO;
		public var serverDomain:String;
		
		private function parser(x:XML):void
		{
			serverDomain = XML(x.child("serverDomain")[0]).text();
			project_ls = new RoleEditProjectListVO(XML(x.child("projects")[0]))
		}
		
		
	}
}