package com.editor.moudule_drama.timeline.vo
{
	import com.editor.moudule_drama.timeline.vo.interfaces.ITimelineViewProperties_BaseVO;
	
	import flash.display.DisplayObject;

	/**
	 * 显示对象属性状态
	 * @author sun <br>
	 * 
	 * play,loop,visible 1=true 0=false
	 * 
	 */	
	public class TimelineViewProperties_BaseVO implements ITimelineViewProperties_BaseVO
	{
		private var _targetId:String;
		private var _x:int;
		private var _y:int;
		private var _width:int;
		private var _height:int;
		private var _index:int;
		private var _alpha:Number;
		private var _scaleX:Number;
		private var _scaleY:Number;
		private var _rotation:int;
		private var _play:int;
		private var _playParameters:String;
		private var _loop:int;
		private var _data:*;
		public function TimelineViewProperties_BaseVO()
		{
			alpha = 1;
			scaleX = 1;
			scaleY = 1;
		}
		
		public function clone():ITimelineViewProperties_BaseVO
		{
			var cloneObj:TimelineViewProperties_BaseVO = new TimelineViewProperties_BaseVO();
			
			/**supers**/
			cloneObj.targetId = targetId;
			cloneObj.x = x;
			cloneObj.y = y;
			cloneObj.width = width;
			cloneObj.height = height;
			cloneObj.index = index;
			cloneObj.alpha = alpha;
			cloneObj.scaleX = scaleX;
			cloneObj.scaleY = scaleY;
			cloneObj.play = play;
			cloneObj.playParameters = playParameters;
			cloneObj.loop = loop;
			cloneObj.data = data;
						
			return cloneObj;
		}
		
		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
		}

		public function get width():int
		{
			return _width;
		}

		public function set width(value:int):void
		{
			_width = value;
		}

		public function get height():int
		{
			return _height;
		}

		public function set height(value:int):void
		{
			_height = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function get alpha():Number
		{
			return _alpha;
		}

		public function set alpha(value:Number):void
		{
			_alpha = value;
		}

		public function get scaleX():Number
		{
			return _scaleX;
		}

		public function set scaleX(value:Number):void
		{
			var outVal:Number = Number(value.toFixed(2));
			if(Math.abs(Math.abs(outVal) - 1) < 0.05)
			{
				if(outVal > 0)
				{
					outVal = 1;					
				}
			}
			_scaleX = outVal;
		}

		public function get scaleY():Number
		{
			return _scaleY;
		}

		public function set scaleY(value:Number):void
		{
			var outVal:Number = Number(value.toFixed(2));
			if(Math.abs(Math.abs(outVal) - 1) < 0.05)
			{
				if(outVal > 0)
				{
					outVal = 1;					
				}
			}
			_scaleY = outVal;
		}

		public function get play():int
		{
			return _play;
		}

		public function set play(value:int):void
		{
			_play = value;
		}

		public function get playParameters():String
		{
			return _playParameters;
		}

		public function set playParameters(value:String):void
		{
			_playParameters = value;
		}

		public function get loop():int
		{
			return _loop;
		}

		public function set loop(value:int):void
		{
			_loop = value;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}

		public function get rotation():int
		{
			return _rotation;
		}

		public function set rotation(value:int):void
		{
			_rotation = value;
		}

		public function get targetId():String
		{
			return _targetId;
		}

		public function set targetId(value:String):void
		{
			_targetId = value;
		}

		
	}
}