package com.editor.vo.project
{
	import com.editor.vo.global.AppGlobalConfig;

	public class AppProjectItemVO
	{
		public function AppProjectItemVO(x:Object=null)
		{
			if(x == null) return ;
			label = x.name;
			data = x.en;
		}
		
		public var label:String;
		public var data:String;
		public function get name():String
		{
			return label;
		}
		
		public function getLabel():void
		{
			label = AppGlobalConfig.instance.projects.getProjectName(data);
		}
	}
}