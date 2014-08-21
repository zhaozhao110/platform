package com.editor.d3.view.attri.preview
{
	import com.air.io.ReadImage;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UIText;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.tool.D3ReadImage;
	import com.editor.manager.DataManager;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.File;

	public class TexturePreview extends D3CompPreviewBase
	{
		public function TexturePreview()
		{
			super();
			createImage();
		}
		
		override protected function get compType():String
		{
			return "texture preview"
		}
		
		override protected function uiShow():void
		{
			this.x = stage.stageWidth-300-this.width-20;
			this.y = get_App3DMainUIContainerMediator().rightContainer.y;
		}
		
		private var img:D3ReadImage;
		private var img2:UIImage;
		private var size:Object = {};
		private var file:File;
		
		private function createImage():void
		{
			backgroundColor = DataManager.def_col;
			img = new D3ReadImage();
			img.complete_f = readComplete;
		}
		
		private function readComplete(b:Bitmap):void
		{
			size.w = b.width;
			size.h = b.height;
			if(img2 == null){
				img2 = new UIImage();
				img2.width = width;
				img2.height = height;
				img2.scaleContent = true;
				addChildAt(img2,1);
			}
			//trace(getChildAt(0));
			img2.source = b;
			addInfoTxt()
		}
		
		override public function setValue(d:D3ObjectBase):void
		{
			super.setValue(d);
			
			file = d.file;
			img.loadImageFromFile(d.file);
		}
		
		public function setFile(f:File):void
		{
			file = f;
			img.loadImageFromFile(f);
		}
		
		private var infoTxt:UIText;
		private function addInfoTxt():void
		{
			if(infoTxt == null){
				infoTxt = new UIText();
				infoTxt.multiline = true;
				infoTxt.textAlign = "center";
				infoTxt.color = ColorUtils.white;
				infoTxt.bold = true;
				infoTxt.width = 180
				addChild(infoTxt);
				infoTxt.x = 0;
				infoTxt.y = 170
				infoTxt.enabledFliter = true;
			}
			var b:Bitmap = img2.content;
			infoTxt.htmlText = file.name+"<br>"+size.w+"*"+size.h;
		}

		override protected function onResize(event:Event = null):void
		{
			if(stage == null) return ;
			if(view == null) return ;
			view.width = this.width;
			view.height = this.height;
			this.x = stage.stageWidth-300-this.width-20;
			this.y = get_App3DMainUIContainerMediator().rightContainer.y;
		}
		
	}
}