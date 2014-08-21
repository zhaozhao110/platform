package com.editor.module_pop.serverDirManager.itemRenderer
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIText;
	import com.sandy.asComponent.event.ASEvent;
	import com.air.io.UploadFile;
	
	import flash.net.URLVariables;

	public class ServerDirManagerBottomUploadRenderer extends UICanvas
	{
		public function ServerDirManagerBottomUploadRenderer()
		{
			super()
			create_init();
		}
		
		private var txt:UIText;
		private var uploadF:UploadFile;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			percentWidth = 100;
			height = 50;
			
			txt = new UIText();
			txt.width = 800
			addChild(txt);
		}
		
		public function upload(url:String,saveURL:String,args:URLVariables):void
		{
			uploadF = new UploadFile();
			uploadF.addEventListener(ASEvent.COMPLETE , onDownloadComplete);
			uploadF.addEventListener(ASEvent.PROGRESS , onProgress);
			uploadF.addEventListener(ASEvent.OPEN , onOpen);
			uploadF.addEventListener(ASEvent.ERROR , onError);
			uploadF.upload(url,saveURL,args);
		}
		
		private function onDownloadComplete(e:ASEvent):void
		{
			//var data:* = uploadF.data;
			txt.htmlText = "上传完成 ... <br>" +  "从" + uploadF.getSaveURL() + "<br>" + "上传到:" + uploadF.getServerURL()
		}
		
		private function onProgress(e:ASEvent):void
		{
			txt.text = "上传进度:" + int(e.data*100) + " %" + "<br>" +  "从" + uploadF.getSaveURL() + "<br>" + "上传到:" + uploadF.getServerURL();
		}
		
		private function onOpen(e:ASEvent):void
		{
			txt.htmlText = "开始上传 ... <br>" +  "从" + uploadF.getSaveURL() + "<br>" + "上传到:" + uploadF.getServerURL();
		}
		
		private function onError(e:ASEvent):void
		{
			txt.htmlText = "开始失败 ... <br>" +  "从" + uploadF.getSaveURL() + "<br>" + "上传到:" + uploadF.getServerURL();
		}
		
	}
}