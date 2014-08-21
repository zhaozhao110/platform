package com.editor.module_map2.mediator
{
	import com.air.io.WriteFile;
	import com.editor.component.containers.UICanvas;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.vo.map.AppMapDefineItemVO;
	import com.editor.module_map.vo.map.MapResConfigItemVO;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_map2.popview.MapInfoPopView2;
	import com.editor.module_map2.popview.MapSmallImgPopView2;
	import com.editor.module_map2.popview.MapSourcePopView2;
	import com.editor.module_map2.popview.MouseInfoPopView2;
	import com.editor.module_map2.proxy.MapEditorProxy2;
	import com.editor.module_map2.tool.MapEditorUtils2;
	import com.editor.module_map2.view.MapEditor2BottomContainer;
	import com.editor.module_map2.view.items.Building2;
	import com.editor.module_map2.view.layers.BuildingLayer2;
	import com.editor.module_map2.view.layers.GridLayer2;
	import com.editor.module_map2.view.layers.MapLayer2;
	import com.editor.module_map2.view.layers.RoadPointLayer2;
	import com.editor.module_mapIso.vo.MapEditorConstant;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.module_roleEdit.vo.res.AppResInfoGroupVO;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.editor.popup.selectEdit.SelectEditPopWinVO;
	import com.editor.popup.selectEdit2.SelectEditPopWin2VO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.math.SandyPoint;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.Map2Utils;
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

	public class MapEditor2BottomContainerMediator extends AppMediator
	{
		public static const NAME:String = "MapEditor2BottomContainerMediator";
		
		public function MapEditor2BottomContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get bot():MapEditor2BottomContainer
		{
			return viewComponent as MapEditor2BottomContainer;
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
			MapEditor2Manager.bottomContainerMediator = this;
		}
		
		private function get currentScene():AppMapDefineItemVO
		{
			return MapEditor2Manager.currentSelectedSceneItem;
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
		
		private var mapLayer:MapLayer2;//地图层
		private var gridLayer:GridLayer2;//网格层
		private var buildingLayer:BuildingLayer2;//建筑层
		private var roadPointLayer:RoadPointLayer2;//路点层
		public var  buildBrush:Building2;//建筑笔刷
		
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
				mapLayer = new MapLayer2();
				MapEditor2Manager.mapLayer = mapLayer;
				mapEditCanvas.addChild(mapLayer);
			}
			var map_url:String;
			if(StringTWLUtil.isWhitespace(MapEditor2Manager.currProject.mapResUrl)){
				map_url = MapEditor2Manager.currentSelectedSceneItem.mapXMLdata.backImage_file;
			}else{
				map_url = MapEditor2Manager.currProject.mapResUrl+currentScene.id+"/city.jpg";
			}
			mapLayer.load(map_url);
			map_url = MapEditor2Manager.currProject.mapResUrl+currentScene.id+"/mini.jpg";
			MapSmallImgPopView2.instance.load(map_url);
		}
		
		//创建网格层
		public function createGridLayer():void
		{
			if(gridLayer == null){
				gridLayer = new GridLayer2();
				MapEditor2Manager.gridLayer = gridLayer;
				mapEditCanvas.addChild(gridLayer);
			}
			
			gridLayer.drawGrid();
			addEvent();
			createRoadPointLayer();
		}
		
		//创建路点层
		private function createRoadPointLayer():void
		{
			if(roadPointLayer == null){
				roadPointLayer = new RoadPointLayer2(gridLayer);
				MapEditor2Manager.roadPointLayer = roadPointLayer;
				mapEditCanvas.addChild(roadPointLayer);	
			}
			 
			createBuildLayer();
		}
		
		//创建建筑层
		private function createBuildLayer():void
		{
			if(buildingLayer == null){
				buildingLayer = new BuildingLayer2(roadPointLayer);
				MapEditor2Manager.buildingLayer = buildingLayer;
				mapEditCanvas.addChild(buildingLayer);
			}
			
			buildingLayer.drawByXml(mapXML.copy());
			roadPointLayer.drawArr(mapArr);
			
			if(buildBrush == null){
				buildBrush         = new Building2();
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
			
			MapEditor2Manager.moduleMediator.mainUI.addEventListener(MouseEvent.MOUSE_OUT,mapEditCavansMouseOut);
			MapEditor2Manager.moduleMediator.mainUI.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mapEditCanvasRightClick);
			MapEditor2Manager.moduleMediator.mainUI.stage.addEventListener(KeyboardEvent.KEY_DOWN,moveEditKey);
			MapEditor2Manager.moduleMediator.mainUI.stage.addEventListener(KeyboardEvent.KEY_UP,moveEditKeyUp);
		}
		
		private function removeEvents():void
		{
			_listenerEvent = false;
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_DOWN,mapEditCanvasMouseDown);
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_MOVE,mapEditCanvasMove);
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_UP,mapEditCanvasUp);
						
			mapEditOutCanvas.stage.removeEventListener(Event.MOUSE_LEAVE,mapEditCavansMouseOut);
			
			MapEditor2Manager.moduleMediator.mainUI.removeEventListener(MouseEvent.MOUSE_OUT,mapEditCavansMouseOut);
			MapEditor2Manager.moduleMediator.mainUI.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mapEditCanvasRightClick);
			MapEditor2Manager.moduleMediator.mainUI.stage.removeEventListener(KeyboardEvent.KEY_DOWN,moveEditKey);
			MapEditor2Manager.moduleMediator.mainUI.stage.removeEventListener(KeyboardEvent.KEY_UP,moveEditKeyUp);
		}
				
		private function mapEditCanvasRightDown():void
		{
			ASComponent(mapEditCanvas.parent).startDragInParent(mapEditOutCanvas);
		}
		
		public function startAddBuild(d:AppResInfoItemVO):void
		{
			if(buildBrush == null){
				buildBrush = new Building2();
				buildBrush.isMouse = true;
			}
			buildBrush.resItem = d;
			buildBrush.draw();
			buildBrush.visible = true
			currentMode = MapEditorConstant.mouseMode_4;
		}
		
		public var mouseDown_pt:SandyPoint = new SandyPoint();
		
		private function mapEditCanvasMouseDown(evet:MouseEvent):void
		{
			mouseDowned = true;
			if(space_downBool){
				mapEditCanvasRightDown();
				return ;
			}
			
			mouseDown_pt.x = roadPointLayer.mouseX;
			mouseDown_pt.y = roadPointLayer.mouseY;
			
			var mouseClickX:Number = evet.stageX;
			var mouseClickY:Number = evet.stageY;
			var tg:* = evet.target;
			//得到对应点击位置的地图索引
			var cellPoint:Point = MapEditorUtils2.getCellPoint(gridLayer.mouseX, gridLayer.mouseY,cellWidth, cellHeight);		
			if(currentMode == MapEditorConstant.mouseMode_1 || 
				currentMode == MapEditorConstant.mouseMode_103 || 
				currentMode == MapEditorConstant.mouseMode_5 ||
				currentMode == MapEditorConstant.mouseMode_2){
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
			
			if(mouseDowned && currentMode == MapEditorConstant.mouseMode_6){
				//框选
				roadPointLayer.showSelectRect();
				return ;
			}
			
			//if(currentMode == 0) return ;
			if((gridLayer.mouseX<mapWidth) && (gridLayer.mouseY<mapHeight))
			{
				var cellPoint:Point = MapEditorUtils2.getCellPoint(gridLayer.mouseX, gridLayer.mouseY,cellWidth, cellHeight);
				//显示鼠标信息panel
				var parObj:Object = new Object();
				parObj.px = gridLayer.mouseX;
				parObj.py = gridLayer.mouseY;
				parObj.ix = cellPoint.x;
				parObj.iy = cellPoint.y;
				//trace(MapEditorUtils.getPixelPoint(cellWidth, cellHeight,cellPoint.x,cellPoint.y))
				if(MouseInfoPopView2.instance!=null){
					MouseInfoPopView2.instance.reflashMouse(parObj);
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
					currentMode == MapEditorConstant.mouseMode_4 ||
					currentMode == MapEditorConstant.mouseMode_5 ||
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
				pt = MapEditor2Manager.moduleMediator.mainUI.globalToLocal(pt);
				if(MapEditor2Manager.moduleMediator.mainUI.hitTestPoint(pt.x,pt.y)) return ;
			}
			mapEditCanvasUp();
			if(currentMode != MapEditorConstant.mouseMode_6){
				mapEditCanvasRightClick();
			}
			moveEditKeyUp();
		}
		
		private var min_tile:SandyPoint = new SandyPoint();
		private var max_tile:SandyPoint = new SandyPoint();
		
		private function mapEditCanvasUp(evet:Event=null):void
		{
			if(mouseDowned && currentMode == MapEditorConstant.mouseMode_6){
				//框选
				var start_pt:SandyPoint = mouseDown_pt;
				var curr_pt:SandyPoint = new SandyPoint(roadPointLayer.mouseX,roadPointLayer.mouseY);
				var start_tile:SandyPoint = Map2Utils.getCellPoint(start_pt.x,start_pt.y,cellWidth, cellHeight);
				var curr_tile:SandyPoint = Map2Utils.getCellPoint(curr_pt.x,curr_pt.y,cellWidth, cellHeight);
				min_tile = new SandyPoint();
				max_tile = new SandyPoint();
				if(start_pt.x<curr_pt.x){
					if(start_pt.y<curr_pt.y){
						min_tile = start_tile;
						max_tile = curr_tile
					}else{
						min_tile.x = start_tile.x;
						min_tile.y = curr_tile.y;
						max_tile.x = curr_tile.x;
						max_tile.y = start_tile.y;
					}
				}else{
					if(start_pt.y<curr_pt.y){	
						min_tile.x = curr_tile.x;
						min_tile.y = start_tile.y;
						max_tile.x = start_tile.x;
						max_tile.y = curr_tile.y;
					}else{
						min_tile = curr_tile;
						max_tile = start_tile;
					}
				}
				
				var m:OpenMessageData = new OpenMessageData();
				m.info = "请选择要填充的格子的类型"
				
				m.noButtonLabel = "障碍";
				m.noFunArgs = MapEditorConstant.CELL_TYPE_HINDER
				m.noFunction = selectRectConfirm
				
				m.okButtonLabel = "路点";
				m.okFunArgs = MapEditorConstant.CELL_TYPE_ROAD
				m.okFunction = selectRectConfirm;
				
				m.thirdButtonLabel = "透明"
				m.thirdFunArgs = MapEditorConstant.CELL_TYPE_ALPHA
				m.thirdButtonFun = selectRectConfirm
				
				showConfirm(m);
			}
			
			roadPointLayer.hideSelectRect();
			mouseDowned = false;
			mapEditCanvas.stopDrag();
		}
		
		private function selectRectConfirm(arg2:int):Boolean
		{
			for(var i:int=min_tile.x;i<=max_tile.x;i++){
				for(var j:int=min_tile.y;j<=max_tile.y;j++){
					var cellPoint:Point = new SandyPoint(i,j);
					
					if(mapArr[cellPoint.y][cellPoint.x] != arg2){
						roadPointLayer.drawCell(cellPoint.x,cellPoint.y,arg2);
						mapArr[cellPoint.y][cellPoint.x] = arg2;
					}
					
				}
			}
			return true;
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
				case MapEditorConstant.mouseMode_1:
					if(mapArr[cellPoint.y][cellPoint.x] != MapEditorConstant.CELL_TYPE_ROAD){
						roadPointLayer.drawCell(cellPoint.x,cellPoint.y,MapEditorConstant.CELL_TYPE_ROAD);
						mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_ROAD;
					}
					break;
				case MapEditorConstant.mouseMode_5:
					if(mapArr[cellPoint.y][cellPoint.x] != MapEditorConstant.CELL_TYPE_ladder){
						roadPointLayer.drawCell(cellPoint.x,cellPoint.y,MapEditorConstant.CELL_TYPE_ladder);
						mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_ladder;
					}
					break;
				case MapEditorConstant.mouseMode_2:
					if(mapArr[cellPoint.y][cellPoint.x] != MapEditorConstant.CELL_TYPE_HINDER){
						roadPointLayer.drawCell(cellPoint.x,cellPoint.y,MapEditorConstant.CELL_TYPE_HINDER);
						mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_HINDER;
					}
					break;
				case MapEditorConstant.mouseMode_103:
					if(mapArr[cellPoint.y][cellPoint.x] != MapEditorConstant.CELL_TYPE_ALPHA){
						roadPointLayer.drawCell(cellPoint.x,cellPoint.y,MapEditorConstant.CELL_TYPE_ALPHA);
						mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_ALPHA;
					}
					break;
				case MapEditorConstant.mouseMode_3:
					if(tg is Building2){
						
					}else{
						if(mapArr[cellPoint.y][cellPoint.x] == MapEditorConstant.CELL_TYPE_ROAD
							|| mapArr[cellPoint.y][cellPoint.x] == MapEditorConstant.CELL_TYPE_ladder 
							|| mapArr[cellPoint.y][cellPoint.x] == MapEditorConstant.CELL_TYPE_ALPHA){
							roadPointLayer.resetCell(cellPoint.x,cellPoint.y);
							mapArr[cellPoint.y][cellPoint.x] = MapEditorConstant.CELL_TYPE_SPACE;
						}
					}
					break;
			}
		}
		
		public function removeBuild(bld:Building2):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "您确定要删除该物体？"
			m.okButtonLabel = "删除"
			m.okFunArgs = bld;
			m.okFunction = confirm_removeBuild
			showConfirm(m);
		}
		
		private function confirm_removeBuild(bld:Building2):Boolean
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
				dat.popupwinSign = PopupwinSign.CreateMap2Popwin_sign
				dat.data = null;
				var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
				dat.openByAirData = opt;
				openPopupwin(dat);
				return 
			}
			
			if(btnId == "2"){
				//添加配置资源
				if(MapEditor2Manager.currentSelectedSceneItem == null) return ;
				
				var vo:SelectEditPopWin2VO = new SelectEditPopWin2VO();
				var mapId:int = MapEditor2Manager.currentSelectedSceneItem.id;
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
					get_MapEditor2TopContainerMediator().setInfoTxt("设置路点（可移动格子）")
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_1;
					iCursor.setCursorBySign("cursorRoadPoint_a");
				}else if(btnId == "ladderBtn"){
					//如果是阶梯
					get_MapEditor2TopContainerMediator().setInfoTxt("设置阶梯（可移动格子）")
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_5;
					iCursor.setCursorBySign("cursorRoadHinder_a");
				}else if(btnId == "HINDERBtn"){
					//障碍
					get_MapEditor2TopContainerMediator().setInfoTxt("设置障碍（不可移动格子）")
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_2;
					iCursor.setCursorBySign("cursorRoadHinder_a");
				}else if(btnId == "cancelRoadBtn"){
					//如果是清除
					get_MapEditor2TopContainerMediator().setInfoTxt("设置清除（清除格子）")
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_3;
					iCursor.setCursorBySign("cursorRoadCancel_a");
				}else if(btnId == "alphaBtn"){
					//如果是透明
					get_MapEditor2TopContainerMediator().setInfoTxt("设置透明（可移动格子）")
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_103;
					iCursor.setCursorBySign("cursorRoadPoint_a");
				}else if(btnId == "cancelSelect"){//如果是取消笔刷
					resetMouse()
				}else if(btnId == "baseInfoBtn"){//如果是显示隐藏基本信息
					if(MapInfoPopView2.instance.visible){
						MapInfoPopView2.instance.visible = false;
					}else{
						MapInfoPopView2.instance.visible = true;
					}
				}else if(btnId == "mouseInfoBtn"){//如果是显示隐藏鼠标信息
					if(MouseInfoPopView2.instance.visible){
						MouseInfoPopView2.instance.visible = false;
					}else{
						MouseInfoPopView2.instance.visible = true;
					}
				}else if(btnId == "saveMapBtn"){//如果是保存地图
					saveMapHandler()
				}else if(btnId == "imageLibBtn"){
					showImageLib();
				}else if(btnId == "12"){
					MapSmallImgPopView2.instance.visible = !MapSmallImgPopView2.instance.visible;
				}else if(btnId == "rectBtn"){
					iCursor.removeAllCursors();
					currentMode = MapEditorConstant.mouseMode_6;
				}
			}
		}
		
		private function saveMapHandler():Boolean
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "请选择要将空白区域转换成的类型"
			
			m.noFunArgs = "1"
			m.noButtonLabel = "障碍";
			m.noFunction = _saveMapHandler
			
			m.okButtonLabel = "路点";
			m.okFunArgs = "0"
			m.okFunction = _saveMapHandler;
			
			m.thirdButtonLabel = "不执行"
			m.thirdFunArgs = "-1"
			m.thirdButtonFun = _saveMapHandler
			
			showConfirm(m);
			
			return true;
		}
		
		private function _saveMapHandler(tp:String):Boolean
		{
			mapXML.f = MapEditorUtils2.getStrByArr(mapArr,int(tp));
			mapXML.i = buildingLayer.getSaveXML();
			
			var writer:WriteFile = new WriteFile();
			writer.write(new File("F:\\kuaipan\\project\\defend\\xml\\23.xml"),mapXML.toString());
			return true;	
		}
		
		//显示元件库
		private function showImageLib():void
		{
			if(MapSourcePopView2.instance.visible){
				MapSourcePopView2.instance.visible = false;
			}else{
				MapSourcePopView2.instance.visible = true;
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
			
			var x:XML = MapEditorUtils2.getNewMapXml(d);
			
			var mapParam:MapIsoMapData = new MapIsoMapData();
			mapParam.xml = x;
			mapParam.mapWidth   = x.@mapW;        //地图的宽=地图信息XML.地图宽
			mapParam.mapHeight  = x.@mapH;       //地图的高=地图信息XML.地图高
			mapParam.cellWidth  = x.f.@tileW; //单元格的宽=地图信息XML.面板.单元格宽
			mapParam.cellHeight = x.f.@tileH;//单元格的高=地图信息XML.面板.单元格高
			mapParam.col        = x.f.@c;       //地图横向节点数=XML.地图横向节点数
			mapParam.row        = x.f.@r;       //地图纵向节点数=XML.地图纵向节点数
			mapParam.backImage_file	= d.backImage_file;
			
			mapParam.mapArr = MapEditorUtils2.getArrByStr(x.f,mapParam.col,mapParam.row);
			
			MapEditor2Manager.currentSelectedSceneItem.mapXMLdata = mapParam;
			parser();
		}
		
		//重设所有参数
		private function reset():void
		{
			resetMouse();
			MapEditor2Manager.currentSelectedSceneItem.mapXMLdata = null;
			if(buildingLayer!=null) buildingLayer.reset();
			if(buildBrush!=null){
				buildBrush.visible = false;
			}
			MapSmallImgPopView2.instance.visible = false;
			MapInfoPopView2.instance.visible = false;
			MouseInfoPopView2.instance.visible = false;
		}
		
		//添加配置资源
		private function selectedSceneResCallBack(item:MapResConfigItemVO,item1:SelectEditPopWin2VO):void
		{			
			var appResItem:AppResInfoItemVO = get_MapEditorIsoProxy().resInfo_ls.getResInfoItemByID(item.sourceId);
			
		}
		
		//添加普通资源
		private function selectedSceneResCallBack2(item:AppResInfoItemVO,item1:SelectEditPopWinVO):void
		{
			/*currentMode = MapEditorConstant2.mouseMode_4;
			buildBrush.resItem = item;
			buildBrush.visible = true;*/
		}
		
		private function get_MapEditorIsoProxy():MapEditorProxy2
		{
			return retrieveProxy(MapEditorProxy2.NAME) as MapEditorProxy2;
		}
		
		private function get_MapEditor2TopContainerMediator():MapEditor2TopContainerMediator
		{
			return retrieveMediator(MapEditor2TopContainerMediator.NAME) as MapEditor2TopContainerMediator
		}
	}
}