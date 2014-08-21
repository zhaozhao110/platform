package com.editor.module_roleEdit.vo.motion
{
	public class AppMotionListVO
	{
		public function AppMotionListVO(x:XML)
		{
			parserXML(x)
		}
		
		public var all_ls:Array = [];;
		
		private function parserXML(x:XML):void
		{
			for each(var p:XML in x.i)
			{
				var g:AppMotionItemVO = new AppMotionItemVO(p);
				all_ls[g.id] = g;
			}	
		}
		
		public function getMotionById(id:int):AppMotionItemVO
		{
			return all_ls[id] as AppMotionItemVO;
		}
		
		
		
	}
}