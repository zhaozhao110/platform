package com.editor.d3.pop.curveEditor
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.math.QueueNode;
	import com.sandy.utils.NumberUtils;
	import com.sandy.utils.interfac.IObjectPoolInterface;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CurveEditorPoint extends Sprite implements IObjectPoolInterface
	{
		public function CurveEditorPoint()
		{
			super();
			create_init();
		}
		
		public var node:QueueNode;
		
		public function get pointData():CurveEditorPointData
		{
			return node.data as CurveEditorPointData;
		}
		
		private function create_init():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xcc0000);
			this.graphics.drawCircle(5,5,5);
			this.graphics.endFill();
			
			mouseChildren = false;
			mouseEnabled = true;
			addEventListener(MouseEvent.MOUSE_DOWN , onDownHandle);
		}
		
		private function onDownHandle(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			CurveEditorDrawCont.dragPoint = this;
			this.stage.addEventListener(MouseEvent.MOUSE_UP , onUpHandle);
			this.stage.addEventListener(Event.MOUSE_LEAVE , onUpHandle);
		}
		
		public function onUpHandle(e:*=null):void
		{
			if(this.stage != null){
				this.stage.removeEventListener(MouseEvent.MOUSE_UP , onUpHandle);
			}
			CurveEditorDrawCont.dragPoint = null;
		}
		
		public function onRender():void
		{
			this.y = CurveEditor.instance.drawCont.mousePoint.y+5
			pointData.yn = CurveEditor.getYN(this.y+5)
			CurveEditor.instance.grid.reflashLine();
			CurveEditor.instance.locLB.text = "x:"+this.x+"/y:"+this.y+"/value:"+NumberUtils.toFixed(pointData.yn);
		}
		
		public function reflashData():void
		{
			pointData.reflashYN();
			this.y = pointData.point.y
		}
		
		public function testPoint(v:Number):Boolean
		{
			return pointData.testPoint(v);
		}
		
		public function removePoint():void
		{
			
		}
		
		override public function set x(value:Number):void
		{
			super.x = value-5
		}
		
		override public function set y(value:Number):void
		{
			super.y = value-5
		}
		
		
		
		/** 刷新 */ 
		public function poolChange(value:*):void{};
		
		/**创建时赋值 */ 
		public function poolSetValue(value:*):void{};
		
		/**摧毁 */ 
		public function poolDispose():void
		{
			onUpHandle();
		}
		
		/**索引 */ 
		public function set listIndex(value:int):void{
			
		}
		public function get listIndex():int{
			return 0;
		}
		
		/**所属的list */ 
		public function set uiowner(value:*):void{
			
		}
		public function get uiowner():*{
			return null;
		}
		
		
	}
}