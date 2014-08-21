package com.editor.module_mapIso.popview
{
	import com.editor.component.controls.UILabel;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.vo.MapIsoMapData;

	public class MapInfoPopView extends MapIsoPopViewBase
	{
		public function MapInfoPopView()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		override protected function get titles():String
		{
			return "地图信息";	
		}
		
		public static var instance:MapInfoPopView;
		
		private var size_ti:UILabel;
		private var tile_ti:UILabel;
		private var tileLen_ti:UILabel;
		
		override protected function create_init():void
		{
			width = 225;
			height = 198;
			super.create_init();
				
			size_ti = new UILabel();
			size_ti.height = 25;
			addContent(size_ti);
			
			tile_ti = new UILabel();
			tile_ti.height = 25;
			addContent(tile_ti);
			
			tileLen_ti = new UILabel();
			tileLen_ti.height = 25;
			addContent(tileLen_ti);
		}
		
		public function reflashMapInfo():void
		{
			var obj:MapIsoMapData = MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata;
			size_ti.text = "宽：" + obj.mapWidth +"高：" + obj.mapHeight;
			tile_ti.text = "网格宽度：" + obj.cellWidth +"网格高度：" + obj.cellHeight
			tileLen_ti.text = "横向节点：" + obj.col +"纵向节点：" + obj.row
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			reflashMapInfo()
		}
	}
}