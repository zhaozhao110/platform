package com.editor.popup.editImage.component
{
	import com.air.io.ReadImage;
	import com.editor.popup.editImage.EditImagePopwinTab1;
	import com.sandy.component.interfac.IDispose;
	
	import flash.display.Bitmap;
	import flash.filesystem.File;

	public class EditImagePopwinTab1Image implements IDispose
	{
		public function EditImagePopwinTab1Image(_tab1:EditImagePopwinTab1)
		{
			tab1 = _tab1;
		}
		
		private var tab1:EditImagePopwinTab1;
		private var read:ReadImage;
		private var imgIndex:int;
		
		public function load(fl:File,_imgIndex:int):void
		{
			imgIndex = _imgIndex;
			read = new ReadImage();
			read.complete_f = loadComplete;
			read.loadImageFromFile(fl)
		}
		
		private function loadComplete():void
		{
			var b:Bitmap = new Bitmap(read.content.bitmapData.clone(),"auto",true);
			tab1.addBitmap(b,imgIndex);
		}
		
		public function dispose():void
		{
			if(read!=null){
				read.dispose()
			}
		}
		
		private var _isDiposed:Boolean;
		public function get isDiposed():Boolean
		{
			return _isDiposed;
		}
		public function set isDiposed(value:Boolean):void
		{
			_isDiposed = value;
		}
		
	}
}