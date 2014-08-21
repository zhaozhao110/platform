package com.editor.moudule_drama.vo.project
{
	public class DramaProjectListVO
	{
		public function DramaProjectListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.project){
				var item:DramaProjectItemVO = new DramaProjectItemVO(p);
				list.push(item);
			}
		}
		
		public function getProjectItemByType(tp:String):DramaProjectItemVO
		{
			for(var i:int=0;i<list.length;i++)
			{
				if(DramaProjectItemVO(list[i]).data == tp){
					return DramaProjectItemVO(list[i]);
				}
			}
			return null;
		}
	}
}