package com.editor.popup.readPdf
{
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.html.HTMLLoader;

	public class ReadPdfPopwupinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ReadPdfPopwupinMediator"
		public function ReadPdfPopwupinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():ReadPdfPopwupin
		{
			return viewComponent as ReadPdfPopwupin;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function openFile():void
		{
			SelectFile.selectByFilter("pdf","pdf",openFileResult);
		}
		
		private function openFileResult(e:Event):void
		{
			var f:File = e.target as File;
			writeCache(f.nativePath)
			setLocation()
		}
		
		private function setLocation():void
		{
			//trace(HTMLLoader.pdfCapability);
			win.html.loadURL("app-storage:/readPdf.html",true);
		}
		
		private function getFile():File
		{
			return new File(File.applicationStorageDirectory.nativePath + File.separator+ "readPdf.html");
		}
		
		private function writeCache(fn:String):String
		{
			var c:String = '<html><body><object id="PDFObj" data="file:///c:/1.pdf" type="application/pdf" width="500" height="500"></object></body></html>'
			var w:WriteFile = new WriteFile();
			w.write(getFile(),c);
			return c;
		}
		 
	}
}