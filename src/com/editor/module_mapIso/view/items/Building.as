package com.editor.module_mapIso.view.items
{
	import com.editor.component.controls.UILoader;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.popview.MapSourceInfoPopView;
	import com.editor.module_roleEdit.vo.res.AppResInfoItemVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.GraphicsUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class Building extends ASComponent
	{
		public var index:int;
		private var sp:Sprite;	
		public var isBrush:Boolean;
		
		public function Building()
		{
			sp = new Sprite();
			addChild(sp);
			
			GraphicsUtils.drawDiamond(sp,cellWidth,cellHeight,ColorUtils.black);
			
			sp.x = -cellWidth/2;
			sp.y = -cellHeight/2;
			
			this.addEventListener(MouseEvent.MOUSE_OVER , overHandle);
			this.addEventListener(MouseEvent.MOUSE_OUT , outHandle);
			this.addEventListener(MouseEvent.MOUSE_DOWN , downHandle);
			this.addEventListener(MouseEvent.MOUSE_UP , upHandle);
			this.addEventListener(MouseEvent.DOUBLE_CLICK , doubleHandle);
			this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN , onRightMouse);
		}
				
		private function get cellWidth():Number//单元格宽度
		{
			return MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.cellWidth;
		}
		private function get cellHeight():Number//单元格高度
		{
			return MapEditorIsoManager.currentSelectedSceneItme.mapXMLdata.cellHeight;
		}
		
		public function getCellPoint():Point
		{
			return MapEditorIsoManager.getCellPoint(this.x,this.y);
		}
		
		public var resItem:AppResInfoItemVO;
		
		public function getResId():String
		{
			if(resItem == null){
				return index.toString();
			}
			return resItem.id.toString();
		}
		
		public function getResName():String
		{
			if(resItem == null) return "";
			return resItem.name;
		}
		
		public function get getVBoxId():String
		{
			return getResId() + "/" + getResName();
		}
		
		private var _configXml:XML;//配置
		public function get configXml():XML
		{
			return _configXml;
		}
		public function set configXml(configXml:XML):void
		{
			_configXml = configXml.copy();
		}
		
		private function onRightMouse(e:MouseEvent):void
		{
			if(isBrush) return ;
			e.stopImmediatePropagation();
			e.preventDefault();
			MapEditorIsoManager.bottomContainerMediator.removeBuild(this);
		}
		
		private function overHandle(e:MouseEvent):void
		{
			if(isBrush) return ;
			e.stopImmediatePropagation();
			e.preventDefault();
			this.filters = [getTextGlowFilter()];	
			iManager.iToolTip.createToolTipNow(getVBoxId+"/"+getCellPoint().toString())
		}
		
		private function outHandle(e:MouseEvent):void
		{
			if(isBrush) return ;
			e.stopImmediatePropagation();
			e.preventDefault();
			this.filters = [];
			iManager.iToolTip.destroy();
		}
		
		private function downHandle(e:MouseEvent):void
		{
			if(isBrush) return ;
			e.stopImmediatePropagation();
			e.preventDefault();
			if(MapSourceInfoPopView.instance.visible){
				if(MapSourceInfoPopView.instance.currBuild.index!=index){
					MapSourceInfoPopView.instance.showUI(this);
				}
			}
			this.startDrag();
		}
		
		private function upHandle(e:MouseEvent):void
		{
			if(isBrush) return ;
			e.stopImmediatePropagation();
			e.preventDefault();
			this.stopDrag();	
		}
		
		override public function dispose():void
		{
			super.dispose();
			
		}
		
		private function doubleHandle(e:MouseEvent):void
		{
			MapSourceInfoPopView.instance.showUI(this);
		}
		
		private function getTextGlowFilter(col:uint=0xCC0000,blur:Number=2):GlowFilter
		{
			var color:uint 			= col
			var alpha:Number    	= 1;
			var blurX:Number    	= blur
			var blurY:Number    	= blur
			var strength:Number 	= 255;
			var quality:Number  	= 1 	
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality);      
		}
		
		
	}
}