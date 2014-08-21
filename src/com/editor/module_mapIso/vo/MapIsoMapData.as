package com.editor.module_mapIso.vo
{
	public class MapIsoMapData
	{
		public function MapIsoMapData()
		{
		}
		
		public var mapWidth:Number;//地图宽度
		public var mapHeight:Number;//地图高度
		public var cellWidth:Number;//单元格宽度
		public var cellHeight:Number;//单元格高度
		/** 地图横向节点数  有多少列**/
		public var col:int;
		/** 地图纵向节点数  有多少行**/
		public var row:int;
		public var mapArr:Array;
		public var xml:XML;
		
		public var backImage_file:String;
		
		
		
	}
}