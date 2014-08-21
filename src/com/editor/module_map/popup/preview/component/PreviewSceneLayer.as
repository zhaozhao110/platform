package com.editor.module_map.popup.preview.component
{
	import com.editor.component.containers.UICanvas;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class PreviewSceneLayer extends PreviewDisplayObject
	{
		public var sceneId:String;
				
		/**是否允许运行**/
		private var runBool:Boolean;
		
		/**是否默认左右速度**/
		private var _useHDefaultSpeed:int=1;
		/**左右速度**/
		private var _horirontalMoveSpeed:Number;
		/**是否默认层**/
		public var isDefault:int;
		
		/**上下移动队列列表**/
		private var verticalMoveQueue:Array = [];
		private var verticalMoveQueueLeng:int = 0;
		private var verticalMoveQueueIndex:int = 0;
		
		/**上下当前移动队列**/
		private var verticalMoveFrameList:Array = [];
		private var verticalMoveFrames:int = 0;
		private var verticalMoveFrame:int = 0;
		
		/**上下移动层原点**/
		private var verticalContainer_originX:int = 0;
		private var verticalContainer_originY:int = 0;
		
		/**旋转移动队列列表**/
		private var rotationMoveQueue:Array = [];
		private var rotationMoveQueueLeng:int = 0;
		private var rotationMoveQueueIndex:int = 0;
		
		/**旋转当前移动队列**/
		private var rotationMoveFrameList:Array = [];
		private var rotationMoveFrames:int = 0;
		private var rotationMoveFrame:int = 0;
		
		/**当前播放帧数**/
		private var currentFrame:int = 0;
		
		/**特效计时播放队列**/
		private var mcStartFrameList:Array = [];
		private var mcStartFrameListLeng:int;
		
		
		public function PreviewSceneLayer()
		{
			super();
			create_init();
		}
		
		/**上下移动窗口**/
		private var verticalContainer:UICanvas;
		/**左右移动窗口**/
		private var rotationContainer:UICanvas;
		private function create_init():void
		{
			rotationContainer = new UICanvas();
			addChild(rotationContainer);
			verticalContainer = new UICanvas();
			rotationContainer.addChild(verticalContainer);
		}
		
		/**添加子**/
		public function addSprite(s:PreviewSceneSprite):void
		{
			verticalContainer.addChild(s);
			if(s.startFrame >= 0)
			{
				mcStartFrameList.push(s);
				mcStartFrameListLeng = mcStartFrameList.length;
				runBool = true;
			}
		}
		
		/**运行**/
		public function runStep():void
		{
			if(!runBool) return;
			
			currentFrame ++;
			
			stepVertical();
			stepRotation();
			stepMC();
		}
		
		/**上下运动**/
		private function stepVertical():void
		{
			if(verticalMoveQueueLeng > 0)
			{
				if(verticalMoveFrame && verticalMoveFrame > verticalMoveFrames-1)
				{
					var vQueueObj:Object = verticalMoveQueue[verticalMoveQueueIndex] as Object;
					if(vQueueObj)
					{
						verticalMoveFrameList = [];
						
						var startPoint:Point = vQueueObj.startPoint;
						var endPoint:Point = vQueueObj.endPoint;
						var speed:Number = vQueueObj.speed;
						if(startPoint && endPoint && speed)
						{
							var lenX:int = Math.abs((endPoint.x - startPoint.x)/speed);
							var lenY:int = Math.abs((endPoint.y - startPoint.y)/speed);
							var len:int = (lenX > lenY) ? lenX : lenY;
							
							var xDistance:Number = (endPoint.x - startPoint.x)/len;
							var yDistance:Number = (endPoint.y - startPoint.y)/len;
							
							var curX:Number = startPoint.x;
							var curY:Number = startPoint.y;
							for(var i:int=0;i<=len;i++)
							{								
								curX += xDistance;
								curY += yDistance;
								verticalMoveFrameList.push({x:int(curX), y:int(curY)});
							}
							verticalMoveFrames = verticalMoveFrameList.length;
							verticalMoveFrame = 0;
							
							moveVerticalContainer();
							
						}
						
						
					}
					if(verticalMoveQueueIndex > verticalMoveQueueLeng-1)
					{
						verticalMoveQueueIndex = 0;
						
					}else
					{
						verticalMoveQueueIndex ++;					
					}
				}else
				{
					moveVerticalContainer();
				}
			}
		}
		
		/**旋转运动**/
		private function stepRotation():void
		{
			if(rotationMoveQueueLeng > 0)
			{
				if(rotationMoveFrame && rotationMoveFrame > rotationMoveFrames-1)
				{
					var rQueueObj:Object = rotationMoveQueue[rotationMoveQueueIndex] as Object;
					if(rQueueObj)
					{
						rotationMoveFrameList = [];
						
						var startRotation:int = rQueueObj.startRotation;
						var endRotation:int = rQueueObj.endRotation;
						var centerPointX:int = rQueueObj.centerPointX;
						var centerPointY:int = rQueueObj.centerPointY;
						var speed:Number = rQueueObj.speed;
						
						var len:int = Math.abs((endRotation - startRotation)/speed);
						var rDistance:Number = (endRotation - startRotation)/len;
						var curR:Number = startRotation;
						for(var i:int=0;i<len;i++)
						{
							curR += rDistance;
							rotationMoveFrameList.push({r:int(curR)});
						}
						
						rotationMoveFrames = rotationMoveFrameList.length;
						rotationMoveFrame = 0;
						
						if(rotationContainer.x != centerPointX || rotationContainer.y != centerPointY)
						{							
							rotationContainer.x = centerPointX;
							rotationContainer.y = centerPointY;
							
							verticalContainer_originX = -centerPointX;
							verticalContainer_originY = -centerPointY;
							if(verticalMoveQueueLeng <= 0)
							{
								verticalContainer.x = -centerPointX;
								verticalContainer.y = -centerPointY;								
							}
						}
						
						moveRotationContainer();
						
					}
					
					if(rotationMoveQueueIndex > rotationMoveQueueLeng-1)
					{
						rotationMoveQueueIndex = 0;
						
					}else
					{
						rotationMoveQueueIndex ++;					
					}
				}else
				{
					moveRotationContainer();
				}
			}			
		}
		
		/**特效计时**/
		private function stepMC():void
		{
			if(mcStartFrameListLeng > 0)
			{
				for(var i:int=mcStartFrameListLeng-1;i>=0;i--)
				{
					var s:PreviewSceneSprite = mcStartFrameList[i] as PreviewSceneSprite;
					if(s)
					{
						if(s.startFrame <= currentFrame)
						{
							s.visible = true;
							s.playRes();
							mcStartFrameList.splice(i,1);
							mcStartFrameListLeng = mcStartFrameList.length;
							if(mcStartFrameListLeng <= 0 && verticalMoveQueueLeng <= 0 && rotationMoveQueueLeng <= 0)
							{
								runBool = false;
							}
							
						}else
						{
							s.visible = false;
						}
						
					}
				}
			}
		}
		
		/**改变上下移动层位置**/
		private function moveVerticalContainer():void
		{
			var obj:Object = verticalMoveFrameList[verticalMoveFrame];
			verticalMoveFrame ++;
			if(obj)
			{
				verticalContainer.x = obj.x + verticalContainer_originX;
				verticalContainer.y = obj.y + verticalContainer_originY;
			}
		}
		
		/**改变旋转层位置**/
		private function moveRotationContainer():void
		{
			var obj:Object = rotationMoveFrameList[rotationMoveFrame];
			rotationMoveFrame ++;
			if(obj)
			{
				rotationContainer.rotation = obj.r;
			}
		}
		
		/**使用左右默认速度**/
		public function get useHDefaultSpeed():int
		{
			return _useHDefaultSpeed;
		}		
		/**使用左右默认速度**/
		public function set useHDefaultSpeed(value:int):void
		{
			_useHDefaultSpeed = value;
		}
		
		/**设置左右速度**/
		public function set horirontalMoveSpeed(val:Number):void
		{
			_horirontalMoveSpeed = val;
			
		}
		/**获取左右速度**/
		public function get horirontalMoveSpeed():Number
		{
			return _horirontalMoveSpeed;
		}
		/**设置上下移动队列**/
		public function setVerticalMoveQueue(s:String):void
		{
			if(!s || s == "") return;
			
			verticalMoveQueue = [];
			
			var a:Array = s.split("*");
			for(var i:int=0;i<a.length;i++)
			{
				var itemS:String = String(a[i]);
				var itemA:Array = itemS.split(",");
				if(itemA.length >= 5)
				{
					var obj:Object = {};
					obj.startPoint = new Point(int(itemA[0]), int(itemA[1]));
					obj.endPoint = new Point(int(itemA[2]), int(itemA[3]));
					obj.speed = Number(itemA[4]);
					
					verticalMoveQueue.push(obj);					
				}
				
				
			}
			
			verticalMoveQueueLeng = verticalMoveQueue.length;
			verticalMoveQueueIndex = 0;
			verticalMoveFrames = 0;
			verticalMoveFrame = 0;
			
			if(verticalMoveQueueLeng > 0)
			{
				runBool = true;
			}
		}
		/**设置旋转移动队列**/
		public function setRotationMoveQueue(s:String):void
		{
			if(!s || s == "") return;
			
			rotationMoveQueue = [];
			
			var a:Array = s.split("*");
			for(var i:int=0;i<a.length;i++)
			{
				var itemS:String = String(a[i]);
				var itemA:Array = itemS.split(",");
				if(itemA.length >= 5)
				{
					var obj:Object = {};
					obj.startRotation = int(itemA[0]);
					obj.endRotation = int(itemA[1]);
					obj.centerPointX = int(itemA[2]);
					obj.centerPointY = int(itemA[3]);
					obj.speed = Number(itemA[4]);
					
					rotationMoveQueue.push(obj);
				}
			}
			
			rotationMoveQueueLeng = rotationMoveQueue.length;
			rotationMoveQueueIndex = 0;
			rotationMoveFrames = 0;
			rotationMoveFrame = 0;
			
			if(rotationMoveQueueLeng > 0)
			{
				runBool = true;
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			
			var len:int = verticalContainer.numChildren;
			for(var i:int=len-1;i>=0;i--)
			{
				var sp:PreviewSceneSprite = verticalContainer.getChildAt(i) as PreviewSceneSprite;
				if(sp)
				{
					sp.dispose();
					verticalContainer.removeChild(sp);
					sp = null;
				}
			}
			
			verticalContainer = null;
			
		}

		
		
		
	}
}