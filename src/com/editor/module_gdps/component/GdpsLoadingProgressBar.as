package com.editor.module_gdps.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;

	public class GdpsLoadingProgressBar extends UICanvas
	{
		public function GdpsLoadingProgressBar()
		{
			super();
			create_init();
		}
		
		public var progressMsg:UILabel;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			mouseChildren = false;
			mouseEnabled = true;
			
			var back:UICanvas = new UICanvas();
			back.enabledPercentSize = true;
			back.backgroundColor = 0x000000;
			back.backgroundAlpha = 0.3;
			addChild(back);
				
			var hbox:UIHBox = new UIHBox();
			hbox.name = "hbox123"
			hbox.height = 40;
			hbox.width = 260;
			hbox.verticalAlign = "middle";
			hbox.horizontalAlign = "center";
			hbox.verticalCenter = 0;
			hbox.horizontalCenter = 0;
			hbox.backgroundColor = 0x406c99;
			hbox.paddingLeft = 10;
			hbox.paddingRight = 10;
			hbox.paddingTop = 5;
			hbox.paddingBottom = 5;
			addChild(hbox);
			
			progressMsg = new UILabel();
			progressMsg.textAlign = "center";
			progressMsg.color = 0xFFFFFF;
			progressMsg.percentWidth = 100;
			progressMsg.fontSize = 12;
			progressMsg.verticalCenter = 0;
			hbox.addChild(progressMsg);
			
			
			initComplete();
		}
		
		public function hideBar():void
		{
			this.visible = false;	
		}
		
		public function showBar():void
		{
			this.visible = true;
		}
		
		public function setProgressMsg(msg:String):void
		{
			progressMsg.htmlText = msg;
		}
		
		public function clearProgressMsg():void
		{
			progressMsg.htmlText = "";
		}
	}
}