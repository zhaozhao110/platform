package com.editor.module_sea.mediator
{
	import com.editor.component.containers.UICanvas;
	import com.editor.mediator.AppMediator;
	import com.editor.module_mapIso.vo.MapIsoMapData;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.popview.SeaMapLevelPopview;
	import com.editor.module_sea.popview.SeaMapLibPopview;
	import com.editor.module_sea.popview.SeaMapMouseInfoPopView;
	import com.editor.module_sea.popview.SeaMapResListPopview;
	import com.editor.module_sea.popview.SeaMapSmallImgPopView;
	import com.editor.module_sea.proxy.SeaMapModuleProxy;
	import com.editor.module_sea.view.SeaMapContent;
	import com.editor.module_sea.view.SeaMapItemView;
	import com.editor.module_sea.view.SeaMapLevelView;
	import com.editor.module_sea.view.SeaMapWave;
	import com.editor.module_sea.vo.SeaMapData;
	import com.editor.module_sea.vo.SeaMapItemVO;
	import com.editor.module_sea.vo.SeaMapLevelVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.error.SandyError;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	public class SeaMapContentMediator extends AppMediator
	{
		public static const NAME:String = "SeaMapContentMediator";
		public function SeaMapContentMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get mainUI():SeaMapContent
		{
			return viewComponent as SeaMapContent;
		}
		public function get popCont():UICanvas
		{
			return mainUI.popCont;
		}
		public function get mapEditOutCanvas():UICanvas
		{
			return mainUI.mapEditOutCanvas;
		}
		public function get mapEditCanvas():UICanvas
		{
			return mainUI.mapEditCanvas;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			mapEditCanvas.rightClickEnabled = true
		}
		
		public function createNewMap(d:SeaMapData):void
		{
			SeaMapModuleManager.mapData = d;
			
			mapEditCanvas.width = d.mapWidth;
			mapEditCanvas.height = d.mapHeight;
						
			
			createBrush()
			addLevels()
			addEvent()
			
			SeaMapLevelPopview.instance.visible = true;
			SeaMapLibPopview.instance.visible = true
			SeaMapSmallImgPopView.instance.visible = true;
			SeaMapSmallImgPopView.instance.load(SeaMapModuleManager.currProject.resFold + "1.jpg");
			SeaMapResListPopview.instance.visible = true
			
			addWave();
		}
		
		private function addWave():void
		{
			if(SeaMapWave.waveBitmap != null){
				//mapEditCanvas.addChild(SeaMapWave.waveBitmap);
				
				var wavec:UICanvas = new UICanvas();
				mapEditCanvas.addChild(wavec);
				
				for(var j:int=0;j<3;j++){
					for(var i:int=0;i<5;i++){
						var w:SeaMapWave = new SeaMapWave();
						wavec.addChild(w);
						w.x = 512*i;
						w.y = j*512;
						//break;
					}
					//break;
				}
				
				(wavec.getChildAt(0) as SeaMapWave).draw();
								
			}else{
				SandyError.error("123");
			}
		}
		
		private var bitmapData:BitmapData;
		
		public function dragMapEditCanvas():BitmapData
		{
			if(bitmapData == null){
				bitmapData = new BitmapData(mapEditCanvas.width,mapEditCanvas.height);
			}
			bitmapData.draw(mapEditCanvas);
			return bitmapData;
		}
		
		public function removeLevel(d:SeaMapLevelVO):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "确定要删除"+d.name + "层？该容器下的所有对象都将被删除"
			m.okFunction = removeLevel_ok;
			m.okFunArgs = d;
			showConfirm(m);
		}
		
		private function removeLevel_ok(d:SeaMapLevelVO):Boolean
		{
			SeaMapModuleManager.mapData.removeLevel(d)
			SeaMapLevelPopview.instance.reflashMapInfo();
			if(SeaMapModuleManager.selectlevel!=null){
				if(SeaMapModuleManager.selectlevel.index == d.index){
					SeaMapModuleManager.selectlevel = null;
					get_SeaMapModuleTopContainerMediator().mainUI.infoTxt2.htmlText = "选中:";
				}
			}
			return true;
		}
		
		private function addLevels():void
		{
			var a:Array = SeaMapModuleManager.mapData.level_ls;
			for(var i:int=0;i<a.length;i++){
				createLevel(a[i] as SeaMapLevelVO)
			}
		}
		
		public function createLevel(d:SeaMapLevelVO):SeaMapLevelView
		{
			var v:SeaMapLevelView = new SeaMapLevelView();
			v.poolChange(d);
			mapEditCanvas.addChild(v);
			return v;
		}
		
		public function selectItem(d:SeaMapItemVO):void
		{
			if(SeaMapModuleManager.selectlevel == null){
				showError("请先选中分层");
				return ;
			}
			createBrush();
			brush.poolChange(d);
		}
		
		private var brush:SeaMapItemView;
		
		private function createBrush():void
		{
			if(brush == null){
				brush = new SeaMapItemView();
				mapEditCanvas.addChild(brush);
				//brush.visible = false
			}
		}
		
		private var mouseDowned:Boolean = false;//鼠标是否按下
		private var space_downBool:Boolean = false;
		private var _listenerEvent:Boolean;
		private function addEvent():void
		{
			if(_listenerEvent) return ;
			_listenerEvent = true;
			
			mapEditCanvas.addEventListener(MouseEvent.MOUSE_DOWN,mapEditCanvasMouseDown);
			mapEditCanvas.addEventListener(MouseEvent.MOUSE_MOVE,mapEditCanvasMove);
			mapEditCanvas.addEventListener(MouseEvent.MOUSE_UP,mapEditCanvasUp);
			
			mapEditOutCanvas.stage.addEventListener(Event.MOUSE_LEAVE,mapEditCavansMouseOut);
			
			get_SeaMapModuleMediator().mainUI.addEventListener(MouseEvent.MOUSE_OUT,mapEditCavansMouseOut);
			mapEditCanvas.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mapEditCanvasRightClick);
			get_SeaMapModuleMediator().mainUI.stage.addEventListener(KeyboardEvent.KEY_DOWN,moveEditKey);
			get_SeaMapModuleMediator().mainUI.stage.addEventListener(KeyboardEvent.KEY_UP,moveEditKeyUp);
		}
		
		private function removeEvents():void
		{
			_listenerEvent = false;
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_DOWN,mapEditCanvasMouseDown);
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_MOVE,mapEditCanvasMove);
			mapEditCanvas.removeEventListener(MouseEvent.MOUSE_UP,mapEditCanvasUp);
			
			mapEditOutCanvas.stage.removeEventListener(Event.MOUSE_LEAVE,mapEditCavansMouseOut);
			
			get_SeaMapModuleMediator().mainUI.removeEventListener(MouseEvent.MOUSE_OUT,mapEditCavansMouseOut);
			mapEditCanvas.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,mapEditCanvasRightClick);
			get_SeaMapModuleMediator().mainUI.stage.removeEventListener(KeyboardEvent.KEY_DOWN,moveEditKey);
			get_SeaMapModuleMediator().mainUI.stage.removeEventListener(KeyboardEvent.KEY_UP,moveEditKeyUp);
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
			
			if(!brush.visible) return ;
			
			if(SeaMapModuleManager.selectlevel == null){
				showError("请先选中分层");
			}else{
				var dt:SeaMapItemVO = brush.item.clone()
				var v:SeaMapItemView = SeaMapModuleManager.selectlevel.createItem(dt);
				if(v!=null){
					v.x = mapEditCanvas.mouseX
					v.y = mapEditCanvas.mouseY
					SeaMapResListPopview.instance.reflashMapInfo();
				}
			}
			
			brush.visible = false;
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
			if(space_downBool && mouseDowned){
				mapEditOutCanvas.verticalScrollPosition = ASComponent(mapEditCanvas.parent).y;
				mapEditOutCanvas.horticalScrollPosition = ASComponent(mapEditCanvas.parent).x;
			}
			
			if(brush.visible){
				brush.x = mapEditCanvas.mouseX
				brush.y = mapEditCanvas.mouseY
			}
			
			if(SeaMapMouseInfoPopView.instance!=null){
				SeaMapMouseInfoPopView.instance.reflashMouse({px:mapEditCanvas.mouseX,py:mapEditCanvas.mouseY});
			}
		}
		
		private function mapEditCavansMouseOut(e:Event = null):void
		{
			if(e is MouseEvent){
				var pt:Point = new Point(mainUI.stage.mouseX,mainUI.stage.mouseY)
				pt = get_SeaMapModuleMediator().mainUI.globalToLocal(pt);
				if(get_SeaMapModuleMediator().mainUI.hitTestPoint(pt.x,pt.y)) return ;
			}
			mapEditCanvasRightClick()
		}
		
		private function mapEditCanvasUp(evet:Event=null):void
		{
			mouseDowned = false;
			mapEditCanvas.stopDrag();
		}
		
		private function mapEditCanvasRightClick(e:Event=null):void
		{
			brush.visible = false;
			mapEditCanvasUp();
			moveEditKeyUp();
			if(SeaMapModuleManager.downMapItem!=null)SeaMapModuleManager.downMapItem.onUpHandle();
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
		
		private function get_SeaMapModuleMediator():SeaMapModuleMediator
		{
			return retrieveMediator(SeaMapModuleMediator.NAME) as SeaMapModuleMediator;
		}
		
		private function get_SeaMapModuleTopContainerMediator():SeaMapModuleTopContainerMediator
		{
			return retrieveMediator(SeaMapModuleTopContainerMediator.NAME) as SeaMapModuleTopContainerMediator;
		}
	}
}