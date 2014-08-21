package com.editor.d3.pop.curveEditor
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.math.ArrayCollection;
	import com.sandy.math.QueueNode;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class CurveEditorGrid extends Sprite
	{
		public function CurveEditorGrid()
		{
			super();
			create_init();
		}
		
		public var lineCont:Sprite
		
		private function create_init():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,0x000000);
			//横向
			for(var i:int=0;i<=10;i++){
				this.graphics.moveTo(0,CurveEditor.tileHeight*i);
				this.graphics.lineTo(CurveEditor.gridWidth,CurveEditor.tileHeight*i);
			}
			//纵向
			for(i=0;i<=10;i++){
				this.graphics.moveTo(CurveEditor.tileWidth*i,0);
				this.graphics.lineTo(CurveEditor.tileWidth*i,CurveEditor.gridHeight);
			}
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			lineCont = new Sprite();
			addChild(lineCont);
		}
				
		public function reflashLine():void
		{
			lineCont.graphics.clear()
			lineCont.graphics.lineStyle(2,ColorUtils.blue);
			
			var a:ArrayCollection = CurveEditorData.queue.getList()
			var n:int = a.length;
			for(var i:int=0;i<n;i++){
				var qn:QueueNode = a.getItemAt(i) as QueueNode;
				var d:CurveEditorPointData = qn.data as CurveEditorPointData
				if(i==0){
					lineCont.graphics.moveTo(d.point.x,d.point.y);
				}else{
					lineCont.graphics.lineTo(d.point.x,d.point.y);
				}
			}
		}
		
		public function lineIntersectLine(param1:Point, param2:Point, param3:Point, param4:Point, param5:Boolean = true) : Point
		{
			var _loc_6:Point = null;
			var _loc_7:Number = NaN;
			var _loc_8:Number = NaN;
			var _loc_9:Number = NaN;
			var _loc_10:Number = NaN;
			var _loc_11:Number = NaN;
			var _loc_12:Number = NaN;
			var _loc_13:Number = NaN;
			_loc_7 = param2.y - param1.y;
			_loc_9 = param1.x - param2.x;
			_loc_11 = param2.x * param1.y - param1.x * param2.y;
			_loc_8 = param4.y - param3.y;
			_loc_10 = param3.x - param4.x;
			_loc_12 = param4.x * param3.y - param3.x * param4.y;
			_loc_13 = _loc_7 * _loc_10 - _loc_8 * _loc_9;
			if (_loc_13 == 0)
			{
				return null;
			}
			_loc_6 = new Point();
			_loc_6.x = (_loc_9 * _loc_12 - _loc_10 * _loc_11) / _loc_13;
			_loc_6.y = (_loc_8 * _loc_11 - _loc_7 * _loc_12) / _loc_13;
			if (param5)
			{
				if (Point.distance(_loc_6, param2) > Point.distance(param1, param2))
				{
					return null;
				}
				if (Point.distance(_loc_6, param1) > Point.distance(param1, param2))
				{
					return null;
				}
				if (Point.distance(_loc_6, param4) > Point.distance(param3, param4))
				{
					return null;
				}
				if (Point.distance(_loc_6, param3) > Point.distance(param3, param4))
				{
					return null;
				}
			}
			return _loc_6;
		}
		
	}
}