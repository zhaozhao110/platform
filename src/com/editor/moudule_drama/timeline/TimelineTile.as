package com.editor.moudule_drama.timeline
{
	import com.editor.component.containers.UICanvas;
	import com.editor.moudule_drama.timeline.data.TimelineConst;
	import com.editor.moudule_drama.timeline.event.TimelineEvent;
	import com.editor.moudule_drama.timeline.vo.TimelineKeyframe_BaseVO;
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineKeyframe_BaseVO;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class TimelineTile extends UICanvas
	{
		public function TimelineTile()
		{
			super();
		}
		
		/**关键帧列表**/
		private var rectList:Array = [];
		
		/**选中框**/
		private var checkShape:UICanvas;
		/**选中框拷贝**/
		private var checkShapeCopy:UICanvas;
		/**选中框鼠标按下坐标**/
		private var checkShapeMouseDownPoint:Point = new Point();
		/**选中框选中的帧集合**/
		private var checkShapeFramesCollection:Array = [];
		
		private var keyframesC:UICanvas;
		private var checkShapeC:UICanvas;
		public function create_init():void
		{
			mouseEnabled = true;
			disabled_measuredSize = true;
			
			drawGrid();
			if(!keyframesC)
			{
				keyframesC = new UICanvas();
				addChild(keyframesC);
			}
			if(!checkShapeC)
			{
				checkShapeC = new UICanvas();
				addChild(checkShapeC);
			}
			
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
		}
		/**添加关键帧**/
		public function addKeyframe(f:TimelineRect):void
		{
			keyframesC.addChild(f);
			rectList.push(f);
		}
		/**删除关键帧**/
		public function removeKeyframe(vo:ITimelineKeyframe_BaseVO):void
		{
			var len:int = rectList.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var r:TimelineRect = rectList[i] as TimelineRect;
				if(r && r.frame == vo.frame && r.rowId == vo.rowId)
				{
					if(keyframesC.contains(r))
					{
						keyframesC.removeChild(r);
					}
					r.dispose();
					r = null;
					
					rectList.splice(i,1);
				}
			}
		}
		/**获取关键帧**/
		public function getKeyframe(vo:ITimelineKeyframe_BaseVO):TimelineRect
		{
			var outRect:TimelineRect;
			
			var len:int = rectList.length;
			for(var i:int=0;i<len;i++)
			{
				var r:TimelineRect = rectList[i] as TimelineRect;
				if(r && r.frame == vo.frame && r.rowId == vo.rowId)
				{
					outRect = r;
					break;
				}
			}
			
			return outRect;
		}
		/**清除关键帧**/
		public function clearKeyframes():void
		{
			if(keyframesC)
			{
				var len:int = rectList.length;
				for(var i:int=len-1;i>=0;i--)
				{
					var r:TimelineRect = rectList[i] as TimelineRect;
					if(keyframesC.contains(r))
					{
						keyframesC.removeChild(r);
					}					
					r.dispose();
					r = null;
					
					rectList.splice(i,1);
				}
				keyframesC.removeAllChildren();
			}
			
			rectList = [];
			
		}
		/**获取关键帧	通过坐标**/
		private function getRectByPlace(sX:int, sY:int):TimelineRect
		{
			var rX:int = sX - TimelineConst.FRAME_RECT_OFFSET_X;
			var rY:int = sY - TimelineConst.FRAME_RECT_OFFSET_Y;
			
			var len:int = rectList.length;
			for(var i:int=0;i<len;i++)
			{
				var rect:TimelineRect = rectList[i] as TimelineRect;
				if(rect)
				{
					if(rect.x == rX && rect.y == rY)
					{
						return rect;
					}
				}
			}
			return null;
		}
		
		/**移动选中框	坐标**/
		public function moveCheckShape(sX:int, sY:int):void
		{
			drawCheckShape();
			checkShape.x = sX;
			checkShape.y = sY;
			checkShape.width = TimelineConst.FRAME_WIDTH - TimelineConst.FRAME_RECT_OFFSET_X;
			checkShape.height = TimelineConst.FRAME_HEIGHT - TimelineConst.FRAME_RECT_OFFSET_Y;
		}
		
		/**移动选中框	层&&帧**/
		public function moveCheckShapeByPlace(row:int, col:int):void
		{
			var tX:int = (col -1) * TimelineConst.FRAME_WIDTH + TimelineConst.FRAME_RECT_OFFSET_X;
			var tY:int = (row -1) * TimelineConst.FRAME_HEIGHT + TimelineConst.FRAME_RECT_OFFSET_Y;
			moveCheckShape(tX, tY);
		}
		
		/**鼠标按下**/
		private function mouseDownHandle(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
			drawCheckShape();
			
			var col:int = getColByX(e.localX);
			var row:int = getRowByY(e.localY);
			
			var sX:int = e.localX - (e.localX % TimelineConst.FRAME_WIDTH);
			var sY:int = e.localY - (e.localY % TimelineConst.FRAME_HEIGHT);						
			if(sX > width - TimelineConst.FRAME_WIDTH) sX = width - TimelineConst.FRAME_WIDTH;
			if(sY > height - TimelineConst.FRAME_HEIGHT) sY = height - TimelineConst.FRAME_HEIGHT;
			sX = sX + TimelineConst.FRAME_RECT_OFFSET_X;
			sY = sY + TimelineConst.FRAME_RECT_OFFSET_Y;
			
			moveCheckShape(sX, sY);
			setCheckShapeMouseDownPoint(sX, sY);
			
			checkShape.width = TimelineConst.FRAME_WIDTH - TimelineConst.FRAME_RECT_OFFSET_X;
			checkShape.height = TimelineConst.FRAME_HEIGHT - TimelineConst.FRAME_RECT_OFFSET_Y;
			
			var rect:TimelineRect = getRectByPlace(sX, sY);
			if(rect)
			{
				dispatchEvent(new TimelineEvent(TimelineEvent.SELECTED_ONE_FRAME, {id:rect.id, row:row, col:col}));
			}else
			{
				dispatchEvent(new TimelineEvent(TimelineEvent.SELECTED_ONE_FRAME, {id:"", row:row, col:col}));
			}
			
			/**开始画范围**/
			startDrawRange();
		}
				
		/**设置选中框鼠标按下坐标**/
		private function setCheckShapeMouseDownPoint(sX:int, sY:int):void
		{
			if(!checkShapeMouseDownPoint)
			{
				checkShapeMouseDownPoint = new Point();
			}
			checkShapeMouseDownPoint.x = sX;
			checkShapeMouseDownPoint.y = sY;
		}
		
		/**按下鼠标移动**/
		private function mouseDownMoveHandle(e:MouseEvent):void
		{
			drawCheckShape();
			
			if(checkShape)
			{
				/** X **/
				if(e.localX < checkShapeMouseDownPoint.x)
				{
					checkShape.x = e.localX - (e.localX % TimelineConst.FRAME_WIDTH) + TimelineConst.FRAME_RECT_OFFSET_X;
					checkShape.width = checkShapeMouseDownPoint.x + TimelineConst.FRAME_WIDTH - checkShape.x - TimelineConst.FRAME_RECT_OFFSET_X;
					
				}else if(e.localX > (checkShapeMouseDownPoint.x + TimelineConst.FRAME_WIDTH))
				{
					checkShape.x = checkShapeMouseDownPoint.x;
					var longX:int = e.localX - checkShapeMouseDownPoint.x;
					checkShape.width = longX - (longX % TimelineConst.FRAME_WIDTH) + TimelineConst.FRAME_WIDTH - TimelineConst.FRAME_RECT_OFFSET_X;
					
				}else
				{
					checkShape.x = checkShapeMouseDownPoint.x;
					checkShape.width = TimelineConst.FRAME_WIDTH - TimelineConst.FRAME_RECT_OFFSET_X;
				}
				
				/** Y **/
				if(e.localY < checkShapeMouseDownPoint.y)
				{
					checkShape.y = e.localY - (e.localY % TimelineConst.FRAME_HEIGHT) + TimelineConst.FRAME_RECT_OFFSET_Y;
					checkShape.height = checkShapeMouseDownPoint.y + TimelineConst.FRAME_HEIGHT - checkShape.y - TimelineConst.FRAME_RECT_OFFSET_Y;
					
				}else if(e.localY > (checkShapeMouseDownPoint.y + TimelineConst.FRAME_HEIGHT))
				{
					checkShape.y = checkShapeMouseDownPoint.y;
					var longY:int = e.localY - checkShapeMouseDownPoint.y;
					checkShape.height = longY - (longY % TimelineConst.FRAME_HEIGHT) + TimelineConst.FRAME_HEIGHT - TimelineConst.FRAME_RECT_OFFSET_Y;
					
				}else
				{
					checkShape.y = checkShapeMouseDownPoint.y;
					checkShape.height = TimelineConst.FRAME_HEIGHT - TimelineConst.FRAME_RECT_OFFSET_Y;
				}
			}
		}
		
		/**画范围鼠标抬起**/
		private function drawRangeStageMouseUpHandle(e:MouseEvent):void
		{
			endDrawRange();
		}
		
		/**鼠标抬起**/
		private function mouseUpHandle(e:MouseEvent):void
		{
			endDrawRange();
		}
		
		/**从指定位置帧画范围**/
		public function drawRangeFromRect(sX:int, sY:int):void
		{
			setCheckShapeMouseDownPoint(sX, sY);
			startDrawRange();
		}
		
		/**开始画范围**/
		private function startDrawRange():void
		{
			checkShape.mouseEnabled = false;
			keyframesC.mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_MOVE, mouseDownMoveHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP, drawRangeStageMouseUpHandle);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandle);
		}
		
		/**结束画范围**/
		private function endDrawRange():void
		{
			checkShape.mouseEnabled = true;
			keyframesC.mouseChildren = true;
			
			removeEventListener(MouseEvent.MOUSE_MOVE, mouseDownMoveHandle);
			stage.removeEventListener(MouseEvent.MOUSE_UP, drawRangeStageMouseUpHandle);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandle);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
			
			updateFramesCollection();
		}
		
		/**更新帧集合**/
		private function updateFramesCollection():void
		{
			checkShapeFramesCollection = [];
			
			var maxError:int = 1;
			var sX:int = checkShape.x - TimelineConst.FRAME_RECT_OFFSET_X - maxError;
			var eX:int = checkShape.x + checkShape.width - TimelineConst.FRAME_WIDTH + maxError;
			var sY:int = checkShape.y - TimelineConst.FRAME_RECT_OFFSET_Y - maxError;
			var eY:int = checkShape.y + checkShape.height - TimelineConst.FRAME_HEIGHT + maxError;
						
			var len:int = rectList.length;
			for(var i:int=0;i<len;i++)
			{
				var rect:TimelineRect = rectList[i] as TimelineRect;
				if(rect)
				{
//					trace("checkList:"+ rect.x +">="+ sX +" && "+ rect.x +"<="+ eX +" && "+ rect.y +">="+ sY +" && "+ rect.y +"<="+ eY);
					
					if(rect.x >= sX && rect.x <= eX && rect.y >= sY && rect.y <= eY)
					{
//						trace("	checked:"+ rect.x +">="+ sX +" && "+ rect.x +"<="+ eX +" && "+ rect.y +">="+ sY +" && "+ rect.y +"<="+ eY);
						rect.backgroundColor = 0xffffff;
						checkShapeFramesCollection.push(rect);
					}else
					{
						rect.backgroundColor = null;
					}
				}
			}
		}
		
		/**获得当前列**/
		public function getColByX(pX:int):int
		{
			var outX:int;
			pX = pX + TimelineConst.FRAME_RECT_OFFSET_X;
			outX = Math.ceil(pX/TimelineConst.FRAME_WIDTH);
			
			return outX;
		}
		
		/**获得当前行**/
		public function getRowByY(pY:int):int
		{
			var outY:int;
			pY = pY + TimelineConst.FRAME_RECT_OFFSET_Y;
			outY = Math.ceil(pY/TimelineConst.FRAME_HEIGHT);
			
			return outY;
		}
		
		
		/**绘制选中框**/
		private function drawCheckShape():void
		{
			if(!checkShape)
			{
				var cellW:int =  TimelineConst.FRAME_WIDTH - TimelineConst.FRAME_RECT_OFFSET_X;
				var cellH:int = TimelineConst.FRAME_HEIGHT - TimelineConst.FRAME_RECT_OFFSET_Y;
				
				checkShape = new UICanvas();
				checkShape.backgroundColor = 0xffffff;
				checkShape.backgroundAlpha = 0.5;
				checkShape.mouseEnabled = true;
				
				checkShapeC.addChild(checkShape);
								
				checkShape.width = cellW;
				checkShape.height = cellH;
								
				checkShape.addEventListener(MouseEvent.MOUSE_DOWN, onCheckShapeMouseDownHandle);
			}
		}
		
		/**绘制选中框拷贝**/
		private function drawCheckShapeCopy():void
		{
			if(checkShape)
			{
				if(!checkShapeCopy)
				{
					checkShapeCopy = new UICanvas();
					checkShapeC.addChild(checkShapeCopy);
					
					var deep:int = checkShapeC.getChildIndex(checkShape);
					checkShapeC.setChildIndex(checkShapeCopy, deep);
				}
				
				checkShapeCopy.x = checkShape.x;
				checkShapeCopy.y = checkShape.y;
				checkShapeCopy.width = checkShape.width;
				checkShapeCopy.height = checkShape.height;
				checkShapeCopy.backgroundColor = checkShape.backgroundColor;
				checkShapeCopy.alpha = 0.4;
				checkShapeCopy.visible = false;
			}
		}
		
		/**选中框鼠标按下**/
		private function onCheckShapeMouseDownHandle(e:MouseEvent):void
		{			
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
			
			checkShape.addEventListener(Event.ENTER_FRAME, onCheckShapeEnterFrameHandle);
			checkShape.addEventListener(MouseEvent.MOUSE_UP, onCheckShapeMouseUpHandle);
			stage.addEventListener(MouseEvent.MOUSE_UP, onCheckShapeDragStageMouseUpHandle);
			
			checkShapeMouseDownPoint.x = e.localX;
			checkShapeMouseDownPoint.y = e.localY;
			
			drawCheckShapeCopy();
			checkShapeCopy.visible = true;
			checkShape.backgroundAlpha = 0.7;
		}
		/**选中框拖动enterFrame**/
		private function onCheckShapeEnterFrameHandle(e:Event):void
		{
			/**左右**/
			var offX:int = mouseX - checkShapeMouseDownPoint.x - checkShape.x;
			if(Math.abs(offX) >= TimelineConst.FRAME_WIDTH)
			{
				checkShape.x = mouseX - checkShapeMouseDownPoint.x;
			}
			/**上下**/
//			var offY:int = mouseY - checkShapeMouseDownPoint.y - checkShape.y;
//			if(Math.abs(offY) >= TimelineConst.FRAME_HEIGHT)
//			{
//				checkShape.y = mouseY - checkShapeMouseDownPoint.y;
//			}
			
			correctCheckShapePlace();
		}
		/**纠正选中框位置**/
		private function correctCheckShapePlace():void
		{
			if(checkShape.x < 1)
			{
				checkShape.x = 1;
			}
			if(checkShape.y < 1)
			{
				checkShape.y = 1;
			}
			if(checkShape.x > (width-checkShape.width))
			{
				checkShape.x = (width-checkShape.width);
			}
			if(checkShape.y > (height-checkShape.height))
			{
				checkShape.y = (height-checkShape.height);
			}
			
			var modX:int = checkShape.x%TimelineConst.FRAME_WIDTH;
			if(modX > 0)
			{
				checkShape.x = checkShape.x - modX + TimelineConst.FRAME_RECT_OFFSET_X;
			}
						
			var modY:int = checkShape.y%TimelineConst.FRAME_HEIGHT;
			if(modY > 0)
			{
				checkShape.y = checkShape.y - modY + TimelineConst.FRAME_RECT_OFFSET_Y;
			}
									
		}
		/**选中框鼠标抬起**/
		private function onCheckShapeMouseUpHandle(e:MouseEvent):void
		{
			endCheckShapeDrap();
		}
		/**选中框拖动鼠标抬起**/
		private function onCheckShapeDragStageMouseUpHandle(e:MouseEvent):void
		{
			endCheckShapeDrap();
		}
		/**结束拖动**/
		private function endCheckShapeDrap():void
		{
			checkShape.removeEventListener(Event.ENTER_FRAME, onCheckShapeEnterFrameHandle);
			checkShape.removeEventListener(MouseEvent.MOUSE_UP, onCheckShapeMouseUpHandle);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onCheckShapeDragStageMouseUpHandle);
			
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandle);
			
			checkShapeCopy.visible = false;
			checkShape.backgroundAlpha = 0.5;
			
			if(checkShape.x == checkShapeCopy.x && checkShape.y == checkShapeCopy.y)
			{
				var col:int = getColByX(checkShape.x);
				var row:int = getRowByY(checkShape.y);
				
				var rect:TimelineRect = getRectByPlace(checkShape.x, checkShape.y);
				if(rect)
				{
					dispatchEvent(new TimelineEvent(TimelineEvent.SELECTED_ONE_FRAME, {id:rect.id, row:row, col:col}));
				}else
				{
					dispatchEvent(new TimelineEvent(TimelineEvent.SELECTED_ONE_FRAME, {id:"", row:row, col:col}));
				}
				
				return;
			}
			
			correctCheckShapePlace();
			overlapRectsInCheckShapeRange();
			resetCheckShapeFramesCollection();
			updateFramesCollection();
		}		
		/**覆盖选中范围内关键帧**/
		private function overlapRectsInCheckShapeRange():void
		{
			var sX:int = checkShape.x - TimelineConst.FRAME_RECT_OFFSET_X;
			var eX:int = checkShape.x + checkShape.width - TimelineConst.FRAME_WIDTH;
			var sY:int = checkShape.y - TimelineConst.FRAME_RECT_OFFSET_Y;
			var eY:int = checkShape.y + checkShape.height - TimelineConst.FRAME_HEIGHT;
			
			var len:int = rectList.length;
			for(var i:int=len-1;i>=0;i--)
			{
				var rect:TimelineRect = rectList[i] as TimelineRect;
				if(rect)
				{
					if(rect.x >= sX && rect.x <= eX && rect.y >= sY && rect.y <= eY)
					{
						var isInCollection:Boolean = checkRectIsInCheckShapeFramesCollection(rect);
						
						if(!isInCollection)
						{
							dispatchEvent(new TimelineEvent(TimelineEvent.DELETE_ONE_FRAME, {id:rect.id}));
							
							if(keyframesC.contains(rect))
							{
								keyframesC.removeChild(rect);
							}
							rect.dispose();
							rect = null;
							
							rectList.splice(i,1);
							
						}
						
					}
				}
			}			
		}
		/**检测关键帧是否在选中集合里**/
		private function checkRectIsInCheckShapeFramesCollection(rect:TimelineRect):Boolean
		{
			trace("rect:" + rect.id + "::" + rect.frame)
			for each(var collectionRect:TimelineRect in checkShapeFramesCollection)
			{
				trace("checkCollectionRect:" + collectionRect.id + "::" + collectionRect.frame)
				if(collectionRect && collectionRect == rect)
				{
					return true;
				}
			}
			return false;
		}
		
		/**重置选中框帧集合位置**/
		private function resetCheckShapeFramesCollection():void
		{
			var offX:int = checkShape.x - checkShapeCopy.x;
			var offY:int = checkShape.y - checkShapeCopy.y;
			for each(var rect:TimelineRect in checkShapeFramesCollection)
			{
				if(rect)
				{
					rect.x += offX;
					rect.y += offY;
					
					correctRectPlace(rect);
					
					var col:int = getColByX(rect.x);
					var row:int = getRowByY(rect.y);
					dispatchEvent(new TimelineEvent(TimelineEvent.CHANGE_ONE_FRAME, {id:rect.id, row:row, col:col, rect:rect}));
					
				}
			}
		}
				
		/**纠正关键帧位置**/
		private function correctRectPlace(rect:TimelineRect):void
		{
			var modX:int = rect.x%TimelineConst.FRAME_WIDTH;
			if(modX > 0)
			{
				rect.x = rect.x - modX + TimelineConst.FRAME_WIDTH;
			}
			
			var modY:int = rect.y%TimelineConst.FRAME_HEIGHT;
			if(modY > 0)
			{
				rect.y = rect.y - modY + TimelineConst.FRAME_HEIGHT;
			}
		}
		
		/**背景格子**/
		private function drawGrid():void
		{
			if(int(width) <= 0 || int(height) <= 0) return;
			
			graphics.clear();
			graphics.beginFill(0xCCC8C0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			var lenI:int = width / TimelineConst.FRAME_WIDTH;
			var lenJ:int = height / TimelineConst.FRAME_HEIGHT;
			graphics.lineStyle(1,0xA6A6A6);
			for(var i:int=0;i<lenI;i++)
			{
				for(var j:int=0;j<lenJ;j++)
				{
					/**格子顶线**/
					if(j == 0)
					{
						graphics.moveTo((i+1)*TimelineConst.FRAME_WIDTH, j*TimelineConst.FRAME_HEIGHT);
						graphics.lineTo(i*TimelineConst.FRAME_WIDTH, j*TimelineConst.FRAME_HEIGHT);
					}
					/**格子左线**/
					if(i == 0)
					{
						graphics.moveTo(i*TimelineConst.FRAME_WIDTH, j*TimelineConst.FRAME_HEIGHT);
						graphics.lineTo(i*TimelineConst.FRAME_WIDTH, (j+1)*TimelineConst.FRAME_HEIGHT);
					}
					/**格子下线、右线**/
					graphics.moveTo(i*TimelineConst.FRAME_WIDTH, (j+1)*TimelineConst.FRAME_HEIGHT);					
					graphics.lineTo((i+1)*TimelineConst.FRAME_WIDTH, (j+1)*TimelineConst.FRAME_HEIGHT);
					graphics.lineTo((i+1)*TimelineConst.FRAME_WIDTH, j*TimelineConst.FRAME_HEIGHT);
				}
				
			}
		}
		
		
		
	}
}

