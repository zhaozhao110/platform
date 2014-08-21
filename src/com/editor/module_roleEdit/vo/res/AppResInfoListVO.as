package com.editor.module_roleEdit.vo.res
{
	public class AppResInfoListVO
	{
		public function AppResInfoListVO(x:XML)
		{
			parser(x)
		}
		
		public var group_ls:Array = [];
		public var all_ls:Array = [];
		
		private function parser(x:XML):void
		{
			for each(var p:XML in x.g)
			{
				var g:AppResInfoGroupVO = new AppResInfoGroupVO(p,all_ls);
				group_ls.push(g)
			}
		}
		
		public function getResInfoItemByID(ID:Number):AppResInfoItemVO
		{
			return all_ls[ID] as AppResInfoItemVO;
		}
		
		public function getCloneResInfoItemById(id:Number):AppResInfoItemVO
		{
			if(getResInfoItemByID(id)!=null){
				return getResInfoItemByID(id).clone();
			}
			return null;
		}
	}
}