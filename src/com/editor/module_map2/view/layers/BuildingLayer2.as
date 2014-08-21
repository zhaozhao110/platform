package com.editor.module_map2.view.layers
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_map2.popview.MapSourceInfoPopView2;
	import com.editor.module_map2.popview.MapSourcePopView2;
	import com.editor.module_map2.proxy.MapEditorProxy2;
	import com.editor.module_map2.tool.MapEditorUtils2;
	import com.editor.module_map2.view.items.Building2;
	import com.sandy.math.HashMap;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	
	public class BuildingLayer2 extends UICanvas
	{
		//所有building数组，数组索引对应building id
		public var buildingArray:HashMap = new HashMap();	
		//建筑数量
		private var maxNum:int = 0;
		//路点层
		private var _roadLayer:RoadPointLayer2;
		
		override public function reset():void
		{
			super.reset();
			buildingArray.clear();
		}
		
		//获取建筑物清单
		public function BuildingLayer2(roadLayer:RoadPointLayer2)
		{
			_roadLayer = roadLayer;
		}
		
		//放置建筑物
		public function placeAndClone(bld:Building2, tilePoint:Point):Building2
		{
			placeSign(bld, tilePoint);
			placeBuilding(bld, tilePoint);
			return bld;
		}
		
		//放置建筑物图片
		public function placeBuilding(bld:Building2, tilePoint:Point):Building2
		{
			//获取建筑物的XML信息
			var blXml:XML = <i />
			//blXml = bld.configXml.copy();
			var nbld:Building2 = new Building2();
			nbld.index = maxNum;
			nbld.x = bld.x;
			nbld.y = bld.y;
			nbld.resItem = bld.resItem;
			nbld.configXml = blXml;
			nbld.configXml.@i = maxNum;
			nbld.configXml.@id = bld.getResId();
			nbld.configXml.@px = nbld.x;
			nbld.configXml.@py = nbld.y;
						
			buildingArray.put(maxNum.toString(),nbld);
			nbld = this.addChild(nbld) as Building2;
			this.maxNum++;
			MapSourcePopView2.instance.reflashMapInfo()
			return nbld;
		}
		
		//放置障碍物障碍点
		private function placeSign(bld:Building2, tilePoint:Point):void
		{
			//获取单元格的宽，高
			var tilePixelWidth:int = currentScene.mapXMLdata.cellWidth;
			var tilePixelHeight:int = currentScene.mapXMLdata.cellHeight;
			
			//阻挡和阴影标记
			var pt:Point = MapEditorUtils2.getPixelPoint(tilePoint.x, tilePoint.y,tilePixelWidth, tilePixelHeight);
			
			// building的元点在地图坐标系中的tile坐标
			var pxt:int = pt.x 
			var pyt:int = pt.y 
			_roadLayer.drawWalkableBuilding(bld, pxt, pyt, false);
		}
		
		//移除建筑
		public function removeBuild(bld:Building2):void
		{
			//获取单元格的宽，高
			var tilePixelWidth:int = currentScene.mapXMLdata.cellWidth;
			var tilePixelHeight:int = currentScene.mapXMLdata.cellHeight;
			//获取当前建筑物网格的行列坐标
			var offsetCt:Point = MapEditorUtils2.getCellPoint(0,0,tilePixelWidth, tilePixelHeight);
			//获取当前建筑物网格的象素坐标
			var offsetPt:Point = MapEditorUtils2.getPixelPoint(offsetCt.x, offsetCt.y,tilePixelWidth, tilePixelHeight);
			//获得建筑物障碍点信息的字符串
			var walkableStr:String = bld.configXml.w;
			//把XML里的障碍点信息转化为数组
			var wa:Array = walkableStr.split(",");
			//获取建筑物的原点
			var originPX:int = bld.x - offsetPt.x;
			var originPY:int = bld.y - offsetPt.y;
			//移除建筑的障碍点
			_roadLayer.drawWalkableBuilding(bld, originPX, originPY, true);
			//移除建筑物
			buildingArray.remove(bld.index.toString());
			removeChild(bld);
			MapSourcePopView2.instance.reflashMapInfo()
			if(MapSourceInfoPopView2.instance.visible){
				if(MapSourceInfoPopView2.instance.currBuild.index == bld.index){
					MapSourceInfoPopView2.instance.visible = false;
				}
			}
		}
		
		//读取XML配置 放置建筑
		public function drawByXml(mapXml:XML, reset:Boolean = false):void
		{
			for each(var x:XML in mapXml.i.i){
				var bl:Building2     = new Building2();
				bl.configXml        = x;
				bl.index			= int(x.@i);
				bl.resItem			= get_MapEditorIsoProxy().resInfo_ls.getResInfoItemByID(int(x.@id));
				bl.x                = x.@px;
				bl.y                = x.@py;
				placeAndClone(bl, MapEditor2Manager.getCellPoint(bl.x,bl.y));
			}
		}
		
		public function getSaveXML():XML
		{
			var x:XML = <i />
			var a:Array = buildingArray.toArray();
			for(var i:int=0;i<a.length;i++){
				x.appendChild(Building2(a[i]).configXml)
			}
			return x;
		}
		
		private function get currentScene():AppMapDefineItemVO
		{
			return MapEditor2Manager.currentSelectedSceneItem;
		}
		
		private function get_MapEditorIsoProxy():MapEditorProxy2
		{
			return iManager.retrieveProxy(MapEditorProxy2.NAME) as MapEditorProxy2;
		}
		
	}
}