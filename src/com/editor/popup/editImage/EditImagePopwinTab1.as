package com.editor.popup.editImage
{
	import com.air.io.FileUtils;
	import com.air.io.ReadImage;
	import com.air.io.SaveImage;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.popup.editImage.component.EditImagePopwinTab1Image;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.BitmapDataUtil;
	import com.sandy.utils.TimerUtils;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;

	//图片拼接
	public class EditImagePopwinTab1 extends UIVBox
	{
		public function EditImagePopwinTab1()
		{
			super();
		}
		
		public var widthTi:UITextInput;
		public var heightTi:UITextInput;
		private var imgContainer:UICanvas;
		private var img:UICanvas;
		private var cellWTi:UITextInput
		private var cellHTi:UITextInput;
		
				
		override public function delay_init():Boolean
		{
			styleName = "uicanvas"
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.styleName = "uicanvas"
			hb.verticalAlignMiddle = true;
			hb.percentWidth =100;
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "新建   宽度:"
			hb.addChild(lb);
			
			widthTi = new UITextInput();
			widthTi.width = 100;
			hb.addChild(widthTi);
			
			lb = new UILabel();
			lb.text = "高度: "
			hb.addChild(lb);
			
			heightTi = new UITextInput();
			heightTi.width = 100;
			hb.addChild(heightTi);
			
			lb = new UILabel();
			lb.text = "单元格宽度:"
			hb.addChild(lb);
			
			cellWTi = new UITextInput();
			cellWTi.width = 100;
			hb.addChild(cellWTi);
			
			lb = new UILabel();
			lb.text = "单元格高度:"
			hb.addChild(lb);
			
			cellHTi = new UITextInput();
			cellHTi.width = 100;
			hb.addChild(cellHTi);
			
			var btn:UIButton = new UIButton();
			btn.addEventListener(MouseEvent.CLICK , onCreate);
			btn.label = "创建"
			hb.addChild(btn);
			
			hb = new UIHBox();
			hb.height = 30;
			hb.styleName = "uicanvas"
			hb.percentWidth =100;
			hb.verticalAlignMiddle = true;
			addChild(hb);
			
			lb = new UILabel();
			lb.text = "导入图片: "
			hb.addChild(lb);
			
			btn = new UIButton();
			btn.addEventListener(MouseEvent.CLICK , onSelect);
			btn.label = "选择多张图片"
			hb.addChild(btn);
			
			btn = new UIButton();
			btn.label = "保存"
			btn.addEventListener(MouseEvent.CLICK,onSave);
			hb.addChild(btn);
			
			lb = new UILabel();
			lb.text = "（保存时可以修改文件名）"
			hb.addChild(lb);
			
			imgContainer = new UICanvas();
			//imgContainer.background_red = true;
			imgContainer.verticalScrollPolicy = ASComponentConst.scrollPolicy_on;
			imgContainer.horizontalScrollPolicy = ASComponentConst.scrollPolicy_on;
			imgContainer.enabledPercentSize = true;
			imgContainer.styleName = "uicavnas";
			addChild(imgContainer);
			
			img = new UICanvas();
			imgContainer.addChild(img);
			
			return true;
		}
		
		private function onSelect(e:MouseEvent):void
		{
			if(int(widthTi.text) == 0) return ;
			if(int(heightTi.text) == 0) return ;
			if(int(cellWTi.text) == 0) return ;
			if(int(cellHTi.text) == 0) return ;
			
			var txtFilter:FileFilter = new FileFilter("Image", "*.jpg;*.png;");
			SelectFile.selectMultiple("image",[txtFilter],onResult)
		}
		
		private function onResult(e:FileListEvent):void
		{
			UIComponentUtil.removeAllChild(img);
			var a:Array = e.files;
			a = FileUtils.sortFile(a);
			for(var i:int=0;i<a.length;i++){
				var img2:EditImagePopwinTab1Image = new EditImagePopwinTab1Image(this);
				img2.load(a[i],i);	
			}
		}
		
		public function addBitmap(bmp:Bitmap,imgIndex:int):void
		{
			bmp.smoothing = true;
			var n:int = int(widthTi.text)/int(cellWTi.text);
			var y2:int = imgIndex/n;
			var x2:int = imgIndex-y2*n
			bmp.x = x2*int(cellWTi.text);
			bmp.y = y2*int(cellHTi.text);
			img.addChild(bmp);
		}
		
		private function onCreate(e:MouseEvent):void
		{
			if(int(widthTi.text) == 0) return ;
			if(int(heightTi.text) == 0) return ;
			if(int(cellWTi.text) == 0) return ;
			if(int(cellHTi.text) == 0) return ;
			
			var m:OpenMessageData = new OpenMessageData();
			m.info = "将删除当前所有设置，确定?";
			m.okFunction = confirm_onCreate;
			iManager.iPopupwin.showConfirm(m);
		}	
		
		private function confirm_onCreate():Boolean
		{
			UIComponentUtil.removeAllChild(img);
			img.width = int(widthTi.text);
			img.height = int(heightTi.text);
			return true;
		}
		
		private function onSave(e:MouseEvent):void
		{
			if(img.numChildren == 0) return ;
			if(int(widthTi.text) == 0) return ;
			if(int(heightTi.text) == 0) return ;
			if(int(cellWTi.text) == 0) return ;
			if(int(cellHTi.text) == 0) return ;
			
			var b:BitmapData = BitmapDataUtil.getBitmapData(int(widthTi.text),int(heightTi.text))
			b.draw(img,null,null,null,null,true)
			//imgContainer.addChild(new Bitmap(b,"auto",true));
			SaveImage.save(b,"img1.png");
		}
		
	}
}