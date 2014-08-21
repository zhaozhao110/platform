package com.editor.popup.previewSwf
{
	import com.air.io.ReadSwf;
	import com.air.io.SelectFile;
	import com.air.logging.CatchLog;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.controls.loader.ASMovieClipAssetsBitmap;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class PreviewSwfPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "PreviewSwfPopwinMediator"
		public function PreviewSwfPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get inputWin():PreviewSwfPopwin
		{
			return viewComponent as PreviewSwfPopwin;
		}
		public function get cont():UICanvas
		{
			return inputWin.cont;
		}
		public function get fileBtn():UIButton
		{
			return inputWin.fileBtn;
		}
		public function get pathLb():UILabel
		{
			return inputWin.pathLb;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			fileBtn.addEventListener(MouseEvent.CLICK,onClick);
			
			loadSwf = new ReadSwf();
			loadSwf.complete_f = loadSwfComplete;
			
			img = new ASMovieClipAssetsBitmap();
			cont.addChild(img);
			
			inputWin.ti.text = "e11001"
		}
		
		private var loadSwf:ReadSwf;
		private var img:ASMovieClipAssetsBitmap
		
		private function onClick(e:MouseEvent):void
		{
			loadSwf.load();
		}
		
		private function loadSwfComplete():void
		{
			img.unloadAndDelCache();
			img.proxy_applicationDomain = loadSwf.applicationDomain;
			img.source = inputWin.ti.text;
			//img.play();
		}
		
		private function selectResult(e:Event):void
		{
			var file:File = e.target as File
		}
		
	}
}