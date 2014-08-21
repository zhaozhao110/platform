package com.editor.popup.editImage.component
{
	import com.air.io.ReadImage;
	import com.air.io.WriteFile;
	import com.editor.popup.editImage.EditImagePopwinTab1;
	import com.editor.popup.editImage.EditImagePopwinTab2;
	import com.sandy.component.interfac.IDispose;
	import com.sandy.gameTool.image.JPGEncoder;
	import com.sandy.gameTool.image.PNGEncoder;
	import com.sandy.utils.BitmapDataUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class EditImagePopwinTab2Image implements IDispose
	{
		public function EditImagePopwinTab2Image(_tab1:EditImagePopwinTab2)
		{
			tab1 = _tab1;
		}
		
		private var tab1:EditImagePopwinTab2;
				
		public function split(tx:int,ty:int,imgIndex:int):void
		{
			var cellW:int = int(tab1.widthTi.text);
			var cellH:int = int(tab1.heightTi.text)
				
			var rect:Rectangle = new Rectangle();
			rect.x = 0
			rect.y = 0
			rect.width = cellW;
			rect.height = cellH;
			
			var m:Matrix = new Matrix(1,0,0,1,-tx*cellW,-ty*cellH);
			
			var b:BitmapData = BitmapDataUtil.getBitmapData(cellW,cellH)
			b.draw(tab1.img,m,null,null,rect,true);
			
			var imgByteArray:ByteArray ;
			if(tab1.getSelectImgType() == 1){
				imgByteArray = PNGEncoder.encode(b);
			}else{
				var jpegEncoder:JPGEncoder = new JPGEncoder(80)
				imgByteArray = jpegEncoder.encode(b);	
			}
			var write:WriteFile = new WriteFile();
			if(tab1.getSelectImgType() == 1){
				write.write(new File(tab1.saveFold.nativePath+File.separator+imgIndex+".png"),imgByteArray);
			}else{
				write.write(new File(tab1.saveFold.nativePath+File.separator+imgIndex+".jpg"),imgByteArray);
			}
		}
		
		public function dispose():void
		{
			
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