package com.editor.module_map.vo.map
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_mapIso.vo.MapIsoMapData;

	public class AppMapDefineItemVO
	{
		public function AppMapDefineItemVO(i:XML=null)
		{
			if(i!=null) parser(i);
		}
		
		public var id:int;
		public var type:int;
		public var name:String;
		public var limit:String;
		
		public var mapXMLdata:MapIsoMapData;
		
		/**
		 * g:地图大节点
      c:地图分类(详见数据字典定义 1-主城场景 2-关卡副本场景)
   i:地图小节点
      i:地图ID
      n:地图名称
      a:可行走区域(x_y_w_h 中间用_分隔)
      h:战斗中隐藏前层(1:隐藏 0或空:不隐藏)

		 */
		public var hideInBattle:Boolean;
		public var name1:String;
		
		
		private function parser(i:XML):void{
			id 		= int(i.@i);
			name 	= String(i.@n);
			limit	= String(i.@c);
			hideInBattle = int(i.@h)==1?true:false;
			name1 = id + "/" + name;
		}
		
		
		
	}
}