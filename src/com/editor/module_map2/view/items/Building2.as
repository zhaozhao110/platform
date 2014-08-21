package com.editor.module_map2.view.items
{
	import com.editor.component.controls.UILoader;
	import com.editor.module_map2.manager.MapEditor2Manager;
	import com.editor.module_map2.popview.MapSourceInfoPopView2;
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
	
	public class Building2 extends ASComponent
	{
		public var index:int;
		private var sp:Sprite;	
		public var isBrush:Boolean;
		public var resItem:AppResInfoItemVO;
		public var isMouse:Boolean;
		
		public function Building2()
		{
			sp = new Sprite();
			addChild(sp);
			draw()
			this.addEventListener(MouseEvent.MOUSE_OVER , overHandle);
			this.addEventListener(MouseEvent.MOUSE_OUT , outHandle);
			this.addEventListener(MouseEvent.MOUSE_DOWN , downHandle);
			this.addEventListener(MouseEvent.MOUSE_UP , upHandle);
			this.addEventListener(MouseEvent.DOUBLE_CLICK , doubleHandle);
			this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN , onRightMouse);
		}
		
		public function draw():void
		{
			sp.graphics.clear();
			sp.graphics.beginFill(ColorUtils.black)
			sp.graphics.drawRect(0,0,cellWidth,cellHeight);
			sp.graphics.endFill();
			
			sp.x = -cellWidth/2;
			sp.y = -cellHeight/2;
		}
		
		private function get cellWidth():Number//单元格宽度
		{
			return MapEditor2Manager.currentSelectedSceneItem.mapXMLdata.cellWidth;
		}
		private function get cellHeight():Number//单元格高度
		{
			return MapEditor2Manager.currentSelectedSceneItem.mapXMLdata.cellHeight;
		}
		
		public function getCellPoint():Point
		{
			return MapEditor2Manager.getCellPoint(this.x,this.y);
		}
		
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
			MapEditor2Manager.bottomContainerMediator.removeBuild(this);
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
			if(MapSourceInfoPopView2.instance.visible){
				if(MapSourceInfoPopView2.instance.currBuild.index!=index){
					MapSourceInfoPopView2.instance.showUI(this);
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
			MapSourceInfoPopView2.instance.showUI(this);
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