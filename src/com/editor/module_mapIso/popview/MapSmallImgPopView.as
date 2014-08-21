package com.editor.module_mapIso.popview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UILoader;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MapSmallImgPopView extends MapIsoPopViewBase
	{
		public function MapSmallImgPopView()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		override protected function get titles():String
		{
			return "缩略图";	
		}
		
		public static var instance:MapSmallImgPopView;
		
		private var dragCont:UICanvas
		private var ld:UILoader;
		
		override protected function create_init():void
		{
			width = 225;
			height = 167;
			super.create_init();
			
			var sp:UICanvas = new UICanvas();
			sp.enabledPercentSize = true;
			addContent(sp);
			
			ld = new UILoader();
			ld.width = 220;
			ld.height = 130;
			ld.scaleContent = true;
			ld.complete_fun = onComplete;
			ld.mouseEnabled = true;
			ld.addEventListener(MouseEvent.CLICK , onClick);
			sp.addChild(ld);
			
			dragCont = new UICanvas();
			dragCont.width = 10;
			dragCont.height = 10;
			dragCont.borderStyle = ASComponentConst.borderStyle_solid;
			dragCont.borderThickness = 1;
			dragCont.borderColor = ColorUtils.white;
			sp.addChild(dragCont);
			dragCont.mouseEnabled = true;
			dragCont.addEventListener(MouseEvent.MOUSE_DOWN 		, onDown);
			dragCont.addEventListener(MouseEvent.MOUSE_UP 			, onUp);
			dragCont.addEventListener(MouseEvent.MOUSE_MOVE 		, onMove)
			addEventListener(Event.ADDED_TO_STAGE , onToStage);
		
		}
		
		private function onToStage(e:Event):void
		{
			dragCont.stage.addEventListener(Event.MOUSE_LEAVE 		, onUp);	
			dragCont.stage.addEventListener(MouseEvent.MOUSE_UP 	, onUp);
		}
				
		public function load(url:String):void
		{
			ld.load(url);
		}
		
		private function onComplete():void
		{
			reflashRect()
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			reflashRect()
		}
		
		private function reflashRect():void
		{
			var v1:Number = MapEditorIsoManager.bottomContainerMediator.mapEditOutCanvas.width/MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.mapWidth;
			var v2:Number = MapEditorIsoManager.bottomContainerMediator.mapEditOutCanvas.height/MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.mapHeight
			dragCont.height = ld.contentHolderHeight*v2;
			dragCont.width = ld.contentHolderWidth*v1;
		}
		
		private var mouseDownBool:Boolean;
		private function onDown(e:MouseEvent):void
		{
			mouseDownBool = true
			var rec:Rectangle = new Rectangle();
			rec.left   = 0 ;
			rec.right  = ld.contentHolderWidth-dragCont.width;
			rec.top    = 0;
			rec.bottom = ld.contentHolderHeight-dragCont.height;
			dragCont.startDrag(false,rec);
		}
		
		private function onUp(e:Event):void
		{
			mouseDownBool = false;
			dragCont.stopDrag();
		}
		
		private function onMove(e:MouseEvent):void
		{
			if(!mouseDownBool) return ;
			setMapEditCanvasLoc()
		}
		
		private function setMapEditCanvasLoc():void
		{
			var v1:Number = (ld.contentHolderWidth-dragCont.width)/
				(MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.mapWidth-MapEditorIsoManager.bottomContainerMediator.mapEditOutCanvas.width)
			
			var v2:Number = (ld.contentHolderHeight-dragCont.height)/
				(MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.mapHeight-MapEditorIsoManager.bottomContainerMediator.mapEditOutCanvas.height)
			
			
			var pt:Point = new Point();
			pt.x = -dragCont.x/v1;
			pt.y = -dragCont.y/v2;
			MapEditorIsoManager.bottomContainerMediator.setMapEditCanvasLoc(pt);
		}
		
		private function onClick(e:MouseEvent):void
		{
			var pt:Point = new Point(e.localX,e.localY);
			if(pt.x > (ld.contentHolderWidth-dragCont.width)) return ;
			if(pt.y > (ld.contentHolderHeight-dragCont.height)) return ;
			dragCont.x = pt.x;
			dragCont.y = pt.y;
			setMapEditCanvasLoc();
		}
		
	}
}