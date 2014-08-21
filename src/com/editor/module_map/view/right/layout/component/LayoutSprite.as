package com.editor.module_map.view.right.layout.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIText;
	import com.editor.module_map.event.MapEditorEvent;
	import com.editor.module_map.manager.MapEditorDataManager;
	import com.editor.module_map.model.MapConst;
	import com.editor.module_map.vo.map.MapSceneResItemEffVO;
	import com.editor.module_map.vo.map.MapSceneResItemNpcVO;
	import com.editor.module_map.vo.map.MapSceneResItemVO;
	import com.editor.module_map.vo.map.interfaces.IMapSceneResVO;
	import com.sandy.common.bind.field.bool.TRUE;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;

	public class LayoutSprite extends LayoutDisplayObject
	{
		public var parentContainer:LayoutSpriteContainer;
		
		private var _pointShape:Shape;
		private var _dragShape:Shape;
		private var _spotRadius:int = 2;
		
		private var _mouseDownStatus:int;
		private var _clickedStatus:int;
		
		private var _resW:int;
		private var _resH:int;
		
		public function LayoutSprite()
		{
			super();
			create_init();
		}
		
		private var resContainer:Sprite;
		private function create_init():void
		{			
			resContainer = new Sprite();
			addChild(resContainer);
			
			mouseEnabled = true;
			mouseChildren = false;
			$doubleClickEnabled = true;
			addEventListener(Event.ADDED_TO_STAGE, onAddedHandle);
		}
		
		public function addRes(obj:DisplayObject):void
		{
			resContainer.addChild(obj);
			
			x = IMapSceneResVO(_vo).x;
			y = IMapSceneResVO(_vo).y;
			
			width = obj.width;
			height = obj.height;
			
			_resW = obj.width;
			_resH = obj.height;
			
			renderGraphics();
			
		}
		public function doClick():void
		{
			doClickFun();
		}
		public function unClick():void
		{
			_clickedStatus = 0;
			renderGraphics();
		}
		
		private function onAddedHandle(e:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedHandle);
			addEventListener(MouseEvent.CLICK, onClickHandle);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandle);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandle);
			addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickHandle);
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			doClickFun();
		}
		private function doClickFun():void
		{			
			_clickedStatus = 1;
			
			sendAppNotification(MapEditorEvent.mapEditor_editPripertiesDate_event, {vo:_vo});
			renderGraphics();
		}
		private function onMouseDownHandle(e:MouseEvent):void
		{
			_mouseDownStatus = 1;
			
			if((vo as IMapSceneResVO).locked <= 0)
			{
				this.startDrag(false);
			}
			sendAppNotification(MapEditorEvent.mapEditor_editPripertiesDate_event, {vo:_vo});
			renderGraphics();
		}
		private function onMouseUpHandle(e:MouseEvent):void
		{
			_mouseDownStatus = 0;
			
			this.stopDrag();
			
			if(_vo is IMapSceneResVO)
			{
				(_vo as IMapSceneResVO).x = this.x;
				(_vo as IMapSceneResVO).y = this.y;
			}
			
			sendAppNotification(MapEditorEvent.mapEditor_editPripertiesTarget_event, {vo:_vo});			
			renderGraphics();
			
		}
		private function onDoubleClickHandle(e:MouseEvent):void
		{
			IMapSceneResVO(vo).locked = IMapSceneResVO(vo).locked ? 0 : 1;
			
			doClickFun();
		}
		
		
		private function onRemovedHandle(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedHandle);
			removeEventListener(MouseEvent.CLICK, onClickHandle);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandle);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandle);
			removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickHandle);
		}
				
		public function renderGraphics():void
		{		
			var lineStyleColor:uint;
			var locked:int = (vo as IMapSceneResVO).locked;
			
			var renderBool:Boolean;
			
			if(_mouseDownStatus > 0)
			{
				renderBool = false;
				
			}else if(_clickedStatus > 0)
			{
				renderBool = true;
			}else
			{
				renderBool = false;
			}
			
			if(renderBool)
			{				
				resContainer.graphics.clear();
				resContainer.graphics.lineStyle(1, 0x00008C);
				resContainer.graphics.moveTo(-1,-1);
				resContainer.graphics.lineTo(_resW, -1);
				resContainer.graphics.lineTo(_resW, _resH);
				resContainer.graphics.lineTo(-1, _resH);
				resContainer.graphics.lineTo(-1,-1);
				
				
				resContainer.graphics.beginFill(0x00008C);
				resContainer.graphics.drawRect(-_spotRadius, -_spotRadius, _spotRadius*2, _spotRadius*2);
				resContainer.graphics.drawRect(_resW-_spotRadius ,-_spotRadius, _spotRadius*2, _spotRadius*2);	
				resContainer.graphics.drawRect(-_spotRadius, _resH-_spotRadius, _spotRadius*2, _spotRadius*2);
				resContainer.graphics.drawRect(_resW-_spotRadius, _resH-_spotRadius, _spotRadius*2, _spotRadius*2);			
				resContainer.graphics.endFill();
				
			}else
			{
				resContainer.graphics.clear();
			}
						
			/**lock status**/
			if(vo is MapSceneResItemVO)
			{
				if((vo as MapSceneResItemVO).type == 9) return;
				
				var drW:int = 20;
				var drH:int = 20;
				
				if(!_dragShape)
				{
					_dragShape = new Shape();					
					addChild(_dragShape);
				}				
				_dragShape.graphics.clear();
				if(locked)
				{
					_dragShape.graphics.lineStyle(2, 0x000000);
				}else
				{
					_dragShape.graphics.lineStyle(2, 0x009900);
				}
				_dragShape.graphics.beginFill(0xffffff, 0.5);
				_dragShape.graphics.moveTo(drW/2, 0);
				_dragShape.graphics.lineTo(drW, drH/2);
				_dragShape.graphics.lineTo(drW/2, drH);
				_dragShape.graphics.lineTo(0, drH/2);
				_dragShape.graphics.lineTo(drW/2, 0);
				_dragShape.graphics.endFill();
			}
			
			if(vo is MapSceneResItemNpcVO)
			{
				if(!_pointShape)
				{
					_pointShape = new Shape();
					_pointShape.graphics.lineStyle(1, lineStyleColor);
					_pointShape.graphics.beginFill(0x00FF00);
					_pointShape.graphics.drawRect(0, 0, _spotRadius*2, _spotRadius*2);
					_pointShape.graphics.endFill();
					_pointShape.x = (_resW/2)-_spotRadius;
					_pointShape.y = _resH-_spotRadius;
					addChild(_pointShape);
				}
				
			}
			
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			var len:int = resContainer.numChildren;
			for(var i:int=len-1;i>=0;i--)
			{
				var dObj:DisplayObject = resContainer.getChildAt(i);
				if(dObj is Bitmap)
				{
					(dObj as Bitmap).bitmapData.dispose();
					(dObj as Bitmap).bitmapData = null;
				}else if(dObj is MovieClip)
				{
					(dObj as MovieClip).stop();
					UIComponentUtil.stopAllInMovieClip(dObj as MovieClip);
				}
				
				resContainer.removeChild(dObj);
				dObj = null;
				
			}
		}
		
		override public function set x(value:Number):void
		{
			if(_vo is MapSceneResItemNpcVO)
			{
				super.x = (_vo as MapSceneResItemNpcVO).x - getPointShapeX();
			}else
			{
				super.x = value;
			}
		}
		override public function get x():Number
		{
			if(_vo is MapSceneResItemNpcVO)
			{
				return super.x + getPointShapeX();
			}else
			{
				return super.x;
			}
		}
		override public function set y(value:Number):void
		{
			if(_vo is MapSceneResItemNpcVO)
			{
				super.y = (_vo as MapSceneResItemNpcVO).y - getPointShapeY();
				
			}else
			{
				super.y = value;
			}
		}
		override public function get y():Number
		{
			if(_vo is MapSceneResItemNpcVO)
			{
				return super.y + getPointShapeY();
			}else
			{
				return super.y;
			}
		}
		private function getPointShapeX():Number
		{
			var val:Number;
			if(_pointShape)
			{
				val = _pointShape.x + (_pointShape.width/2);
			}else
			{
				val = resContainer.width/2 + _pointShape;
			}
			
			return val;
		}
		private function getPointShapeY():Number
		{
			var val:Number;
			if(_pointShape)
			{
				val = _pointShape.y + (_pointShape.height/2);
			}else
			{
				val = resContainer.height;
			}
			return val;
		}
		

	}
}