package com.editor.d3.pop.curveEditor
{
	import com.sandy.utils.NumberUtils;
	
	import flash.geom.Point;

	public class CurveEditorPointData
	{
		public function CurveEditorPointData()
		{
		}
		
		public var x:Number;
		private var y:Number;
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.type = 0;
			obj.x = NumberUtils.toFixed(xn);
			obj.y = NumberUtils.toFixed(yn);
			return obj;
		}
		
		public function get point():Point
		{
			return new Point(x,y);
		}
		
		private var _xn:Number;
		public function get xn():Number
		{
			return _xn;
		}
		public function set xn(value:Number):void
		{
			_xn = value;
			var n:Number = value/1;
			x = n*CurveEditor.gridWidth
		}
		
		private var _yn:Number;
		public function get yn():Number
		{
			return _yn;
		}
		public function set yn(value:Number):void
		{
			_yn = value;
			reflashYN()
		}
		
		public function reflashYN():void
		{
			var n:Number = yn/CurveEditor.instance.maximum;
			y = n*CurveEditor.gridHeight/2;
			if(yn > 0){
				y = CurveEditor.gridHeight/2 - y
			}else if(yn < 0){
				y = CurveEditor.gridHeight/2 + NumberUtils.getPositiveNumber(y);
			}else{
				y = CurveEditor.gridHeight/2
			}
		}
		
		public function testPoint(v:Number):Boolean
		{
			var n:Number = yn/v;
			var _y:Number = n*CurveEditor.gridHeight/2;
			if(yn > 0){
				_y = CurveEditor.gridHeight/2 - _y
			}else if(yn < 0){
				_y = CurveEditor.gridHeight/2 + NumberUtils.getPositiveNumber(_y);
			}else{
				_y = CurveEditor.gridHeight/2
			}
			if(_y > CurveEditor.gridHeight){
				return false
			}
			if(_y<0){
				return false;
			}
			return true;
		}
		
	}
}