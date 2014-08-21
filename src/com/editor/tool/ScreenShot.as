package com.editor.tool
{
	import com.air.io.FileUtils;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;

	public class ScreenShot extends EventDispatcher
	{
		public function ScreenShot():void
		{
			var path:String = FileUtils.getUserLocalAppData().nativePath+File.separator+"engineEditor"+File.separator+"SnapShot.exe";
			
			_file = new File(path);
			_nativeProcessStartupInfo = new NativeProcessStartupInfo();
			_nativeProcessStartupInfo.executable = _file;
			_process = new NativeProcess();
		}
		
		private var _process:NativeProcess
		private var _file:File;
		private var _nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var _bitmapData:BitmapData;
		
		public static const SHOTCOMPLETE:String = "shotComplete"
		
		public function shot():void
		{
			_process.start(_nativeProcessStartupInfo);
			_process.addEventListener(NativeProcessExitEvent.EXIT,onExit); 
		}
		
		private function onExit(e:NativeProcessExitEvent):void
		{
			if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT))
			{
				_bitmapData = Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
				dispatchEvent(new ASEvent(SHOTCOMPLETE));
			}
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData ? _bitmapData as BitmapData : null;
		}
		
	}
}