package com.editor.moudule_drama.view.right.layout.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIText;
	import com.editor.moudule_drama.event.DramaEvent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class DLayoutSprite extends DLayoutDisplayObject
	{
		private var _locked:int ;
		/**父级容器**/
		public var parentContainer:DLayoutContainer;
		
		/**拖动触发函数	para:DLayoutDisplayObject**/
		public var onStopDragFunc:Function;
		/**点击触发的函数**/
		public var onClickedFunc:Function;
		/**双击触发的函数**/
		public var onDoubleClickedFunc:Function;
		/**以底部坐标模式**/
		public var isBottomCoordModel:Boolean;
		
		private var _hConversionBool:int;
		
		private var _coordPointShape:Shape;
		private var _dragShape:Shape;
		private var _spotRadius:int = 2;
		
		private var _mouseDownStatus:int;
		private var _clickedStatus:int;
		
		private var _resW:int;
		private var _resH:int;
		
		public function DLayoutSprite()
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
						
			width = obj.width;
			height = obj.height;
			
			_resW = obj.width;
			_resH = obj.height;
			
			renderGraphics();
			
		}
		
		public function addResReplaceIndex(obj:DisplayObject, index:int):void
		{
			var rem:DisplayObject
			if(resContainer.numChildren > 1)
			{
				rem = resContainer.getChildAt(index);
			}
			resContainer.addChildAt(obj, index);
			if(rem)
			{
				resContainer.removeChild(rem);
			}
			
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
			if(onClickedFunc!=null) onClickedFunc(this);
		}
		private function doClickFun():void
		{			
			_clickedStatus = 1;
			renderGraphics();			
		}
		private function onMouseDownHandle(e:MouseEvent):void
		{
			_mouseDownStatus = 1;
			
			if(locked <= 0)
			{
				this.startDrag(false);				
			}
			
			renderGraphics();
		}
		private function onMouseUpHandle(e:MouseEvent):void
		{
			_mouseDownStatus = 0;
			
			this.stopDrag();
			if(onStopDragFunc!=null) onStopDragFunc(this);
					
			renderGraphics();
			
		}
		private function onDoubleClickHandle(e:MouseEvent):void
		{			
			doClickFun();
			if(onDoubleClickedFunc!=null) onDoubleClickedFunc(this);
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
			
			
			if(isBottomCoordModel)
			{
				if(!_coordPointShape)
				{
					_coordPointShape = new Shape();
					_coordPointShape.graphics.lineStyle(1, 0x00008C);
					_coordPointShape.graphics.beginFill(0x00FF00);
					_coordPointShape.graphics.drawRect(0, 0, _spotRadius*2, _spotRadius*2);
					_coordPointShape.graphics.endFill();
					_coordPointShape.x = (_resW/2)-_spotRadius;
					_coordPointShape.y = _resH-_spotRadius;
					addChild(_coordPointShape);
				}
				
			}
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			onStopDragFunc = null;
			onStopDragFunc = null;
			
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

		
		/** < gets : sets**/
		
		/**是否锁定**/
		public function get locked():int
		{
			return _locked;
		}

		/**是否锁定**/
		public function set locked(value:int):void
		{
			_locked = value;
			renderGraphics();
		}
		
		
		/** set get : X / Y **/
		override public function set x(value:Number):void
		{
			if(isBottomCoordModel)
			{
				super.x = value - getCoordPointShapeX();
			}else
			{
				super.x = value;
			}
		}
		override public function get x():Number
		{
			if(isBottomCoordModel)
			{
				return super.x + getCoordPointShapeX();
			}else
			{
				return super.x;
			}
		}
		override public function set y(value:Number):void
		{
			if(isBottomCoordModel)
			{
				super.y = value - getCoordPointShapeY();
				
			}else
			{
				super.y = value;
			}
		}
		override public function get y():Number
		{
			if(isBottomCoordModel)
			{
				return super.y + getCoordPointShapeY();
			}else
			{
				return super.y;
			}
		}
		private function getCoordPointShapeX():Number
		{
			var val:Number;
			if(_coordPointShape)
			{
				val = _coordPointShape.x + (_coordPointShape.width/2);
			}else
			{
				val = resContainer.width/2 + _coordPointShape;
			}
			
			return val;
		}
		private function getCoordPointShapeY():Number
		{
			var val:Number;
			if(_coordPointShape)
			{
				val = _coordPointShape.y + (_coordPointShape.height/2);
			}else
			{
				val = resContainer.height;
			}
			return val;
		}

		/**是否左右翻转模式**/
		public function get hConversionBool():int
		{
			return _hConversionBool;
		}

		/**是否左右翻转模式**/
		public function set hConversionBool(value:int):void
		{
			if(value != _hConversionBool)
			{
				var len:int = resContainer.numChildren;
				for(var i:int=len-1;i>=0;i--)
				{
					var bmp:Bitmap = resContainer.getChildAt(i) as Bitmap;
					if(bmp)
					{
						var matrix:Matrix = bmp.transform.matrix;
						matrix.transformPoint(new Point(bmp.width/2,bmp.height/2));
						if(matrix.a>0){
							matrix.a=-1*matrix.a;
							matrix.tx=bmp.width+bmp.x;
						}
						else
						{
							matrix.a=-1*matrix.a;
							matrix.tx=bmp.x-bmp.width;
						}
						bmp.transform.matrix=matrix;
					}
				}
			}
			
			_hConversionBool = value;
		}
		
		private var _alpha:Number;
		override public function set alpha(value:Number):void
		{
			if(!resContainer) return;
			
			_alpha = value;
			var len:int = resContainer.numChildren;
			for(var i:int=len-1;i>=0;i--)
			{
				var dObj:DisplayObject = resContainer.getChildAt(i);
				if(dObj)
				{
					dObj.alpha = _alpha;
				}
			}
		}
		
		override public function get alpha():Number
		{
			return _alpha;
		}
		

	}
}