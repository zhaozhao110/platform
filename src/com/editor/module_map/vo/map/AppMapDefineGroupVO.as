package com.editor.module_map.vo.map
{
	public class AppMapDefineGroupVO
	{
		public function AppMapDefineGroupVO(g:XML,al_ls:Array)
		{
			parser(g,al_ls);
		}
		
		public var itemVo_ls:Object = {};
		private function parser(g:XML,all_ls:Array):void{
			for each(var i:XML in g.i){
				var itemVo:AppMapDefineItemVO = new AppMapDefineItemVO(i);
				itemVo.type = int(g.@c);
				itemVo_ls[itemVo.id] = itemVo;
				all_ls[itemVo.id.toString()] = itemVo;
			}
		}
		
		public function getMapDefineItemVoById(id:int):AppMapDefineItemVO{
			return itemVo_ls[id];
		}
	}
}