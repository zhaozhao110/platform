package com.editor.d3.pop.preTexture
{
	import com.air.component.SandyAIRImage;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.tool.D3AIRImage;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.FilterTool;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class App3DPreTextureWinItemRenderer extends SandyBoxItemRenderer
	{
		public function App3DPreTextureWinItemRenderer()
		{
			super();
		
			create_init();
			
		}
		
		private var img:D3AIRImage;
		private var txt:UILabel;
		
		private function create_init():void
		{
			width = 75;
			height = 90 ;
			backgroundColor = 0x333333;
			
			img = new D3AIRImage();
			img.width = 75;
			img.height = 75;
			addChild(img);
			
			txt = new UILabel();
			addChild(txt);
			txt.width = 75;
			txt.color = ColorUtils.white;
			txt.textAlign = "center";
			txt.y = 76;
			
		}
		
		public function getBitmap():Bitmap
		{
			return img.content as Bitmap;
		}
		
		private var file:File;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			file = value as File;
			//img.source = file;
			txt.text = file.name;
			
			App3DPreTextureWin.loadQueue.addQueue(this);
		}
		
		override public function get laterTime():Number
		{
			return 100;
		}
		
		override public function queue():void
		{
			img.source = file;
			
			callDoQueueNext()
		}
		
		override public function select():void
		{
			super.select();
			FilterTool.setGlow(this);
		}
		
		override public function noSelect():void
		{
			super.noSelect();
			this.filters = null;
		}
		
	}
}