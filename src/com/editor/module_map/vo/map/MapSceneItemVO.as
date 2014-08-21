package com.editor.module_map.vo.map
{
	import com.editor.module_map.vo.map.interfaces.IMapSceneVO;

	public class MapSceneItemVO implements IMapSceneVO
	{
		private var _id:String;
		private var _type:int;
		private var _sourceId:String; //场景ID
		private var _sourceName:String;
		private var _index:int; //场景index
		private var _x:int;//初始x
		private var _y:int; //初始y
		public var width:int;
		public var height:int;
		public var spawnX:int; //产出点X
		public var spawnY:int; //产出点Y
		public var isDefault:int;
		public var range:String;
		/**使用左右默认速度**/
		public var useHDefaultSpeed:int;
		public var horizontalSpeed:Number; //场景左右速度
		public var verticalMoveQueue:String; //场景上下移动序列 vMoveQueue ="startX,startY,endX,endY,speed*startX,startY,endX,endY,speed" "10,20,6*20,40,5*40,5,10"
		public var rotationMoveQueue:String; //场景旋转序列
		private var _data:*;
		
		
		public function MapSceneItemVO()
		{
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
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

		public function get sourceId():String
		{
			return _sourceId;
		}

		public function set sourceId(value:String):void
		{
			_sourceId = value;
		}

		public function get sourceName():String
		{
			return _sourceName;
		}

		public function set sourceName(value:String):void
		{
			_sourceName = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function get data():*
		{
			return _data;
		}

		public function set data(value:*):void
		{
			_data = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}


	}
}