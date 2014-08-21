package com.editor.module_map.popup.preview
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.model.PopupwinSign;
	import com.editor.module_map.model.MapConst;
	import com.editor.module_map.popup.preview.component.PreviewSceneContainer;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.NativeWindowType;
	import flash.geom.Rectangle;

	public class MapEditorPreviewPopupwin extends AppPopupWithEmptyWin
	{
		public function MapEditorPreviewPopupwin()
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
			popupSign  		= PopupwinSign.MapEditorPreviewPopupwin_sign;
			isModel    		= true;
			enabledDrag    	= true;
			useDefaultBotButton = false;
			
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new MapEditorPreviewPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(MapEditorPreviewPopupwinMediator.NAME);
		}
		
		override public function forceActivate():void
		{
			super.forceActivate();
		}
		
		
		public var sceneContainer:PreviewSceneContainer;
		public var moveLButton:UIButton;
		public var moveRButton:UIButton;
		private function create_init():void
		{
			var bg:UICanvas = new UICanvas();
			bg.enabledPercentSize = true;
			bg.percentWidth = 100; bg.percentHeight = 100;
			bg.backgroundColor = 0x000000;
			addChild(bg);
			
			sceneContainer = new PreviewSceneContainer();
			sceneContainer.width = MapConst.layoutSceneContainerW; 
			sceneContainer.height = MapConst.layoutSceneContainerH;
			sceneContainer.horizontalCenter = 0;
			sceneContainer.scrollRect = new Rectangle(0, 0, sceneContainer.width, sceneContainer.height);
			sceneContainer.verticalCenter = 0;
			sceneContainer.backgroundColor = 0xffffff;
			addChild(sceneContainer);
			
			/**左右按钮**/
			var hbox1:UIHBox = new UIHBox();
			hbox1.top = 10;
			hbox1.horizontalGap = 30;
			hbox1.horizontalCenter = 0;
			addChild(hbox1);			
			moveLButton = new UIButton();
			moveLButton.label = "←";
			hbox1.addChild(moveLButton);			
			moveRButton = new UIButton();
			moveRButton.label = "→";
			hbox1.addChild(moveRButton);
			
			
			
		}
		
		
	}
}