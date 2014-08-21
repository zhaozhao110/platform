package com.editor.module_ui.ui
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_ui.view.uiAttri.ComAlignCell;
	import com.editor.module_ui.vo.UITreeNode;
	import com.sandy.math.SandyPoint;
	import com.sandy.math.SandyRectangle;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.NumberUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class UIShowRectSpr extends UICanvas
	{
		public function UIShowRectSpr()
		{
			super();
			
			visible = false
			mouseChildren = false;
			mouseEnabled = true;
			
			selectRect_sp = new Sprite();
			addChild(selectRect_sp);
			
			addEventListener(MouseEvent.MOUSE_DOWN,mapEditCanvasMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE,mapEditCanvasMove);
			addEventListener(MouseEvent.MOUSE_UP,mapEditCanvasUp);
		}
		
		private var selectRect_sp:Sprite;
				
		private var mouseDowned:Boolean;
		private var mouseDown_pt:SandyPoint = new SandyPoint();
		private var rect:SandyRectangle = new SandyRectangle();
		
		private function mapEditCanvasMouseDown(evet:MouseEvent):void
		{
			mouseDown_pt.x = this.mouseX;
			mouseDown_pt.y = this.mouseY;
			mouseDowned = true;
		}
		
		private function mapEditCanvasMove(evet:MouseEvent):void
		{
			if(mouseDowned){
				
				var start_pt:SandyPoint = mouseDown_pt;
				var curr_pt:SandyPoint = new SandyPoint(this.mouseX,this.mouseY);
				
				var w:int = NumberUtils.getPositiveNumber(curr_pt.x-start_pt.x);
				var h:int = NumberUtils.getPositiveNumber(curr_pt.y-start_pt.y);
				
				selectRect_sp.graphics.clear();
				selectRect_sp.graphics.lineStyle(2,ColorUtils.white);
				if(start_pt.x<curr_pt.x){
					if(start_pt.y<curr_pt.y){
						rect.x = start_pt.x;
						rect.y = start_pt.y;
						rect.width = w;
						rect.height = h;
						selectRect_sp.graphics.drawRect(start_pt.x,start_pt.y,w,h);		
					}else{
						rect.x = start_pt.x;
						rect.y = curr_pt.y;
						rect.width = w;
						rect.height = h;
						selectRect_sp.graphics.drawRect(start_pt.x,curr_pt.y,w,h);
					}
				}else{
					if(start_pt.y<curr_pt.y){
						rect.x = curr_pt.x;
						rect.y = start_pt.y;
						rect.width = w;
						rect.height = h;
						selectRect_sp.graphics.drawRect(curr_pt.x,start_pt.y,w,h);		
					}else{
						rect.x = curr_pt.x;
						rect.y = curr_pt.y;
						rect.width = w;
						rect.height = h;
						selectRect_sp.graphics.drawRect(curr_pt.x,curr_pt.y,w,h);
					}
				}
				
				selectRect_sp.graphics.endFill();
				
			}
		}
		
		private function mapEditCanvasUp(evet:Event=null):void
		{
			if(mouseDowned){
				//框选
				var start_pt:SandyPoint = mouseDown_pt;
				var curr_pt:SandyPoint = new SandyPoint(this.mouseX,this.mouseY);
				var a:Array = UIEditManager.currEditShowContainer.cache.getAllComp();
				var b:Array = [];
				for each(var n:UITreeNode in a){
					if(n!=null&&n.obj is UIShowCompProxy){
						var p:UIShowCompProxy = n.obj as UIShowCompProxy;
						if(p.target.width >0 && p.target.height > 0){
							var uiRect:SandyRectangle = p.target.getSizeRect();
							if(rect.intersects(uiRect)){
								p.target.showBorderInUIEdit(true,ColorUtils.red);
								b.push(p)
							}
						}
					}
				}
				ComAlignCell.instance.setSelectComp(b);
			}
			
			hideSelectRect();
			mouseDowned = false;
		}
		
		override protected function uiShow():void
		{
			super.uiShow();
			hideSelectRect()
		}
		
		private function hideSelectRect():void
		{
			selectRect_sp.graphics.clear();
		}
		
	}
}