package com.editor.module_map.vo.map
{
	public class AppMapDefineListVO
	{
		public function AppMapDefineListVO(xml:XML)
		{
			parser(xml);
		}
		
		public var mapDefine_ls:Array = [];
		public var all_ls:Array = [];
		private function parser(xml:XML):void{
			for each(var g:XML in xml.g){
				var appMapDefineGroupVO:AppMapDefineGroupVO = new AppMapDefineGroupVO(g,all_ls);
				var type:int = g.@c;
				mapDefine_ls[type] = appMapDefineGroupVO;
			}
		}
		
		public function getList():Array
		{
			var out:Array = [];
			for each(var item:AppMapDefineItemVO in all_ls){
				if(item!=null){
					out.push(item);
				}
			}
			return out.sortOn("id",Array.NUMERIC);
		}
		
		public function getMapDefineItemVoById(id:int):AppMapDefineItemVO{
			return all_ls[id.toString()] as AppMapDefineItemVO;
		}
		/**根据类型得到地图数组**/
		public function getMapDefineAry(type:int):Object{
			return mapDefine_ls[type].itemVo_ls;
		}
	}
}