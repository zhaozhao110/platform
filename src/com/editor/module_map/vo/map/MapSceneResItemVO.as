package com.editor.module_map.vo.map
{
	import com.editor.module_map.vo.map.interfaces.IMapSceneResVO;

	public class MapSceneResItemVO implements IMapSceneResVO
	{
		private var _id:String;
		private var _idNum:int;
		private var _type:int;
		private var _name:String; //名称
		private var _sourceId:String; //资源ID
		private var _sourceType:int; //资源类型
		private var _sourceName:String;
		private var _sceneId:String; //资源所属的场景层
		private var _index:int; //资源index
		private var _x:int; // 资源x
		private var _y:int; //资源y
		private var _scaleX:Number; //资源scaleX
		private var _scaleY:Number; //资源scaleY
		private var _rotation:int; //资源rotation
		private var _locked:int;
		private var _data:*; //扩展数据
		
		
		public function MapSceneResItemVO()
		{
		}
		
		public function clone():MapSceneResItemVO
		{
			var n:MapSceneResItemVO = new MapSceneResItemVO();
			
			n.type = this.type;
			n.sourceId = this.sourceId;
			n.sourceName = this.sourceName;
			n.sceneId = this.sceneId;
			n.x = this.x;
			n.y = this.y;
			n.scaleX = this.scaleX;
			n.scaleY = this.scaleY;
			n.rotation = this.rotation;
			n.data = this.data;
			
			return n;			
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

		public function get rotation():int
		{
			return _rotation;
		}

		public function set rotation(value:int):void
		{
			if(value < 0)
			{
				value = 0;
			}else if(value > 360)
			{
				value = 360;
			}
			_rotation = value;
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

		public function get sceneId():String
		{
			return _sceneId;
		}

		public function set sceneId(value:String):void
		{
			_sceneId = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
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

		/**2<=NPC、6<=场景动画、9<=场景背景**/
		public function get type():int
		{
			return _type;
		}

		/**2<=NPC、6<=场景动画、9<=场景背景**/
		public function set type(value:int):void
		{
			_type = value;
		}

		public function get locked():int
		{
			return _locked;
		}

		public function set locked(value:int):void
		{
			_locked = value;
		}

		public function get sourceType():int
		{
			return _sourceType;
		}

		public function set sourceType(value:int):void
		{
			_sourceType = value;
		}

		public function get idNum():int
		{
			var r:RegExp = /\d/igx;
			var curIdNum:int = int(_id.match(r).join(""));
			return curIdNum;
		}



	}
}