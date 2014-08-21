package com.editor.project_pop.projectRes.vo
{
	import com.editor.vo.project.AppProjectItemVO;

	public class ProjectResItemVO extends AppProjectItemVO
	{
		public function ProjectResItemVO(x:XML)
		{
			parser(x)
		}
		
		public var swf_ls:Array = [];
		public var fla_ls:Array = [];
		public var saveURL:String;
		public var config3:String;
		
		private function parser(x:XML):void
		{
			data = XMLList(x.@d)[0].toString();
			getLabel();
						
			var swfList:String = XML(x.child("swflist")[0]).toString();
			swf_ls = swfList.split(",");
			
			var flalist:String = XML(x.child("flalist")[0]).toString();
			fla_ls = flalist.split(",");
			
			saveURL = XML(x.child("save")[0]).toString();
			config3 = XML(x.child("config3")[0]).toString();
		}
	}
}