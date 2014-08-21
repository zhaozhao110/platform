package com.editor.module_avg.view.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILoader;
	import com.editor.module_avg.vo.AVGResData;
	import com.sandy.component.expand.ModelMaskContainer;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;

	public class AVGModRightPreview extends UICanvas
	{
		public function AVGModRightPreview()
		{
			super();
			create_init();
		}
		
		public var cont:UICanvas
		private var txt:UILabel;
		private var pathTxt:UILabel;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			mouseChildren = true;
			mouseEnabled = true;
									
			var model:ModelMaskContainer = new ModelMaskContainer()
			addChild(model);
			model.backgroundAlpha = 1;
			
			cont = new UICanvas();
			addChild(cont);
			
			loader = new UILoader();
			loader.mouseChildren = false;
			loader.mouseEnabled = false;
			loader.complete_fun = loadComplete;
			loader.progress_fun = loadProgress;
			cont.addChild(loader);
			
			var h:UIHBox = new UIHBox();
			h.height = 30;
			h.verticalAlignMiddle = true;
			cont.addChild(h);
			
			var btn:UIButton = new UIButton();
			btn.label = "关闭"
			h.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK , onClickHandle);
			
			txt = new UILabel();
			txt.fontSize = 16;
			txt.enabledFliter = true;
			txt.color = ColorUtils.red;
			h.addChild(txt);
			
			pathTxt = new UILabel();
			pathTxt.fontSize = 16;
			pathTxt.enabledFliter = true
			pathTxt.color = ColorUtils.green;
			pathTxt.y = 30;
			cont.addChild(pathTxt);
			
			visible = false;
		}
		
		private var loader:UILoader;
		
		
		public function load(d:AVGResData):void
		{
			pathTxt.text = d.loadPath;
			loader.load(d.loadPath);
			visible = true
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			visible = false;
			
			loader.unload();
		}
		
		private function loadComplete():void
		{
			loader.x = this.width/2- loader.contentHolderWidth/2;
			loader.y = this.height/2-loader.contentHolderHeight/2;
		}
		
		private function loadProgress(e:ProgressEvent):void
		{
			txt.text = "loading : " + Math.ceil(e.bytesLoaded/e.bytesTotal*100) + "%";
		}
	}
}