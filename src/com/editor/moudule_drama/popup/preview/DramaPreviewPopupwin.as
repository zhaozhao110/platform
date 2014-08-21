package com.editor.moudule_drama.popup.preview
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.model.MapConst;
	import com.editor.moudule_drama.popup.preview.component.DramaPreview_Container;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	import flash.geom.Rectangle;

	public class DramaPreviewPopupwin extends AppPopupWithEmptyWin
	{
		public function DramaPreviewPopupwin()
		{
			super();
			create_init();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type 			= NativeWindowType.UTILITY;
			opts.resizable 		= true;
			opts.width 			= 1420;
			opts.height 		= 800;
			opts.title 			= "预览";
			return opts;
		}
		
		override protected function __init__():void
		{
			popupSign  		= PopupwinSign.DramaPreviewPopupwin_sign;
			isModel    		= true;
			enabledDrag    	= true;
			useDefaultBotButton = false;
			
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new DramaPreviewPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(DramaPreviewPopupwinMediator.NAME);
		}
		
		override public function forceActivate():void
		{
			super.forceActivate();
		}
		
		/**预览区**/
		public var previewContainer:DramaPreview_Container;
		/**当前帧**/
		public var frameTxt:UIText;
		/**按钮容器**/
		public var buttonContainer:UIHBox;
		/**重播按钮**/
		public var replayButton:UIButton;
		/**关闭按钮**/
		public var closeButton2:UIButton;
		
		private function create_init():void
		{
			var bg:UICanvas = new UICanvas();
			bg.enabledPercentSize = true;
			bg.percentWidth = 100; bg.percentHeight = 100;
			bg.backgroundColor = 0x000000;
			addChild(bg);
			
			previewContainer = new DramaPreview_Container();
			previewContainer.width = MapConst.layoutSceneContainerW; 
			previewContainer.height = MapConst.layoutSceneContainerH;
			previewContainer.horizontalCenter = 0;
			previewContainer.scrollRect = new Rectangle(0, 0, previewContainer.width, previewContainer.height);
			previewContainer.verticalCenter = 0;
			previewContainer.backgroundColor = 0xffffff;
			addChild(previewContainer);
			
			frameTxt = new UIText();
			frameTxt.x = 10; frameTxt.y = 10;
			frameTxt.color = 0xffffff;
			addChild(frameTxt);
			
			
			buttonContainer = new UIHBox();
			buttonContainer.width = 300;
			buttonContainer.height = 150;
			buttonContainer.horizontalGap = 20;
			buttonContainer.verticalCenter = 0;
			buttonContainer.horizontalCenter = 0;
			buttonContainer.verticalAlign = "middle";
			buttonContainer.horizontalAlign = "center";
			buttonContainer.borderColor = 0x999999;
			buttonContainer.borderThickness = 5;
			buttonContainer.borderStyle = "solid";
			buttonContainer.backgroundColor = 0x666666;
			addChild(buttonContainer);
			buttonContainer.visible = false;
									
			replayButton = new UIButton();
			replayButton.width = 90; replayButton.height = 30;
			replayButton.label = "重播";
			buttonContainer.addChild(replayButton);
			
			closeButton2 = new UIButton();
			closeButton2.width = 90; closeButton2.height = 30;
			closeButton2.label = "关闭";
			buttonContainer.addChild(closeButton2);
			
		}
	}
}