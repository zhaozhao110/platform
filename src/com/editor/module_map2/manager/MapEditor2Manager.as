package com.editor.module_map2.manager
{
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map.vo.project.MapEditorProjectItemVO;
	import com.editor.module_map.vo.project.MapEditorProjectListVO;
	import com.editor.module_map2.mediator.MapEditor2BottomContainerMediator;
	import com.editor.module_map2.mediator.MapEditor2ModuleMediator;
	import com.editor.module_map2.mediator.MapEditor2TopContainerMediator;
	import com.editor.module_map2.view.layers.BuildingLayer2;
	import com.editor.module_map2.view.layers.GridLayer2;
	import com.editor.module_map2.view.layers.MapLayer2;
	import com.editor.module_map2.view.layers.RoadPointLayer2;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.Map2Utils;
	
	import flash.geom.Point;
	

	public class MapEditor2Manager extends SandyManagerBase
	{
		private static var instance:MapEditor2Manager;
		public static function getInstance():MapEditor2Manager
		{
			if(instance == null){
				instance = new MapEditor2Manager();
			}
			return instance;
		}
		
		/**当前项目**/
		public static var currProject:MapEditorProjectItemVO;
		/**当前选中编辑的场景**/
		public static var currentSelectedSceneItem:AppMapDefineItemVO;
		
		
		public static var mapLayer:MapLayer2;
		public static var gridLayer:GridLayer2;
		public static var buildingLayer:BuildingLayer2;//建筑层
		public static var roadPointLayer:RoadPointLayer2;//路点层
		
		public static var bottomContainerMediator:MapEditor2BottomContainerMediator;
		public static var topContainerMediator:MapEditor2TopContainerMediator;
		public static var moduleMediator:MapEditor2ModuleMediator;
		
		public var serverDomain:String;
		public var project_ls:MapEditorProjectListVO;
		public var mapResURL:String
		
		public function parser(xml:XML):void
		{
			serverDomain = XML(xml.child("serverDomain")[0]).toString();
			
			mapResURL = XML(xml.child("mapSwfURL")[0]).toString();
			project_ls = new MapEditorProjectListVO(XML(xml.child("projects")[0]))
		}
		
		public static function getCellPoint(px:Number,py:Number):Point
		{
			return Map2Utils.getCellPoint(px,py,currentSelectedSceneItem.mapXMLdata.cellWidth,currentSelectedSceneItem.mapXMLdata.cellHeight).getPoint();	
		}
		
		
		
		
		
	}
}