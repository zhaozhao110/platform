package com.editor.module_sea.vo.project
{
	public class SeaMapProjectListVO
	{
		public function SeaMapProjectListVO(x:XML)
		{
			parser(x);
		}
		
		public var list:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.project){
				var item:SeaMapProjectItemVO = new SeaMapProjectItemVO(p);
				list.push(item);
			}
		}
		
		public function getProjectItemByType(tp:String):SeaMapProjectItemVO
		{
			for(var i:int=0;i<list.length;i++)
			{
				if(SeaMapProjectItemVO(list[i]).data == tp){
					return SeaMapProjectItemVO(list[i]);
				}
			}
			return null;
		}
		
		
	}
}