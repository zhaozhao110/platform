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
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.popup.editImage.component.EditImagePopwinTab1Image;
	import com.editor.popup.editImage.component.EditImagePopwinTab2Image;
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
	import flash.filesystem.File;
	import flash.net.FileFilter;

	//图片切割
	public class EditImagePopwinTab2 extends UIVBox
	{
		public function EditImagePopwinTab2()
		{
			super();
		}
		
		public var widthTi:UITextInput;
		public var heightTi:UITextInput;
		private var imgContainer:UICanvas;
		public var img:UICanvas;
		public var typeCB:UICombobox;
						
		override public function delay_init():Boolean
		{
			styleName = "uicanvas"
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth =100;
			hb.styleName = "uicanvas"
			hb.verticalAlignMiddle = true;
			addChild(hb);
			
			btn = new UIButton();
			btn.label = "导入图片"
			btn.addEventListener(MouseEvent.CLICK,onSelect);
			hb.addChild(btn);
			
			
			
			hb = new UIHBox();
			hb.height = 30;
			hb.styleName = "uicanvas"
			hb.percentWidth =100;
			hb.verticalAlignMiddle = true;
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "切割单元格宽度:"
			hb.addChild(lb);
			
			widthTi = new UITextInput();
			widthTi.width = 100;
			hb.addChild(widthTi);
			
			lb = new UILabel();
			lb.text = "切割单元格高度: "
			hb.addChild(lb);
			
			heightTi = new UITextInput();
			heightTi.width = 100;
			hb.addChild(heightTi);
			
			lb = new UILabel();
			lb.text = "图片格式: "
			hb.addChild(lb);
			
			typeCB = new UICombobox();
			typeCB.width = 100;
			typeCB.height = 23;
			typeCB.labelField = "label"
			typeCB.dataProvider = [{label:"png",data:1},{label:"jpg",data:2}];
			hb.addChild(typeCB);
			typeCB.selectedIndex = 0;
			
			var btn:UIButton = new UIButton();
			btn.addEventListener(MouseEvent.CLICK , onCreate);
			btn.label = "生成切割图片"
			hb.addChild(btn);
			
			lb = new UILabel();
			lb.text = "(需要选择目录，图片将自动会按照数字从左到右，从上到下排列)";
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
		
		public function getSelectImgType():int
		{
			if(typeCB.selectedIndex == 0){
				return 1;
			}
			return 2;
		}
		
		private function onSelect(e:MouseEvent):void
		{
			var txtFilter:FileFilter = new FileFilter("Image", "*.jpg;*.png;");
			SelectFile.select("image",[txtFilter],onResult)
		}
		
		private function onResult(e:Event):void
		{
			UIComponentUtil.removeAllChild(img);
			var fl:File = e.target as File;
			var read:ReadImage = new ReadImage();
			read.complete_f = loadComplete
			read.loadImageFromFile(fl)
		}
		
		private function loadComplete(bmp:Bitmap):void
		{
			var b:Bitmap = new Bitmap(bmp.bitmapData.clone(),"auto",true);
			img.addChild(b);
			img.width = b.width;
			img.height = b.height;
		}
		
		private function onCreate(e:MouseEvent):void
		{
			if(int(widthTi.text) == 0) return ;
			if(int(heightTi.text) == 0) return ;
			if(img.numChildren == 0) return ;
			
			SelectFile.selectDirectory("saveImage",onSelectSaveFold);
		}
		
		public var saveFold:File;
		
		private function onSelectSaveFold(e:Event):void
		{		
			saveFold = e.target as File;
			
			var tx:int = int(img.width)/int(widthTi.text);
			var ty:int = int(img.height)/int(heightTi.text);
			var n:int;
			for(var j:int=0;j<ty;j++){
				for(var i:int=0;i<tx;i++){
					n += 1;
					var img2:EditImagePopwinTab2Image = new EditImagePopwinTab2Image(this);
					img2.split(i,j,n)
				}
			}
		}	
		
	}
}