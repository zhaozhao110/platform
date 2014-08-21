package com.editor.popup.upload
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.air.io.SelectFile;
	import com.air.io.UploadFile;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;

	public class UploadFilePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "UploadFilePopwinMediator"
		public function UploadFilePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
		}
		public function get parserWin():UploadFilePopwin
		{
			return viewComponent as UploadFilePopwin
		}
		public function get uploadBtn():UIButton
		{
			return parserWin.uploadBtn;
		}
		public function get text():UITextArea
		{
			return parserWin.text;
		}
		public function get textInput():UITextInputWidthLabel
		{
			return parserWin.textInput;
		}
		public function get selectBtn():UIButton
		{
			return parserWin.selectBtn;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			//upload.addEventListener(ASEvent.COMPLETE,onUploadComplete)
			//upload.addEventListener(ASEvent.ERROR,onUploadError)
		}		
		
		
		private var xmlFile:FileReference = new FileReference();
		
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			SelectFile.select("文件",[new FileFilter("file", "*.*")],onSelectHandle);
		}
		
		private function onSelectHandle(e:Event):void
		{
			//var server:String = ""
			//upload.upload(File(e.target).nativePath,server);
		}
		
		private function onUploadComplete(e:ASEvent):void
		{
			showMessage("上传完成");
		}
		
		private function onUploadError(e:ASEvent):void
		{
			showMessage("上传失败");
		}
	}
}