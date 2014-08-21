package com.editor.module_mapIso.view.layers
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UILoader;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.events.ProgressEvent;

	//地图层 图片
	public class MapLayer extends UICanvas
	{
		private var _imageLoader:UILoader;
		private var _image:Bitmap;
		
		public function MapLayer()
		{
		}
		
		//读取地图图片
		public function load(url:String):void
		{
			UIComponentUtil.removeMovieClipChild(null,_image);
			_image = null;
			
			if(_imageLoader == null){
				_imageLoader = new UILoader();
				_imageLoader.progress_fun = loadProgress
				_imageLoader.complete_fun = loadSuccess;
			}
			_imageLoader.load(url);
		}
		
		private function loadSuccess():void
		{
			_image = _imageLoader.content as Bitmap;
			addChild(_image);
			width = _image.width;
			height = _image.height;
			MapEditorIsoManager.bottomContainerMediator.createGridLayer();
		}
		 
		private function loadProgress(e:ProgressEvent):void
		{
			MapEditorIsoManager.moduleMediator.addLog2("load progrss: " + Math.ceil(e.bytesLoaded/e.bytesTotal*100)+"%")
		}

	}
}