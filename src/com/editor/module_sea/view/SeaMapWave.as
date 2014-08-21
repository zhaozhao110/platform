package com.editor.module_sea.view
{
	import com.editor.component.containers.UICanvas;
	import com.sandy.manager.timer.ISandyFrameTimer;
	import com.sandy.manager.timer.ISandyTimer;
	import com.sandy.math.SandyRectangle;
	import com.sandy.utils.BitmapDataUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;

	public class SeaMapWave extends UICanvas
	{
		public function SeaMapWave()
		{
			super();
			
			
		}
		
		public static var waveBitmap:Bitmap;
		
		public static const wave_w:int = 512;
		public static const wave_h:int = 512;
		
		private var bitmap_ls:Array = [];
		
		public function draw():void
		{
			width = wave_w;
			height = wave_h;
			
			for2:for(var j:int=0;j<4;j++){
				for(var i:int=0;i<2;i++){
					if(j == 3 && i == 1) break for2;
					var rect:SandyRectangle = new SandyRectangle(-i*wave_w,-j*wave_h,wave_w,wave_h);
					var b:Bitmap = new Bitmap(BitmapDataUtil.drawClip(waveBitmap,rect));
					b.visible = false;
					addChild(b);
					bitmap_ls.push(b);
				}
			}
			
			var ind:int = parent.getChildIndex(this);
			if(parent.numChildren > (ind+1)){
				(parent.getChildAt(ind+1) as SeaMapWave).draw();
			}
			
			runTime();
		}
		
		private function runTime():void
		{
			var it:ISandyFrameTimer = iManager.iTimer.createSandyFrameTimer()
			it.sign = "wave_"+parent.getChildIndex(this)
			it.timer_fun = drawWave;
			iManager.iTimer.addFrameTimer(it);
		}
		
		private var frame_i:int;
		private function drawWave(e:*=null):void
		{
			frame_i += 1;
			if(frame_i >= 10){
				_drawWave();
				frame_i = 0;
			}
		}
		
		private var showInd:int;
		
		private function _drawWave(e:*=null):void
		{
			if(showInd > 0){
				bitmap_ls[showInd-1].visible = false;	
			}
			if(showInd >= bitmap_ls.length){
				showInd = 0;
			}
			bitmap_ls[showInd].visible = true;
			showInd += 1;
		}
		
	}
}