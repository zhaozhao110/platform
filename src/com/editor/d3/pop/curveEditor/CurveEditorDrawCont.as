package com.editor.d3.pop.curveEditor
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.math.ArrayCollection;
	import com.sandy.math.QueueNode;
	import com.sandy.render2D.BitmapHitTest;
	import com.sandy.utils.ObjectPool;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class CurveEditorDrawCont extends Sprite
	{
		public function CurveEditorDrawCont()
		{
			super();
			
			this.mouseChildren = true;
			this.mouseEnabled = true;
						
			this.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onRightDown);
			this.addEventListener(MouseEvent.ROLL_OUT , onOutHandle);
			
			pointCont = new Sprite();
			addChild(pointCont);
		}
		
		public static var dragPoint:CurveEditorPoint;
		private var pointCont:Sprite;
		
		private function onOutHandle(e:MouseEvent):void
		{
			
		}
		
		private function onRightDown(e:MouseEvent):void
		{
			var p1:Point;
			var p2:Point;
			var p3:Point = new Point(this.mouseX,0);
			var p4:Point = new Point(this.mouseX,CurveEditor.gridHeight);
			var a:ArrayCollection = CurveEditorData.queue.getList()
			var n:int = a.length;
			for(var i:int=0;i<n;i++){
				var qn:QueueNode = a.getItemAt(i) as QueueNode;
				var d:CurveEditorPointData = qn.data as CurveEditorPointData
				if(d.point.x<this.mouseX){
					if(qn.next != null){
						if(this.mouseX<(qn.next.data as CurveEditorPointData).point.x){
							p1 = d.point;
							p2 = (qn.next.data as CurveEditorPointData).point;
							break;
						}
					}
				}
			}
			if(p1 != null&&p2!=null){
				var p5:Point = CurveEditor.instance.grid.lineIntersectLine(p1,p2,p3,p4);
				if(p5 == null) return ;
				addPoint(p5.x,p5.y);
			}
		}
		
		public function addPoint(_x:Number,_y:Number):void
		{
			var d:CurveEditorPointData = new CurveEditorPointData();
			d.xn = _x/CurveEditor.gridWidth
			d.yn = CurveEditor.getYN(_y);
						
			var p:CurveEditorPoint = new CurveEditorPoint();
			p.node = CurveEditorData.addPoint(d);
			pointCont.addChild(p);
			p.x = _x
			p.y = _y
		}
		
		public var mousePoint:CurveEditorPoint;
		public function createMousePoint():void
		{
			if(mousePoint != null) return ;
			mousePoint = new CurveEditorPoint();
			mousePoint.alpha = 0;
			addChild(mousePoint);
			mousePoint.mouseChildren = false;
			mousePoint.mouseEnabled = false;
		}
		
		public function onRender():void
		{
			if(dragPoint!=null){
				dragPoint.onRender();
			}
			
			if(this.mouseX<-5) return ;
			if(this.mouseY<-5) return ;
			if(this.mouseX>CurveEditor.gridWidth+5) return ;
			if(this.mouseY>CurveEditor.gridHeight+5) return ;
			mousePoint.x = this.mouseX;
			mousePoint.y = this.mouseY;
		}
		
		private function createPoint(d:QueueNode):void
		{
			var p:CurveEditorPoint = ObjectPool.getObject(CurveEditorPoint);
			p.node = d;
			pointCont.addChild(p);
			p.x = (d.data as CurveEditorPointData).point.x
			p.y = (d.data as CurveEditorPointData).point.y
		}
		
		public function removeAllPoint():void
		{
			ObjectPool.disposeContainer(pointCont);
		}
		
		public function reflashLine():void
		{
			removeAllPoint();
			
			var a:ArrayCollection = CurveEditorData.queue.getList()
			var n:int = a.length;
			for(var i:int=0;i<n;i++){
				var qn:QueueNode = a.getItemAt(i) as QueueNode;
				createPoint(qn);
			}
		}
		
		public function reflashPoint():void
		{
			var n:Number = pointCont.numChildren;
			for(var i:int=0;i<n;i++){
				CurveEditorPoint(pointCont.getChildAt(i)).reflashData();
			}
		}
		
		public function testPoint(v:Number):Boolean
		{
			var n:Number = pointCont.numChildren;
			for(var i:int=0;i<n;i++){
				var b:Boolean = CurveEditorPoint(pointCont.getChildAt(i)).testPoint(v);
				if(!b) return false;
			}
			return true;
		}
		
	}
}