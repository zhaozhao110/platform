package com.editor.module_mapIso.mediator
{
	import com.air.io.WriteFile;
	import com.editor.component.containers.UICanvas;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map.vo.map.MapResConfigItemVO;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.popview.MapInfoPopView;
	import com.editor.module_mapIso.popview.MapSmallImgPopView;
	import com.editor.module_mapIso.popview.MapSourcePopView;
	import com.editor.module_mapIso.popview.MouseInfoPopView;
	import com.editor.module_mapIso.proxy.MapEditorIsoProxy;
	import com.editor.module_mapIso.tool.MapEditorUtils;
	import com.editor.module_mapIso.view.MapIsoBottomContainer;
	import com.editor.module_mapIso.view.items.Building;
	import com.editor.module_mapIso.view.layers.BuildingLayer;
	import com.editor.module_mapIso.view.layers.GridLayer;
	import com.editor.module_mapIso.view.layers.MapLayer;
	import com.editor.module_mapIso.view.layers.RoadPointLayer;
	import com.editor.module_mapIso.vo.MapEditorConstant;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;

	public class MapIsoBottomContainerMediator extends AppMediator
	{
		public static const NAME:String = "MapIsoBottomContainerMediator";
		
		public function MapIsoBottomContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get bot():MapIsoBottomContainer
		{
			return viewComponent as MapIsoBottomContainer;
		}
		public function get mapEditOutCanvas():UICanvas
		{
			return bot.mapEditOutCanvas;
		}
		public function get mapEditCanvas():UICanvas
		{
			return bot.mapEditCanvas
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			MapEditorIsoManager.bottomContainerMediator = this;
		}
		
		private function get currentScene():AppMapDefineItemVO
		{
			return MapEditorIsoManager.currentSelectedSceneItme;
		}
		
		private function get mapWidth():Number//地图宽度
		{
			return currentScene.mapXMLdata.mapWidth;
		}
		private function get mapHeight():Number//地图高度
		{
			return currentScene.mapXMLdata.mapHeight;
		}
		private function get cellWidth():Number//单元格宽度
		{
			return currentScene.mapXMLdata.cellWidth;
		}
		private function get cellHeight():Number//单元格高度
		{
			return currentScene.mapXMLdata.cellHeight;
		}
		private function get col():int//地图横向节点数
		{
			return currentScene.mapXMLdata.col;
		}
		private function get row():int//地图纵向节点数
		{
			return currentScene.mapXMLdata.row;
		}
		private function get mapArr():Array
		{
			return currentScene.mapXMLdata.mapArr;
		}
		private function get mouseX():Number
		{
			return mapEditCanvas.mouseX;
		}
		private function get mouseY():Number
		{
			return mapEditCanvas.mouseY;
		}
		private function get mapXML():XML
		{
			return currentScene.mapXMLdata.xml;
		}
		
		private var mapLayer:MapLayer;//地图层
		private var gridLayer:GridLayer;//网格层
		private var buildingLayer:BuildingLayer;//建筑层
		private var roadPointLayer:RoadPointLayer;//路点层
		public var  buildBrush:Building;//建筑笔刷
		
		/**
		 * 当前选择的鼠标点击模式
		 * 1:路点 2：障碍 ,103:透明 4:放置建筑 3:取消路点
		 */ 
		private var currentMode:int = 0;
		private var mouseDowned:Boolean = false;//鼠标是否按下
		private var space_downBool:Boolean = false;
		
		public function parser():void
		{
			createMapLayer()
		}
		
		//创建地图层
		private function createMapLayer():void
		{
			mapEditCanvas.width = Number(mapWidth);
			mapEditCanvas.height = Number(mapHeight);
						
			if(mapLayer == null){
				mapLayer = new MapLayer();
				MapEditorIsoManager.mapLayer = mapLayer;
				mapEditCanvas.addChild(mapLayer);
			}
			var map_url:String;
			if(StringTWLUtil.isWhitespace(MapEditorIsoManager.currProject.mapResUrl)){
				map_url = MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.backImage_file;
			}else{
				map_url = MapEditorIsoManager.currProject.mapResUrl+"map/"+currentScene.id+"/city.jpg";
			}
			mapLayer.load(map_url);
			map_url = MapEditorIsoManager.currProject.mapResUrl+"map/"+currentScene.id+"/mini.jpg";
			MapSmallImgPopView.instance.load(map_url);
		}
		
		//创建网格层
		public function createGridLayer():void
		{
			if(gridLayer == null){
				gridLayer = new GridLayer();
				MapEditorIsoManager.gridLayer = gridLayer;
				mapEditCanvas.addChild(gridLayer);
			}
			
			gridLayer.drawGrid(mapWidth,mapHeight,cellWidth,cellHeight);
			addEvent();
			createRoadPointLayer();
		}
		
		//创建路点层
		private function createRoadPointLayer():void
		{
			if(roadPointLayer == null){
				roadPointLayer = new RoadPointLayer(gridLayer);
				MapEditorIsoManager.roadPointLayer = roadPointLayer;
				mapEditCanvas.addChild(roadPointLayer);	
			}
			 
			createBuildLayer();
		}
		
		//创建建筑层
		private function createBuildLayer():void
		{
			if(buildingLayer == null){
				buildingLayer = new BuildingLayer(roadPointLayer);
				MapEditorIsoManager.buildingLayer = buildingLayer;
				mapEditCanvas.addChild(buildingLayer);
			}
			
			buildingLayer.drawByXml(mapXML.copy());
			roadPointLayer.drawArr(mapArr);
			
			if(buildBrush == null){
				buildBrush         = new Building();
				buildBrush.isBrush = true;
				buildBrush.visible = false;
				buildingLayer.addChild(buildBrush);
			}
			
			changeAlpha()
		}
		
		private function changeAlpha():void
		{
			if(buildingLayer != null){
				buildingLayer.alpha = 1;
			}
		}
		
		private var _listenerEvent:Boolean;
		private function addEvent():void
		{
			if(_listenerEvent) return ;
			_listenerEvent = true;
			
			mapEditCanvas.addEventListener(MouseEvent.MOUSE_DOWN,mapEditCanvasMouseDown);
			mapEditCanvas.addEventListener(MouseEvent.MOUSE_MOVE,mapEditCanvasMove);
			mapEditCanvas.addEventListener(MouseEvent.MOUSE_UP,mapEditCanvasUp);
						
			mapEditOutCanvas.stage.addEventListener(Event.MOUSE_LEAVE,mapEditCavansMouseOut);
			
			MapEditorIsoManager.moduleMediator.mainUI.addEventListener(MouseEvent.MOUSE_OUT,mapEditCavansMouseOut);
			MapEditorIsoManager.moduleMediator.mainUI.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mapEditCanvasRightClick);
			MapEditorIsoManager.moduleMediator.mainUI.stage.addEventListener(KeyboardEvent.KEY_DOWN,moveEditKey);
			MapEditorIsoManager.moduleMediator.mainUI.stage.addEventListener(KeyboardEvent.KEY_UP,moveEditKeyUp);
		}
		
		private function removeEvents():void
		{
			_listenerEvent = false;
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_DOWN,mapEditCanvasMouseDown);
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_MOVE,mapEditCanvasMove);
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_UP,mapEditCanvasUp);
						
			mapEditOutCanvas.stage.removeEventListener(Event.MOUSE_LEAVE,mapEditCavansMouseOut);
			
			MapEditorIsoManager.moduleMediator.mainUI.removeEventListener(MouseEvent.MOUSE_OUT,mapEditCavansMouseOut);
			MapEditorIsoManager.moduleMediator.mainUI.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mapEditCanvasRightClick);
			MapEditorIsoManager.moduleMediator.mainUI.stage.removeEventListener(KeyboardEvent.KEY_DOWN,moveEditKey);
			MapEditorIsoManager.moduleMediator.mainUI.stage.removeEventListener(KeyboardEvent.KEY_UP,moveEditKeyUp);
		}
				
		private function mapEditCanvasRightDown():void
		{
			ASComponent(mapEditCanvas.parent).startDragInParent(mapEditOutCanvas);
		}
		
		private function mapEditCanvasMouseDown(evet:MouseEvent):void
		{
			mouseDowned = true;
			if(space_downBool){
				mapEditCanvasRightDown();
				return ;
			}
			
			var mouseClickX:Number = evet.stageX;
			var mouseClickY:Number = evet.stageY;
			var tg:* = evet.target;
			//得到对应点击位置的地图索引
			var cellPoint:Point = MapEditorUtils.getCellPoint(gridLayer.mouseX, gridLayer.mouseY,cellWidth, cellHeight);		
			if(currentMode == MapEditorConstant.mouseMode_1 || 
				currentMode == MapEditorConstant.mouseMode_2 || 
				currentMode == MapEditorConstant.mouseMode_3 || 
				currentMode == MapEditorConstant.mouseMode_103 ){
				if((mouseX>mapWidth - 10)||(mouseY>mapHeight - 10)) return;
				drawRoadPoint(cellPoint, tg);
			}else if(currentMode == MapEditorConstant.mouseMode_4){//放置建筑
				if((buildBrush.x > mapWidth - buildBrush.width) || (buildBrush.y > mapHeight - buildBrush.height)){
					showError("您放置的元件超出地图边界");
					return;
				}
				if(buildBrush.resItem == null) return;
				//放建筑的图片
				buildingLayer.placeAndClone(buildBrush, cellPoint);
				//刷新建筑物的索引
				buildingLayer.setChildIndex(buildBrush, buildingLayer.numChildren - 1);
			}
		}
		
		public function setMapEditCanvasLoc(pt:Point):void
		{
			mapEditCanvas.parent.x = pt.x;
			mapEditCanvas.parent.y = pt.y;
			mapEditOutCanvas.verticalScrollPosition = ASComponent(mapEditCanvas.parent).y;
			mapEditOutCanvas.horticalScrollPosition = ASComponent(mapEditCanvas.parent).x;
		}
		
		private function mapEditCanvasMove(evet:MouseEvent):void
		{
			if(gridLayer == null) return ;
			
			if(space_downBool && mouseDowned){
				mapEditOutCanvas.verticalScrollPosition = ASComponent(mapEditCanvas.parent).y;
				mapEditOutCanvas.horticalScrollPosition = ASComponent(mapEditCanvas.parent).x;
			}
			
			//if(currentMode == 0) return ;
			if((gridLayer.mouseX<mapWidth) && (gridLayer.mouseY<mapHeight))
			{
				var cellPoint:Point = MapEditorUtils.getCellPoint(gridLayer.mouseX, gridLayer.mouseY,cellWidth, cellHeight);
				//显示鼠标信息panel
				var parObj:Object = new Object();
				parObj.px = gridLayer.mouseX;
				parObj.py = gridLayer.mouseY;
				parObj.ix = cellPoint.x;
				parObj.iy = cellPoint.y;
				//trace(MapEditorUtils.getPixelPoint(cellWidth, cellHeight,cellPoint.x,cellPoint.y))
				if(MouseInfoPopView.instance!=null){
					MouseInfoPopView.instance.reflashMouse(parObj);
				}
				//如果是放置建筑
				if(currentMode == MapEditorConstant.mouseMode_4)
				{
					buildBrush.visible = true;
					buildBrush.alpha = 0.5;
					
					if(buildBrush!=null){					
						buildBrush.x = parObj.px;
						buildBrush.y = parObj.py;
					}
				}
			}
			
			//如果鼠标按下
			if(mouseDowned){
				//如果是设置路点
				if(currentMode == MapEditorConstant.mouseMode_1 || 
					currentMode == MapEditorConstant.mouseMode_2 || 
					currentMode == MapEditorConstant.mouseMode_3 || 
					currentMode == MapEditorConstant.mouseMode_103){
					if((gridLayer.mouseX>=mapWidth - 10)||(gridLayer.mouseY>=mapHeight - 10)) return;
					drawRoadPoint(cellPoint,evet.target);
				}
			}
		}
		
		private function mapEditCavansMouseOut(e:Event = null):void
		{
			if(e is MouseEvent){
				var pt:Point = new Point(bot.stage.mouseX,bot.stage.mouseY)
				pt = MapEditorIsoManager.moduleMediator.mainUI.globalToLocal(pt);
				if(MapEditorIsoManager.moduleMediator.mainUI.hitTestPoint(pt.x,pt.y)) return ;
			}
			mapEditCanvasUp();
			mapEditCanvasRightClick();
			moveEditKeyUp();
		}
		
		private function mapEditCanvasUp(evet:Event=null):void
		{
			mouseDowned = false;
			mapEditCanvas.stopDrag();
		}
		
		private function mapEditCanvasRightClick(e:Event=null):void
		{
			resetMouse()
		}
		
		private function moveEditKeyUp(e:Event=null):void
		{
			space_downBool = false	
		}
		
		private function moveEditKey(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SPACE){
				space_downBool = true;
			}
		}
		
		//绘制地图路点的方法
		private function drawRoadPoint(cellPoint:Point, tg:*):void
		{
			switch(currentMode){
				case MapEditorConstant.mouseMode_1://如果是单选路点模式
					if(mapArr[cellPoint.y][cellPoint.x] != MapEditorConstant.CELL_TYPE_ROAD){
						roadPointLayer.drawCell(cellPoint.x,cellPoint.y,MapEditorConstant.CELL_TYPE_ROAD);
						mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_ROAD;
					}
					break;
				case MapEditorConstant.mouseMode_2://如果是选择障碍模式
					if(mapArr[cellPoint.y][cellPoint.x] != MapEditorConstant.CELL_TYPE_HINDER){
						roadPointLayer.drawCell(cellPoint.x,cellPoint.y,MapEditorConstant.CELL_TYPE_HINDER);
						mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_HINDER;
					}
					break;
				case MapEditorConstant.mouseMode_3://如果是清除模式
					if(tg is Building){
						
					}else{
						if(mapArr[cellPoint.y][cellPoint.x] == MapEditorConstant.CELL_TYPE_ROAD
							|| mapArr[cellPoint.y][cellPoint.x] == MapEditorConstant.CELL_TYPE_HINDER){
							roadPointLayer.resetCell(cellPoint.x,cellPoint.y);
							mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_SPACE;
						}
					}
					break;
				case MapEditorConstant.mouseMode_103://如果是单选路点模式
					if(mapArr[cellPoint.y][cellPoint.x] != MapEditorConstant.CELL_TYPE_ALPHA){
						roadPointLayer.drawCell(cellPoint.x,cellPoint.y,MapEditorConstant.CELL_TYPE_ALPHA);
						mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_ALPHA;
					}
					break;
			}
		}
		
		public function removeBuild(bld:Building):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "您确定要删除该物体？"
			m.okButtonLabel = "删除"
			m.okFunArgs = bld;
			m.okFunction = confirm_removeBuild
			showConfirm(m);
		}
		
		private function confirm_removeBuild(bld:Building):Boolean
		{
			buildingLayer.removeBuild(bld);
			resetMouse()
			return true;
		}
		
		private function resetMouse():void
		{
			iCursor.removeAllCursors();
			if(buildBrush!=null) buildBrush.visible = false;
			currentMode = 0;
			iCursor.setDefaultCursor();
		}
		
		public function menuHandler(btnId:String):void
		{
			//构造笔刷
			if(buildBrush != null){
				//构造笔刷是否可见
				buildBrush.visible = false;
			}
			
			var m:OpenMessageData;
			
			if(btnId == "newMap"){
				var dat:OpenPopwinData = new OpenPopwinData();
				dat.popupwinSign = PopupwinSign.CreateMapPopwin_sign
				dat.data = null;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				dat.openByAirData = opt;
				openPopupwin(dat);
				return 
			}
			
			if(btnId == "2"){
				//添加配置资源
				if(MapEditorIsoManager.currentSelectedSceneItme == null) return ;
				
				var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
				var mapId:int = MapEditorIsoManager.currentSelectedSceneItme.id;
				vo.data = get_MapEditorIsoProxy().mapRes.getListByMap(mapId);
				vo.labelField = "name1";
				vo.label = "选择资源: ";
				
				dat = new OpenPopwinData();
				dat.popupwinSign = PopupwinSign.SelectEditPopWin2_sign;
				dat.data = vo;
				dat.callBackFun = selectedSceneResCallBack;
				opt = new OpenPopByAirOptions();
				dat.openByAirData = opt;
				openPopupwin(dat);
				return ;
			}
			
			if(btnId == "3"){
				//添加普通资源
				var out:Array = [];
				var a:Array = get_MapEditorIsoProxy().resInfo_ls.group_ls;
				for(var i:int=0;i<a.length;i++){
					if(!StringTWLUtil.isWhitespace(AppResInfoGroupVO(a[i]).type_str)){
						out.push(a[i]);
					}
				}
				
				var vo1:SelectEditPopWinVO = new SelectEditPopWinVO();
				vo1.data = out;
				vo1.column2_dataField = "name1"
				vo1.select_dataField = "item_ls"
				
				dat = new OpenPopwinData();
				dat.popupwinSign = PopupwinSign.SelectEditPopWin_sign;
				dat.data = vo1;
				dat.callBackFun = selectedSceneResCallBack2;
				opt = new OpenPopByAirOptions();
				dat.openByAirData = opt;
				openPopupwin(dat);
				return ;
			}
			
			//如果地图层！=null
			if(mapLayer != null){
				
				//地图观察按钮
				if(btnId == "mapViewBtn"){
					//如果是显示隐藏地图层
					showHidenMap();
				}else if(btnId == "gridViewBtn"){
					//如果是显示隐藏网格层
					showHidenGrid();
				}else if(btnId == "buildViewBtn"){
					//如果是显示隐藏建筑层
					showHidenBuild();
				}else if(btnId == "signleRoadBtn"){
					//如果是路点
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_1;
					iCursor.setCursorBySign("cursorRoadPoint_a");
				}else if(btnId == "multiRoadBtn"){
					//如果是障碍
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_2;
					iCursor.setCursorBySign("cursorRoadHinder_a");
				}else if(btnId == "cancelRoadBtn"){
					//如果是清除
					resetMouse()
				}else if(btnId == "alphaBtn"){
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_103;		
					iCursor.setCursorBySign("cursorRoadAlpha_a");
				}else if(btnId == "cancelSelect"){//如果是取消笔刷
					resetMouse()
				}else if(btnId == "baseInfoBtn"){//如果是显示隐藏基本信息
					if(MapInfoPopView.instance.visible){
						MapInfoPopView.instance.visible = false;
					}else{
						MapInfoPopView.instance.visible = true;
					}
				}else if(btnId == "mouseInfoBtn"){//如果是显示隐藏鼠标信息
					if(MouseInfoPopView.instance.visible){
						MouseInfoPopView.instance.visible = false;
					}else{
						MouseInfoPopView.instance.visible = true;
					}
				}else if(btnId == "saveMapBtn"){//如果是保存地图
					
					m = new OpenMessageData();
					m.info = "请选择要将空白区域转换成的类型"
					
					m.noFunArgs = "1"
					m.noButtonLabel = "障碍";
					m.noFunction = saveMapHandler
					
					m.okButtonLabel = "路点";
					m.okFunArgs = "0"
					m.okFunction = saveMapHandler;
					
					showConfirm(m);
				}
				else if(btnId == "imageLibBtn"){
					showImageLib();
				}else if(btnId == "12"){
					MapSmallImgPopView.instance.visible = !MapSmallImgPopView.instance.visible;
				}
			}
		}
		
		private function saveMapHandler(typ:String):Boolean
		{
			mapXML.f = MapEditorUtils.getStrByArr(mapArr,int(typ));
			mapXML.i = buildingLayer.getSaveXML();
			
			var writer:WriteFile = new WriteFile();
			writer.write(new File(File.desktopDirectory.nativePath+File.separator+"23.xml"),mapXML.toString());
			
			return true;
		}
		
		//显示元件库
		private function showImageLib():void
		{
			if(MapSourcePopView.instance.visible){
				MapSourcePopView.instance.visible = false;
			}else{
				MapSourcePopView.instance.visible = true;
			}
		}
		
		//显示隐藏地图层
		private function showHidenMap():void
		{
			if(mapLayer.visible){
				mapLayer.visible = false;
			}else{
				mapLayer.visible = true;
			}
		}
		
		//显示隐藏网格层
		private function showHidenGrid():void
		{
			if(gridLayer.visible){
				gridLayer.visible = false;
			}else{
				gridLayer.visible = true;
			}
		}

		private function showHidenBuild():void
		{
			if(buildingLayer.visible){
				buildingLayer.visible = false;
			}else{
				buildingLayer.visible = true;
			}
		}
		
		
		//创建新地图
		public function createNewMap(d:MapIsoMapData):void
		{
			reset();
			
			var x:XML = MapEditorUtils.getNewMapXml(d);
			
			var mapParam:MapIsoMapData = new MapIsoMapData();
			mapParam.xml = x;
			mapParam.mapWidth   = x.@mapW;        //地图的宽=地图信息XML.地图宽
			mapParam.mapHeight  = x.@mapH;       //地图的高=地图信息XML.地图高
			mapParam.cellWidth  = x.f.@tileW; //单元格的宽=地图信息XML.面板.单元格宽
			mapParam.cellHeight = x.f.@tileH;//单元格的高=地图信息XML.面板.单元格高
			mapParam.col        = x.f.@c;       //地图横向节点数=XML.地图横向节点数
			mapParam.row        = x.f.@r;       //地图纵向节点数=XML.地图纵向节点数
			mapParam.backImage_file	= d.backImage_file;
			
			mapParam.mapArr = MapEditorUtils.getArrByStr(x.f,mapParam.col,mapParam.row);
			
			MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata = mapParam;
			parser();
		}
		
		//重设所有参数
		private function reset():void
		{
			resetMouse();
			MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata = null;
			if(buildingLayer!=null) buildingLayer.reset();
			if(buildBrush!=null){
				buildBrush.visible = false;
			}
			MapSmallImgPopView.instance.visible = false;
			MapInfoPopView.instance.visible = false;
			MouseInfoPopView.instance.visible = false;
		}
		
		//添加配置资源
		private function selectedSceneResCallBack(item:MapResConfigItemVO,item1:SelectEditPopWin2VO):void
		{			
			var appResItem:AppResInfoItemVO = get_MapEditorIsoProxy().resInfo_ls.getResInfoItemByID(item.sourceId);
			
		}
		
		//添加普通资源
		private function selectedSceneResCallBack2(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			currentMode = MapEditorConstant.mouseMode_4;
			buildBrush.resItem = item;
			buildBrush.visible = true;
		}
		
		private function get_MapEditorIsoProxy():MapEditorIsoProxy
		{
			return retrieveProxy(MapEditorIsoProxy.NAME) as MapEditorIsoProxy;
		}
		
	}
}