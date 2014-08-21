package com.editor.module_mapIso.manager
{
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map.vo.project.MapEditorProjectItemVO;
	import com.editor.module_map.vo.project.MapEditorProjectListVO;
	import com.editor.module_mapIso.mediator.MapEditorIsoModuleMediator;
	import com.editor.module_mapIso.mediator.MapEditorIsoTopContainerMediator;
	import com.editor.module_mapIso.mediator.MapIsoBottomContainerMediator;
	import com.editor.module_mapIso.view.layers.BuildingLayer;
	import com.editor.module_mapIso.view.layers.GridLayer;
	import com.editor.module_mapIso.view.layers.MapLayer;
	import com.editor.module_mapIso.view.layers.RoadPointLayer;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.MapUtils;
	
	import flash.geom.Point;
	

	public class MapEditorIsoManager extends SandyManagerBase
	{
		private static var instance:MapEditorIsoManager;
		public static function getInstance():MapEditorIsoManager
		{
			if(instance == null){
				instance = new MapEditorIsoManager();
			}
			return instance;
		}
		
		/**当前项目**/
		public static var currProject:MapEditorProjectItemVO;
		/**当前选中编辑的场景**/
		public static var currentSelectedSceneItme:AppMapDefineItemVO;
		
		
		public static var mapLayer:MapLayer;
		public static var gridLayer:GridLayer;
		public static var buildingLayer:BuildingLayer;//建筑层
		public static var roadPointLayer:RoadPointLayer;//路点层
		
		public static var bottomContainerMediator:MapIsoBottomContainerMediator;
		public static var topContainerMediator:MapEditorIsoTopContainerMediator;
		public static var moduleMediator:MapEditorIsoModuleMediator;
		
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
			return MapUtils.getCellPoint(px,py,currentSelectedSceneItme.mapXMLdata.cellWidth,currentSelectedSceneItme.mapXMLdata.cellHeight).getPoint();	
		}
		
		
		
		
		
	}
}