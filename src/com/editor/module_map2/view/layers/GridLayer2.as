package com.editor.module_map2.view.layers
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	
	import flash.display.Shape;

	public class GridLayer2 extends UICanvas
	{
		private var _gridLineColor:uint = 0xbbbbbb;//线条颜色
		private var grid:Shape;
		
		//画制网格
		public function drawGrid():void
		{
			var d:MapIsoMapData = MapEditor2Manager.currentSelectedSceneItem.mapXMLdata;
			width = d.mapWidth;
			height = d.mapHeight;
						
			if(grid == null){
				grid = new Shape();
				addChild(grid);
			}
			
			grid.graphics.clear();
			grid.graphics.lineStyle(1, _gridLineColor, 1);
			
			for(var i:int=0;i<d.col;i++)
			{
				grid.graphics.moveTo(i*d.cellWidth,0);
				grid.graphics.lineTo(i*d.cellWidth,d.mapHeight);
			}
			
			for(i=0;i<d.row;i++)
			{
				grid.graphics.moveTo(0,i*d.cellHeight);
				grid.graphics.lineTo(d.mapWidth,i*d.cellHeight)
			}
		}
		
	}
}