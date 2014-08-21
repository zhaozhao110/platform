package com.editor.module_sea.vo
{
	import com.editor.module_roleEdit.vo.project.RoleEditProjectListVO;
	import com.editor.module_sea.vo.project.SeaMapProjectListVO;
	import com.sandy.error.SandyError;

	public class SeaMapConfigVO
	{
		public function SeaMapConfigVO(x:XML)
		{
			if(instance != null){
				SandyError.error("instance must only");
			}
			instance = this;
			parser(x);
		}
		
		public static var instance:SeaMapConfigVO ;
		
		public var project_ls:SeaMapProjectListVO;
		public var serverDomain:String;
		
		private function parser(x:XML):void
		{
			serverDomain = XML(x.child("serverDomain")[0]).text();
			project_ls = new SeaMapProjectListVO(XML(x.child("projects")[0]))
		}
		
		
	}
}