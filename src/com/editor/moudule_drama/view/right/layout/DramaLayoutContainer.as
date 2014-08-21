package com.editor.moudule_drama.view.right.layout
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.moudule_drama.model.DramaConst;

	public class DramaLayoutContainer extends UICanvas
	{
		public function DramaLayoutContainer()
		{
			super();
			create_init();
		}
		/**显示窗口容器**/
		public var viewContainer:UICanvas;
		/**舞台遮罩**/
		public var rangeMask:UICanvas;
		/**显示隐藏舞台遮罩按钮**/
		public var rangeMask_VisibleButton:UIButton;
		/**只显示选中层按钮**/
		public var onlyShowSeleSceneButton:UIButton;
		private function create_init():void
		{			
			enabledPercentSize = true;
			percentWidth = 100;
			percentHeight = 100;
			
			viewContainer = new UICanvas();
			viewContainer.x = 6; viewContainer.y = 6;
			viewContainer.enabledPercentSize = true;
			viewContainer.percentWidth = 99; viewContainer.percentHeight = 99;
			viewContainer.horizontalScrollPolicy = "on";
			viewContainer.verticalScrollPolicy = "on";
			viewContainer.backgroundColor = 0x969696;
			addChild(viewContainer);
			
			rangeMask = new UICanvas();
			rangeMask.width = DramaConst.layoutSceneContainerW;
			rangeMask.height = DramaConst.layoutSceneContainerH;
			rangeMask.backgroundColor = 0x00FFFF;
			rangeMask.backgroundAlpha = 0.3;
			viewContainer.addChild(rangeMask);
			rangeMask.visible = false;
			
			rangeMask_VisibleButton = new UIButton();
			rangeMask_VisibleButton.x = 10; rangeMask_VisibleButton.y = 6;
			rangeMask_VisibleButton.height = 18;
			rangeMask_VisibleButton.label = "显示舞台范围";
			addChild(rangeMask_VisibleButton);
			
			onlyShowSeleSceneButton = new UIButton();
			onlyShowSeleSceneButton.x = 100; onlyShowSeleSceneButton.y = 6;
			onlyShowSeleSceneButton.height = 18;
			onlyShowSeleSceneButton.label = "只显示选中层";
			addChild(onlyShowSeleSceneButton);
			
		}
	}
}