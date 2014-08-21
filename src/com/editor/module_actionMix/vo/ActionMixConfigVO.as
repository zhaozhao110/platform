package com.editor.module_actionMix.vo
{
	import com.editor.module_actionMix.vo.project.ActionMixProjectListVO;
	import com.sandy.error.SandyError;
	import com.sandy.manager.data.SandyXMLListVO;

	public class ActionMixConfigVO
	{
		public function ActionMixConfigVO(x:XML)
		{
			if(instance != null){
				SandyError.error("instance must only");
			}
			instance = this;
			parser(x);
		}
		
		public static var instance:ActionMixConfigVO;
		
		public var serverDomain:String;
		public var project_ls:ActionMixProjectListVO;
		
		private function parser(xml:XML):void
		{
			
			serverDomain = XML(xml.child("serverDomain")[0]).toString();
			
			project_ls = new ActionMixProjectListVO(XML(xml.child("projects")[0]))
			
		}
	}
}