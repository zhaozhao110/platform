package com.editor.d3Popup.previewATF
{
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.editor.component.containers.UICanvas;
	import com.editor.d3.tool.D3ReadImage;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.textures.Texture;

	public class D3PreviewATFPopupMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "D3PreviewATFPopupMediator"
		public function D3PreviewATFPopupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():D3PreviewATFPopup
		{
			return viewComponent as D3PreviewATFPopup
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			win.openFileBtn.addEventListener(MouseEvent.CLICK , openFileHandle);
			win.openFoldBtn.addEventListener(MouseEvent.CLICK , openFoldHandle);
			win.fileList.labelField = "name"
			win.fileList.addEventListener(ASEvent.CHANGE , fileChange);
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
		}
		
		private function openFileHandle(e:MouseEvent):void
		{
			SelectFile.selectByFilter("atf","atf",fileResult);
		}
		
		private var file_ls:Array = [];
		
		private function fileResult(e:Event):void
		{
			file_ls.push(e.target as File);
			win.pathTi.text = File(e.target).nativePath;
			win.fileList.dataProvider = file_ls;
			win.fileList.setSelectIndex(file_ls.length-1,true,true);
		}
		
		private function fileChange(e:ASEvent):void
		{
			var f:File = win.fileList.selectedItem as File;
			var d:D3ReadImage = new D3ReadImage();
			d.complete_f = loadComplete;
			d.loadImageFromFile(f);
		}
		
		private function loadComplete(b:Bitmap):void
		{
			win.img.source = b;
		}
		
		private function openFoldHandle(e:MouseEvent):void
		{
			SelectFile.selectDirectory("atf",foldResult);
		}
		
		private function foldResult(e:Event):void
		{
			win.pathTi.text = File(e.target).nativePath;
			var a:Array = FileUtils.getDirectoryListing(e.target as File,"atf");
			file_ls = file_ls.concat(a);
			win.fileList.dataProvider = file_ls;
		}
		
	}
}