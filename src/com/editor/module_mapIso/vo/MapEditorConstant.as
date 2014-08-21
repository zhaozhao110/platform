package com.editor.module_mapIso.vo
{
	import flash.filesystem.File;
	
	public class MapEditorConstant
	{
		public function MapEditorConstant()
		{
		}
		
		//地图格类型 空白低点 最后会根据设置 转换为相应不可移动或者可移动区域
		public static const CELL_TYPE_SPACE:int = 0;
		//地图格类型 路点
		public static const CELL_TYPE_ROAD:int = 1;
		//地图格类型 障碍
		public static const CELL_TYPE_HINDER:int = 2;
		//透明
		public static const CELL_TYPE_ALPHA:int = 3;
		//阶梯
		public static const CELL_TYPE_ladder:int = 4;
		
		//保存时将空白区域转换为路点
		public static const TYPE_SAVE_MAP_ROAD:int = 0;
		//保存时将空白区域转换为障碍
		public static const TYPE_SAVE_MAP_HINDER:int = 1;
		
		
		/**1:路点 **/
		public static const mouseMode_1:int = 1;
		/**2：障碍 **/
		public static const mouseMode_2:int = 2;
		/**,103:透明 **/
		public static const mouseMode_103:int = 103;
		/** 4:放置建筑 **/
		public static const mouseMode_4:int = 4;
		/**3:取消路点 **/
		public static const mouseMode_3:int = 3;
		/**阶梯 **/
		public static const mouseMode_5:int = 5;
		//框选
		public static const mouseMode_6:int = 6;
		
	}
}