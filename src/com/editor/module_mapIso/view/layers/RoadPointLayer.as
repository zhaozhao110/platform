package com.editor.module_mapIso.view.layers
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map2.view.layers.RoadPointLayer2;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.tool.MapEditorUtils;
	import com.editor.module_mapIso.view.items.Building;
	import com.editor.module_mapIso.vo.MapEditorConstant;
	import com.sandy.math.HashMap;
	
	import flash.display.Shape;
	import flash.geom.Point;
	
	//路点层
	public class RoadPointLayer extends UICanvas
	{
		//绘制圆形路点标记常量标识
		public static var MARK_CIRCLE:int  = 0;
		//绘制菱形路点标记常量标识
		public static var MARK_DIAMOND:int = 1;
		
		//一个HashMap 对象，存储所有标记过的路点 
		private var _childMap:HashMap;
		//HashMap 对象，存储所有属于建筑物的路点
		private var _buildingPointMap:HashMap;
		//网格层
		private var _gridLayer:GridLayer;
		//用来区分当前路点层使用的图形标记是圆形还是菱形
		private var _cellMark:int = RoadPointLayer.MARK_CIRCLE;
		//绘制路点图形标记的代理函数
		private var _cellCreater:Function;
		
		override public function reset():void
		{
			super.reset();
			_buildingPointMap.clear();
		}
		
		public function RoadPointLayer(gridLayer:GridLayer)
		{
			_gridLayer = gridLayer;
			_childMap  = new HashMap();
			_buildingPointMap = new HashMap();
			//判断当前路点层使用的图形标记是圆形还是菱形
			switch(_cellMark){
				//圆形路点图形标记模式
				case RoadPointLayer.MARK_CIRCLE:
					_cellCreater = drawCircleShape;
					break;
				//菱形路点图形标记模式
				case RoadPointLayer.MARK_DIAMOND:
					_cellCreater = drawDiamondShape;
					break;
			}
		}
		
		//根据类型画出单元格
		public function drawCell(xIndex:int,yIndex:int,cellType:int):void
		{
			var type:int = 0;
			//如果是路点
			if(cellType == MapEditorConstant.CELL_TYPE_ROAD){
				type = MapEditorConstant.CELL_TYPE_ROAD;
			//如果是障碍
			}else if(cellType == MapEditorConstant.CELL_TYPE_HINDER){
				type = MapEditorConstant.CELL_TYPE_HINDER;
			}else if(cellType == MapEditorConstant.CELL_TYPE_ALPHA){
				type = MapEditorConstant.CELL_TYPE_ALPHA;
			}else{
				throw new Error("未知单元格类型！");
			}
			var p:Point = MapEditorUtils.getPixelPoint(xIndex,yIndex,cellWidth,cellHeight);
			
			var mapKey:String = xIndex + "," + yIndex;
			addRoadPoint(type, mapKey, p);
		}
		
		//将指定单元格设置为初始状态
		public function resetCell(xIndex:int,yIndex:int):void
		{
			var mapKey:String = xIndex + "," + yIndex;
			var oldCell:*     = _childMap.find(mapKey);
			if(oldCell!=null) {
				removeChild(oldCell.shape);
				_childMap.remove(mapKey);
			}
		}
		
		/**
		 * originPX, originPY	建筑物元点在地图坐标系中的像素坐标
		 * building				建筑物显示对象
		 * walkable 			是否可行走
		 */
		public function drawWalkableBuilding(building:Building, originPX:int, originPY:int, wb:Boolean):void
		{
			var cellWidth:Number  = currentScene.mapXMLdata.cellWidth;
			var cellHeight:Number = currentScene.mapXMLdata.cellHeight;
			var row:int           = currentScene.mapXMLdata.row;
			var col:int           = currentScene.mapXMLdata.col;
			var xtmp:int, ytmp:int;
			xtmp = originPX;
			ytmp = originPY;
						
			var pt:Point      = MapEditorUtils.getCellPoint(xtmp, ytmp,cellWidth, cellHeight);
			var mapKey:String = pt.x + "," + pt.y;
			
			if(!wb)
			{
				//增加阻挡
				if(pt.x >= 0 && xtmp > 0){
					
					//将建筑物中的障碍点记录在 _buildingPointMap 中
					if(!_buildingPointMap.exists(mapKey)) _buildingPointMap.put(mapKey, pt);
					
					drawCell(pt.x,pt.y,MapEditorConstant.CELL_TYPE_HINDER);
					currentScene.mapXMLdata.mapArr[pt.y][pt.x] = MapEditorConstant.CELL_TYPE_HINDER;
				}
			}
			else//删除阻挡
			{
				if(pt.x >= 0 && xtmp > 0) removeRoadPoint(mapKey, pt);
			}
			
		}          
		
		//打开时先画出原来的路点，并标记录有障碍的路点
		public function drawArr(arr:Array, roadType:int=0):void
		{
			drawRoadPoint(arr, roadType);
		}
		
		public function drawRoadPoint(arr:Array, roadType:int):void
		{
			MapEditorIsoManager.moduleMediator.addLog2("draw road : " + arr.length);
			for(var iy:int=0;iy < arr.length;iy++){
				for(var ix:int=0;ix < arr[0].length;ix++){
					var cell:int = arr[iy][ix];
					var mapKey:String = ix + "," + iy;
					if(roadType == MapEditorConstant.TYPE_SAVE_MAP_HINDER){
						if(cell == MapEditorConstant.CELL_TYPE_ROAD){
							drawCell(ix,iy,MapEditorConstant.CELL_TYPE_ROAD);
						}else if(cell == MapEditorConstant.CELL_TYPE_HINDER){
							if(!_buildingPointMap.exists(mapKey)) drawCell(ix,iy,MapEditorConstant.CELL_TYPE_HINDER);
						}else if(cell == MapEditorConstant.CELL_TYPE_ALPHA){
							if(!_buildingPointMap.exists(mapKey)) drawCell(ix,iy,MapEditorConstant.CELL_TYPE_ALPHA);
						}
					}else if(roadType == MapEditorConstant.TYPE_SAVE_MAP_ROAD){
						if(cell == MapEditorConstant.CELL_TYPE_ROAD){
							drawCell(ix,iy,MapEditorConstant.CELL_TYPE_ROAD);
						}else if(cell == MapEditorConstant.CELL_TYPE_HINDER){
							if(!_buildingPointMap.exists(mapKey)) drawCell(ix,iy,MapEditorConstant.CELL_TYPE_HINDER);
						}else if(cell == MapEditorConstant.CELL_TYPE_ALPHA){
							if(!_buildingPointMap.exists(mapKey)) drawCell(ix,iy,MapEditorConstant.CELL_TYPE_ALPHA);
						}
					}
				}
			}
		}
		
		protected function addRoadPoint(flag:int, mapKey:String, pt:Point):void
		{
			var obj:Object;
			var cell:Shape;
			if(_childMap.exists(mapKey)){
				obj = _childMap.find(mapKey);
				if(obj.type != flag){
					if(obj.shape.parent == this)removeChild(obj.shape);
					
					cell = _cellCreater(flag, pt);
					addChild(cell);
					
					_childMap.remove(mapKey);
					var newObj:Object = {shape:cell, count:1, type:flag};
					_childMap.put(mapKey, newObj);
				}else if(obj.type == flag){
					if(flag == 2){
						obj.count += 1;
						_childMap.put(mapKey, obj);
					}else if(flag == 1){
						if(obj.shape.parent == this) removeChild(obj.shape);
						addChild(obj.shape);
					}
				}
				
			}else{
				cell = _cellCreater(flag, pt);
				addChild(cell);
				obj = {shape:cell, count:1, type:flag};
				_childMap.put(mapKey, obj);
			}
		}
		
		//移除路点
		protected function removeRoadPoint(mapKey:String, pt:Point):void
		{
			var obj:Object = new Object();
			if(_childMap.exists(mapKey)){
				obj = _childMap.find(mapKey);
				if(obj.type == 1){
					removeChild(obj.shape);
					_childMap.remove(mapKey);
					currentScene.mapXMLdata.mapArr[pt.y][pt.x] = MapEditorConstant.CELL_TYPE_SPACE;
					
				}else if(obj.type == 2){
					obj.count--;
					if(obj.count == 0){
						removeChild(obj.shape);
						_childMap.remove(mapKey);
						if(_buildingPointMap.exists(mapKey)) _buildingPointMap.remove(mapKey);
						currentScene.mapXMLdata.mapArr[pt.y][pt.x] = MapEditorConstant.CELL_TYPE_SPACE;
						
					}else{
						_childMap.put(mapKey, obj);
					}
				}
			}
		}
		
		//绘制圆形的路点标记
		protected function drawCircleShape(type:int, pt:Point):Shape
		{
			var cell:Shape = new Shape();
			
			var cellColor:uint = getCellColor(type)
			cell.graphics.beginFill(cellColor, 0.5);
			cell.graphics.drawCircle(0, 0, cellHeight/4);
			cell.graphics.endFill();
			cell.x = pt.x;
			cell.y = pt.y;
			return cell;
		}
		
		private function getCellColor(tp:int):uint
		{
			return RoadPointLayer2.getCellColor(tp);
		}
				
		//绘制菱形的路点标记
		protected function drawDiamondShape(type:int, pt:Point):Shape
		{
			var cell:Shape = new Shape();
			var cellColor:uint = getCellColor(type)
			cell.graphics.beginFill(cellColor, 0.3);
			cell.graphics.moveTo(0, cellHeight/2);
			cell.graphics.lineTo(cellWidth/2, 0);
			cell.graphics.lineTo(cellWidth, cellHeight/2);
			cell.graphics.lineTo(cellWidth/2, cellHeight);
			cell.graphics.lineTo(0, cellHeight/2);
			cell.graphics.endFill();
			cell.x      = pt.x - cellWidth/2;
			cell.y      = pt.y - cellHeight/2;
			return cell;
		}
		
		//========getter and setter
		
		public function get cellWidth():Number
		{
			return MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.cellWidth;
		}
		
		public function get cellHeight():Number
		{
			return MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.cellHeight
		}
		
		private function get currentScene():AppMapDefineItemVO
		{
			return MapEditorIsoManager.currentSelectedSceneItme;
		}
	}
}