package com.editor.popup.preImage
{
	import com.editor.component.containers.UICanvas;
	import com.editor.model.OpenPopwinData;
	import com.sandy.asComponent.core.ASBitmap;
	import com.sandy.asComponent.core.ASSprite;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.manager.data.KeyStringCodeConst;
	import com.sandy.math.SandyPoint;
	import com.sandy.math.SandyRectangle;
	import com.sandy.utils.BitmapDataUtil;
	import com.sandy.utils.NumberUtils;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class PreImageToolBar extends UICanvas
	{
		public function PreImageToolBar()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public var win:PreImagePopWin;
		public var bitmap:ASBitmap;
		
		//1:leftTop , 2:rightBot , 3: color
		private var mouseStatus:int;
		private var pre_bitmap_w:Number;
		private var pre_bitmap_h:Number;
		private var pre_bitmap_scale:Number;
		private var rect:Object = {};
		private var graphicsCont:ASSprite;
		
		private function reInit():void
		{
			onStageClick();
			win.txt.text = "";
			win.colTxt.text = "";
			pre_bitmap_h = bitmap.height;
			pre_bitmap_w = bitmap.width;
			pre_bitmap_scale = pre_bitmap_w/pre_bitmap_h;
			graphicsCont.graphics.clear();
			onImgDoubleClick();
		}
		
		public function init():void
		{
			if(graphicsCont!=null){
				reInit();
				return ;
			}
			reflashTxt();
			bitmap.mouseEnabled = true;
			bitmap.mouseChildren = false
			
			graphicsCont = new ASSprite();
			win.img.addChild(graphicsCont);
				
			reInit();
			
			win.leftTopBtn.toolTip = "右键取消操作"
			win.rightBotBtn.toolTip = "右键取消操作"	
			win.clearBtn.addEventListener(MouseEvent.CLICK , onClear);
			win.leftTopBtn.addEventListener(MouseEvent.MOUSE_DOWN , onLeftTopClick);
			win.rightBotBtn.addEventListener(MouseEvent.MOUSE_DOWN , onRightBotClick)
			bitmap.addEventListener(MouseEvent.CLICK,onBitmapClick)
			win.stage.addEventListener(MouseEvent.RIGHT_CLICK,onStageClick)
			win.stage.addEventListener(MouseEvent.MOUSE_MOVE , onMouseMove)
			win.getNativeWindow().addEventListener(Event.ACTIVATE , onStageClick);
			win.getNativeWindow().addEventListener(Event.DEACTIVATE,onStageClick);
			win.copyBtn.addEventListener(MouseEvent.CLICK , onCopy)
			win.colorBtn.addEventListener(MouseEvent.CLICK , onColor);
			win.img.addEventListener(MouseEvent.MOUSE_WHEEL , onBitmapWheel);
			bitmap.doubleClickEnabled = true;
			bitmap.addEventListener(MouseEvent.MOUSE_DOWN , onDragDown);
			bitmap.addEventListener(MouseEvent.MOUSE_MOVE , onDragMove);
			bitmap.addEventListener(MouseEvent.MOUSE_UP , onDragUp);
			bitmap.addEventListener(MouseEvent.DOUBLE_CLICK , onImgDoubleClick)
			win.restoreBtn.addEventListener(MouseEvent.CLICK , onImgDoubleClick);
			iManager.iKeybroad.addKeyDownListener(KeyStringCodeConst.SPACEBAR,onKeyDown);
			iManager.iKeybroad.addKeyUpListener(KeyStringCodeConst.SPACEBAR,onKeyUp);
						
			if((win.mediator.getOpenDataProxy() as OpenPopwinData).addData is Function){
				win.hb2.visible = true
			}else{
				win.hb2.visible = false
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			win.stage.removeEventListener(MouseEvent.MOUSE_MOVE , onMouseMove)
			iManager.iKeybroad.removeKeyDownListener(KeyStringCodeConst.SPACEBAR,onKeyDown);
			iManager.iKeybroad.removeKeyUpListener(KeyStringCodeConst.SPACEBAR,onKeyUp);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			reflashTxt();	
		}
				
		private function reflashTxt():void
		{
			win.txt.text = "宽：" + bitmap.width + "(原始"+pre_bitmap_w+")"+",高：" + bitmap.height+"(原始"+pre_bitmap_h+")";
			win.txt.text += "  /  " + "鼠标：x：" + win.img.mouseX + ",y："+win.img.mouseY;
			if(curr_pt!=null){
				win.txt.text += "/绘制图：x:"+Math.min(curr_pt.x,start_pt.x)+",y:"+Math.min(curr_pt.y,start_pt.y)+
					",width:"+NumberUtils.getPositiveNumber(start_pt.x-curr_pt.x)+",height:"+NumberUtils.getPositiveNumber(start_pt.y-curr_pt.y);
			}
		}
		
		private function onStageClick(e:*=null):void
		{
			isMouseDown = false
			onKeyUp();
			mouseStatus = 0;
			iManager.iCursor.setDefaultCursor();
		}
		
		private function onBitmapClick(e:MouseEvent):void
		{
			if(mouseStatus == 1){
				rect.x = win.img.mouseX;
				rect.y = win.img.mouseY;
			}
			if(mouseStatus == 2){
				rect.right = win.img.mouseX;
				rect.bottom = win.img.mouseY;
			}
			if(mouseStatus == 3){
				creatTempBitmap()				
				win.colTxt.text = "颜色值 ：0x"+maskBitmap.getPixel(bitmap.mouseX,bitmap.mouseY).toString(16);
			}
			
			reflashTxt9();
		}
		
		private function onImgDoubleClick(e:*=null):void
		{
			bitmap.width = pre_bitmap_w;
			bitmap.height = pre_bitmap_h;
			bitmap.x = 0;
			bitmap.y = 0;
		}
		
		
		//////////////////////////// mouse  //////////////////////////
		
		private var key_space_down:Boolean;
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == KeyStringCodeConst.SPACEBAR){
				key_space_down = true	
			}
		}
		
		private function onKeyUp(e:KeyboardEvent=null):void
		{
			if(e == null) return ;
			if(e.keyCode == KeyStringCodeConst.SPACEBAR){
				key_space_down = false;
			}
		}
		
		private var start_pt:SandyPoint;
		private var isMouseDown:Boolean;
		private function onDragDown(e:MouseEvent):void
		{
			isMouseDown = true;
			start_pt = new SandyPoint(bitmap.mouseX,bitmap.mouseY);
			if(key_space_down){
				bitmap.startDrag();
			}
		}
		
		private function onDragUp(e:MouseEvent):void
		{
			isMouseDown = false
			bitmap.stopDrag();
		}
		
		private var curr_pt:SandyPoint;
		
		private function onDragMove(e:MouseEvent):void
		{
			if(isMouseDown){
				graphicsCont.graphics.clear();
				curr_pt = new SandyPoint(bitmap.mouseX,bitmap.mouseY);
				graphicsCont.graphics.lineStyle(1,0xffffff);
				
				graphicsCont.graphics.moveTo(start_pt.x,start_pt.y);
				graphicsCont.graphics.lineTo(curr_pt.x,start_pt.y);
				graphicsCont.graphics.lineTo(curr_pt.x,curr_pt.y);
				graphicsCont.graphics.lineTo(start_pt.x,curr_pt.y);
				graphicsCont.graphics.lineTo(start_pt.x,start_pt.y);
				reflashTxt();
			}
		}
		
		private function onClear(e:MouseEvent):void
		{
			graphicsCont.graphics.clear();
		}
		
		/////////////////////////////// color ////////////////////////////////
		
		private var maskBitmap:BitmapData;
		private function creatTempBitmap():void
		{
			if(maskBitmap!=null){
				maskBitmap.dispose();
				maskBitmap = null;
			}
			maskBitmap = BitmapDataUtil.getBitmapData(bitmap.width,bitmap.height);
			maskBitmap.draw(bitmap,null,null,null,null,true);
		}
		
		private function onColor(e:MouseEvent):void
		{
			mouseStatus = 3;
			iManager.iCursor.setCursorBySign("color2_a",0,-22);
		}
		
		private function onBitmapWheel(e:MouseEvent):void
		{
			var factor:Number = NumberUtils.getPositiveNumber(e.delta)/10;
			if(e.delta>0){
				factor = 1+factor;
			}else{
				factor = 1-factor;
			}
			bitmap.width *= factor;
			bitmap.height *= factor;
		}
		
		
		////////////////////////////////// 9 rect ////////////////////////////////
		
		private function onCopy(e:MouseEvent):void
		{
			if((win.mediator.getOpenDataProxy() as OpenPopwinData).addData is Function){
				(win.mediator.getOpenDataProxy() as OpenPopwinData).addData("9rect,"+rect.x+","+rect.y+","+rect.right+","+rect.bottom);
			}
		}
		
		private function reflashTxt9():void
		{
			win.txt9.text = "left:"+int(rect.x)+",top:"+int(rect.y)+",right:"+int(rect.right)+",bottom:"+int(rect.bottom);
			
			graphics.clear();
			graphics.lineStyle(1,0xffffff);
			
			//上面的横线
			graphics.moveTo(0,rect.y);
			graphics.lineTo(bitmap.width,rect.y);
			
			//左边的竖线
			graphics.moveTo(rect.x,0);
			graphics.lineTo(rect.x,bitmap.height);
			
			//下边的横线
			graphics.moveTo(0,rect.bottom);
			graphics.lineTo(bitmap.width,rect.bottom);
			
			//右边的竖线
			graphics.moveTo(rect.right,0);
			graphics.lineTo(rect.right,bitmap.height);
		}
				
		
		
		private function onLeftTopClick(e:MouseEvent):void
		{
			mouseStatus = 1
			iManager.iCursor.setCursorBySign("arrow2_a",-2,-2);
		}
		
		private function onRightBotClick(e:MouseEvent):void
		{
			mouseStatus = 2;
			iManager.iCursor.setCursorBySign("arrow2_a",-2,-2);
		}
		
		
		
		
		
	}
}