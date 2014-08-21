package com.editor.module_pop.serverDirManager.itemRenderer
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIText;
	import com.sandy.asComponent.event.ASEvent;
	import com.air.io.DownloadFile;

	public class ServerDirManagerBottomDownRenderer extends UICanvas
	{
		public function ServerDirManagerBottomDownRenderer()
		{
			super()
			create_init();
		}
		
		private var txt:UIText;
		private var downloadF:DownloadFile;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			percentWidth = 100;
			height = 50;
			
			txt = new UIText();
			txt.width = 800
			addChild(txt);
		}
		
		public function download(url:String,saveURL:String):void
		{
			downloadF = new DownloadFile();
			downloadF.addEventListener(ASEvent.COMPLETE , onDownloadComplete);
			downloadF.addEventListener(ASEvent.PROGRESS , onProgress);
			downloadF.addEventListener(ASEvent.OPEN , onOpen);
			downloadF.addEventListener(ASEvent.ERROR , onError);
			downloadF.download(url,saveURL);
		}
		
		private function onDownloadComplete(e:ASEvent):void
		{
			var data:* = downloadF.data;
			txt.htmlText = "下载完成 ... <br>" +  "从" + downloadF.getServerURL() + "<br>" + "保存到:" + downloadF.getSaveURL();
		}
		
		private function onProgress(e:ASEvent):void
		{
			txt.text = "下载进度:" + int(e.data*100) + " %" + "<br>" +  "从" + downloadF.getServerURL() + "<br>" + "保存到:" + downloadF.getSaveURL();
		}
		
		private function onOpen(e:ASEvent):void
		{
			txt.htmlText = "开始下载 ... <br>" +  "从" + downloadF.getServerURL() + "<br>" + "保存到:" + downloadF.getSaveURL();
		}
		
		private function onError(e:ASEvent):void
		{
			txt.htmlText = "开始失败 ... <br>" +  "从" + downloadF.getServerURL() + "<br>" + "保存到:" + downloadF.getSaveURL();
		}
		
	}
}