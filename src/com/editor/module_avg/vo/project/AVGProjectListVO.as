package com.editor.module_avg.vo.project
{
	public class AVGProjectListVO
	{
		public function AVGProjectListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.project){
				var item:AVGProjectItemVO = new AVGProjectItemVO(p);
				list.push(item);
			}
		}
		
		public function getProjectItemByType(tp:String):AVGProjectItemVO
		{
			for(var i:int=0;i<list.length;i++)
			{
				if(AVGProjectItemVO(list[i]).data == tp){
					return AVGProjectItemVO(list[i]);
				}
			}
			return null;
		}
	}
}