package com.editor.module_mapIso.tool
{
	import com.editor.module_mapIso.vo.MapEditorConstant;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.sandy.utils.MapUtils;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class MapEditorUtils
	{
		public function MapEditorUtils()
		{
		}
		
		//根据提交的新地图信息 获得地图XML信息
		public static function getNewMapXml(d:MapIsoMapData):XML
		{
			var row:int =  Math.floor(d.mapHeight / d.cellHeight) * 2;
			var col:int =  Math.round(d.mapWidth / d.cellWidth);
			var mapArr:String="";
			var totalLen:int = row*col;
			
			for(var i:int = 0; i<totalLen; i++){
				//if(i>0) mapArr += ",";
				mapArr += "0";
			}
			
			var resultXml:XML = new XML();
			resultXml = <m/>;
			resultXml.@mapW    	= d.mapWidth;
			resultXml.@mapH    	= d.mapHeight;
			resultXml.f         = mapArr;
			resultXml.f.@tileW  = d.cellWidth;
			resultXml.f.@tileH 	= d.cellHeight;
			//有多少行
			resultXml.f.@r      = row;
			//有多少列
			resultXml.f.@c      = col;
			resultXml.@road 	= 0;
			return resultXml;
		}
		
				
		//根据数组得到字符串
		public static function getStrByArr(arr:Array,type:int = 0):String{
			var result:String = "";
			for(var i:uint = 0; i < arr.length;i++){
				for(var j:uint = 0; j < arr[0].length;j++){
					var cell:int = arr[i][j];
					var temp:String;
					switch(cell){
						case MapEditorConstant.CELL_TYPE_ROAD:
							temp = "1";
							break;
						case MapEditorConstant.CELL_TYPE_HINDER:
							temp = "2";
							break;
						case MapEditorConstant.CELL_TYPE_ALPHA:
							temp = "3";
							break
						case MapEditorConstant.CELL_TYPE_SPACE:
							if(type == MapEditorConstant.TYPE_SAVE_MAP_ROAD){
								temp = "1";
							}else if(type == MapEditorConstant.TYPE_SAVE_MAP_HINDER){
								temp = "2";
							}
							break;
						default:
							throw new Error("地图信息数组中有未知因素！");
							break;
						
					}
					if(result.length > 0){
						result+="";
					}
					result += temp;
				}
			}
			return result;
		}
		
		//根据字符串得到数组，用于加载旧地图数据
		public static function getArrByStr(arrayStr:String,col:int,row:int):Array
		{
			var _mapArray:Array = new Array();
			var arr:Array  = arrayStr.split("");
			var index:uint = 0;
			for(var i:uint = 0 ; i < row;i++){
				var tempArr:Array = new Array();
				for(var j:uint = 0 ; j < col; j++){
					
					if(arr[index]=="1"){
						arr[index] = MapEditorConstant.CELL_TYPE_ROAD
					}else if(arr[index]=="3"){
						arr[index]= MapEditorConstant.CELL_TYPE_ALPHA
					}else if(arr[index]=="2"){
						arr[index]= MapEditorConstant.CELL_TYPE_HINDER
					}
					
					tempArr.push(arr[index]);
					index++;
				}
				_mapArray.push(tempArr);
			}
			return _mapArray;
		}
		
		//根据字符串得到新数组，用于创建新地图数据
		public static function getNewArrByStr(arrayStr:String,col:int,row:int):Array{
			var _mapArray:Array = new Array();
			var arr:Array  = arrayStr.split(",");
			var index:uint = 0;
			for(var i:uint = 0 ; i < row;i++){
				var tempArr:Array = new Array();
				for(var j:uint = 0 ; j < col; j++){
					tempArr.push(arr[index]);
					index++;
				}
				_mapArray.push(tempArr);
			}
			return _mapArray;
		}
				
		//根据屏幕象素坐标取得网格的坐标
		public static function getCellPoint(px:int, py:int,tileWidth:int,tileHeight:int):Point
		{
			return MapUtils.getCellPoint(px,py,tileWidth,tileHeight).getPoint();
		}
		
		// 根据网格坐标取得象素坐标
		public static function getPixelPoint(tx:int, ty:int,tileWidth:int,tileHeight:int):Point
		{
			return MapUtils.getPixelPoint(tx,ty,tileWidth,tileHeight).getPoint();
		}
	}
}