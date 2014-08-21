package com.editor.module_map2.view.layers
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_map2.mediator.MapEditor2BottomContainerMediator;
	import com.editor.module_map2.tool.MapEditorUtils2;
	import com.editor.module_map2.view.items.Building2;
	import com.editor.module_mapIso.vo.MapEditorConstant;
	import com.sandy.asComponent.core.ASSprite;
	import com.sandy.math.HashMap;
	import com.sandy.math.SandyPoint;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.NumberUtils;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	//路点层
	public class RoadPointLayer2 extends UICanvas
	{
		//绘制圆形路点标记常量标识
		public static var MARK_CIRCLE:int  = 0;
		
		//一个HashMap 对象，存储所有标记过的路点 
		private var _childMap:HashMap;
		//HashMap 对象，存储所有属于建筑物的路点
		private var _buildingPointMap:HashMap;
		//网格层
		private var _gridLayer:GridLayer2;
		//用来区分当前路点层使用的图形标记是圆形还是菱形
		private var _cellMark:int = RoadPointLayer2.MARK_CIRCLE;
		
		override public function reset():void
		{
			super.reset();
			_buildingPointMap.clear();
		}
		
		public function RoadPointLayer2(gridLayer:GridLayer2)
		{
			_gridLayer = gridLayer;
			_childMap  = new HashMap();
			_buildingPointMap = new HashMap();
		}
		
		//根据类型画出单元格
		public function drawCell(xIndex:int,yIndex:int,cellType:int):void
		{
			var type:int = 0;
			if(cellType <= 0){
				throw new Error("未知单元格类型！");
			}
			type = cellType;
			var p:Point = MapEditorUtils2.getPixelPoint(xIndex,yIndex,cellWidth,cellHeight);
			
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
		public function drawWalkableBuilding(building:Building2, originPX:int, originPY:int, wb:Boolean):void
		{
			var cellWidth:Number  = currentScene.mapXMLdata.cellWidth;
			var cellHeight:Number = currentScene.mapXMLdata.cellHeight;
			var row:int           = currentScene.mapXMLdata.row;
			var col:int           = currentScene.mapXMLdata.col;
			var xtmp:int, ytmp:int;
			xtmp = originPX;
			ytmp = originPY;
			
			var pt:Point      = MapEditorUtils2.getCellPoint(xtmp, ytmp,cellWidth, cellHeight);
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
		
		public function drawArr(arr:Array):void
		{
			drawRoadPoint(arr);
		}
		
		public function drawRoadPoint(arr:Array):void
		{
			MapEditor2Manager.moduleMediator.addLog2("draw road : " + arr.length);
			for(var iy:int=0;iy < arr.length;iy++){
				for(var ix:int=0;ix < arr[0].length;ix++){
					var cell:int = arr[iy][ix];
					var mapKey:String = ix + "," + iy;
					if(cell > 0){
						drawCell(ix,iy,cell);
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
					
					cell = drawCircleShape(flag, pt);
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
				cell = drawCircleShape(flag, pt);
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
		
		public static function getCellColor(tp:int):uint
		{
			if(tp == MapEditorConstant.CELL_TYPE_ROAD){
				return ColorUtils.green;
			}else if(tp == MapEditorConstant.CELL_TYPE_ladder){
				return ColorUtils.yellow
			}else if(tp == MapEditorConstant.CELL_TYPE_HINDER){
				return ColorUtils.red;
			}else if(tp == MapEditorConstant.CELL_TYPE_ALPHA){
				return ColorUtils.white
			}
			return ColorUtils.red;
		}
		
		
		//========getter and setter
		
		public function get cellWidth():Number
		{
			return currentScene.mapXMLdata.cellWidth;
		}
		
		public function get cellHeight():Number
		{
			return currentScene.mapXMLdata.cellHeight
		}
		
		private function get currentScene():AppMapDefineItemVO
		{
			return MapEditor2Manager.currentSelectedSceneItem
		}
		
		
		private var selectRect_sp:Sprite;
		public function showSelectRect():void
		{
			if(selectRect_sp == null){
				selectRect_sp = new Sprite();
				addChild(selectRect_sp);
			}
			setChildIndex(selectRect_sp,numChildren-1);
			selectRect_sp.visible = true
			var start_pt:SandyPoint = get_MapEditor2BottomContainerMediator().mouseDown_pt;
			var curr_pt:SandyPoint = new SandyPoint(this.mouseX,this.mouseY);
			
			var w:int = NumberUtils.getPositiveNumber(curr_pt.x-start_pt.x);
			var h:int = NumberUtils.getPositiveNumber(curr_pt.y-start_pt.y);
			
			selectRect_sp.graphics.clear();
			selectRect_sp.graphics.lineStyle(2,ColorUtils.white);
			if(start_pt.x<curr_pt.x){
				if(start_pt.y<curr_pt.y){
					selectRect_sp.graphics.drawRect(start_pt.x,start_pt.y,w,h);		
				}else{
					selectRect_sp.graphics.drawRect(start_pt.x,curr_pt.y,w,h);
				}
			}else{
				if(start_pt.y<curr_pt.y){
					selectRect_sp.graphics.drawRect(curr_pt.x,start_pt.y,w,h);		
				}else{
					selectRect_sp.graphics.drawRect(curr_pt.x,curr_pt.y,w,h);
				}
			}
			
			selectRect_sp.graphics.endFill();
		}
		
		public function hideSelectRect():void
		{
			if(selectRect_sp!=null) selectRect_sp.visible = false;
		}
		
		private function get_MapEditor2BottomContainerMediator():MapEditor2BottomContainerMediator
		{
			return iManager.retrieveMediator(MapEditor2BottomContainerMediator.NAME) as MapEditor2BottomContainerMediator;
		}
		
		
		
		
		
		
		
		
	}
}