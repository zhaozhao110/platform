package com.editor.module_sea.manager
{
	import com.editor.component.LogContainer;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.module_sea.view.SeaMapItemView;
	import com.editor.module_sea.vo.SeaMapData;
	import com.editor.module_sea.vo.SeaMapLevelVO;
	import com.editor.module_sea.vo.project.SeaMapProjectItemVO;

	public class SeaMapModuleManager
	{
		public function SeaMapModuleManager()
		{
		}
		
		public static var currProject:SeaMapProjectItemVO;
		public static var logCont:LogContainer;
		public static var mapData:SeaMapData;
		public static var selectlevel:SeaMapLevelVO;
		public static var downMapItem:SeaMapItemView;
		
	}
}