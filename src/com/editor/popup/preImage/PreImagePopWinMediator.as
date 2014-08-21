package com.editor.popup.preImage
{
	import com.air.io.SaveImage;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILoader;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.core.ASBitmap;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.setTimeout;

	public class PreImagePopWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "PreImagePopWinMediator"
		public function PreImagePopWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():PreImagePopWin
		{
			return viewComponent as PreImagePopWin
		}
		public function get img():UICanvas
		{
			return win.img;	
		}
		public function get txt():UILabel
		{
			return win.txt;
		}
		public function get openBtn():UIButton
		{
			return win.openBtn;
		}
		public function get saveBtn():UIButton
		{
			return win.saveBtn;
		}
		public function get openBtn2():UIButton
		{
			return win.openBtn2;
		}
		
		override public function onRegister():void
		{
			super.onRegister()
			
			win.mediator = this;
			imgUrl = (getOpenDataProxy() as OpenPopwinData).data;
			win.title = imgUrl;
			load();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			if(toolBar!=null) toolBar.dispose();
		}
		
		private var imgUrl:String;
		private var loader:UILoader;
		public var bitmap:ASBitmap;
		public var toolBar:PreImageToolBar;
		
		private function load():void
		{
			if(loader == null){
				loader = new UILoader();
				loader.ioError_fun = onLoaderError;
				loader.complete_fun = onLoaderComplete;
			}
			loader.load(imgUrl);
		}
		
		private function onLoaderError(e:*=null):void
		{
			txt.text = "加载出错...."
		}
		
		private function onLoaderComplete():void
		{
			setImageBitmapData((loader.content as Bitmap).bitmapData)
		}
		
		private function setImageBitmapData(bitmapd:BitmapData):void
		{
			if(bitmap == null){
				bitmap = new ASBitmap();
				img.addChild(bitmap);
			}
			bitmap.bitmapData = bitmapd;
			
			if(bitmap.width < PreImagePopWin.win_w && bitmap.height < PreImagePopWin.win_h){
				win.nativeWinWidth = PreImagePopWin.win_w;
				win.nativeWinHeight =PreImagePopWin.win_h;
				win.toCenter();
			}else{
				win.maximize();
			}
			
			if(toolBar==null){
				toolBar = new PreImageToolBar();
				img.addChild(toolBar);
			}
			
			toolBar.width = bitmap.width;
			toolBar.height = bitmap.height;
			toolBar.win = win;
			toolBar.bitmap = bitmap;
			toolBar.init();
		}
		
		public function reactToOpenBtnClick(e:MouseEvent):void
		{
			var txtFilter:FileFilter = new FileFilter("Image", "*.jpg;*.png;");
			SelectFile.select("图片",[txtFilter],selectImage);
		}
		
		public function reactToOpenBtn2Click(e:MouseEvent):void
		{
			if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT)){ 
				setImageBitmapData(Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData); 
			}
		}
		
		private function selectImage(e:Event):void
		{
			imgUrl = File(e.target).nativePath;
			win.title = imgUrl;
			load();
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			if(bitmap == null) return 
			if(bitmap.bitmapData == null) return ;
			SaveImage.save(bitmap.bitmapData,new File(imgUrl).name);
		}
	}
}