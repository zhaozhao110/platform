package com.editor.module_sea.vo.res
{

	public class SeaMapResInfoListVO
	{
		public function SeaMapResInfoListVO(x:XML)
		{
			parser(x)
		}
		
		public var group_ls:Array = [];
		public var all_ls:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.g)
			{
				var g:SeaMapResInfoGroupVO = new SeaMapResInfoGroupVO(p,all_ls);
				group_ls.push(g)
			}
		}
		
		public function getResInfoItemByID(ID:Number):SeaMapResInfoItemVO
		{
			return all_ls[ID] as SeaMapResInfoItemVO;
		}
		
		public function getCloneResInfoItemById(id:Number):SeaMapResInfoItemVO
		{
			if(getResInfoItemByID(id)!=null){
				return getResInfoItemByID(id).clone();
			}
			return null;
		}
		
	}
}