package com.editor.module_mapIso.view.layers
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	
	import flash.display.Shape;

	public class GridLayer extends UICanvas
	{
		private var _mapWidth:int;		//地图网格宽度
		private var _mapHeight:int;		//地图网格高度
		
		private var _tilePixelWidth:int;	//一个网格的象素宽
		private var _tilePixelHeight:int;	//一个网格的象素高
		
		private var _gridLineColor:uint = 0xbbbbbb;//线条颜色
		
		
		private var _wHalfTile:int;	//网格象素宽的一半
		private var _hHalfTile:int;	//网格象素高的一半
		
		
		public function GridLayer()
		{
		}
		
		private var grid:Shape;
		
		//画制网格
		public function drawGrid(mapWidth:int, mapHeight:int, cellWidth:int, cellHeight:int):void
		{
			MapEditorIsoManager.moduleMediator.addLog2("create grid: " + mapWidth + "," + mapHeight + "," + cellWidth + "," + cellHeight);
			_mapWidth = mapWidth;
			_mapHeight = mapHeight;
			_tilePixelWidth = cellWidth;
			_tilePixelHeight = cellHeight;
			//var row:int = _mapHeight/_tilePixelHeight;
			//var col:int = _mapWidth/_tilePixelWidth; 
			
			var col:int =  Math.floor(_mapWidth / _tilePixelWidth);
			var row:int =  Math.round(_mapHeight / _tilePixelHeight);

			_wHalfTile = int(_tilePixelWidth/2);
			_hHalfTile = int(_tilePixelHeight/2); 
			
			if(grid == null){
				grid = new Shape();
				addChild(grid);
			}
			grid.graphics.clear();
			
			grid.graphics.lineStyle(1, _gridLineColor, 1);
			
			var dblMapWidth:int = col*2 + 1;
			var dblMapHeight:int = row*2 + 1;
			for (var i:int=1; i<dblMapWidth; i = i+2)
			{
				
				grid.graphics.moveTo( i*_wHalfTile, 0 );
				if (dblMapHeight+i >= dblMapWidth)
				{
					grid.graphics.lineTo( dblMapWidth*_wHalfTile, (dblMapWidth-i)*_hHalfTile );
				}
				else
				{
					grid.graphics.lineTo( (dblMapHeight+i)*_wHalfTile, dblMapHeight*_hHalfTile );
				}
			
				grid.graphics.moveTo( i*_wHalfTile, 0 );
				if (i <= dblMapHeight)
				{
					grid.graphics.lineTo( 0, i*_hHalfTile );
				}
				else
				{
					grid.graphics.lineTo( (i - dblMapHeight)*_wHalfTile, dblMapHeight*_hHalfTile );//i-row-1
				}
			}
			
			for (var j:int=1; j<dblMapHeight; j=j+2)
			{
		
				grid.graphics.moveTo( 0, j*_hHalfTile );
				if (dblMapHeight-j >= dblMapWidth)
				{
					grid.graphics.lineTo( dblMapWidth*_wHalfTile, (dblMapWidth+j)*_hHalfTile );
				}
				else
				{
					grid.graphics.lineTo( (dblMapHeight-j)*_wHalfTile, dblMapHeight*_hHalfTile );
				}
			}
			
			for (var m:int=0; m<dblMapHeight; m=m+2)
			{
				grid.graphics.moveTo( dblMapWidth*_wHalfTile, m*_hHalfTile );
				if (dblMapWidth-dblMapHeight+m < 0)
				{
					grid.graphics.lineTo( 0, (dblMapWidth+m)*_hHalfTile );
				}
				else
				{
					grid.graphics.lineTo( (dblMapWidth-dblMapHeight+m)*_wHalfTile, dblMapHeight*_hHalfTile );
				}
			}
			//重设宽高，滚动条用
			width = col * _tilePixelWidth;// + _tilePixelWidth/2;
			height = (row + 1) * _tilePixelHeight / 2;
		}
		
		

	}
}