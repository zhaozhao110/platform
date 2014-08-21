package com.editor.module_map.view.right.layout
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.module_map.model.MapConst;

	public class MapEditorLayoutContainer extends UICanvas
	{
		public function MapEditorLayoutContainer()
		{
			super();
			create_init();
		}
		
		public var sceneContainer:UICanvas;
		public var rangeMask:UICanvas;
		public var rangeMask_VisibleButton:UIButton;
		public var onlyShowSeleSceneButton:UIButton;
		private function create_init():void
		{
			enabledPercentSize = true;
			backgroundColor = 0xB3B3B3;
			
			sceneContainer = new UICanvas();
			//sceneContainer.alpha = .5
			sceneContainer.x = 6; sceneContainer.y = 6;
			sceneContainer.enabledPercentSize = true
			sceneContainer.horizontalScrollPolicy = "on";
			sceneContainer.verticalScrollPolicy = "on";
			sceneContainer.backgroundColor = 0x969696;
			addChild(sceneContainer);
			
			rangeMask = new UICanvas();
			rangeMask.width = MapConst.layoutSceneContainerW;
			rangeMask.height = MapConst.layoutSceneContainerH;
			rangeMask.backgroundColor = 0x00FFFF;
			rangeMask.backgroundAlpha = 0.3;
			sceneContainer.addChild(rangeMask);
			rangeMask.visible = false;
			
			rangeMask_VisibleButton = new UIButton();
			rangeMask_VisibleButton.x = 6; rangeMask_VisibleButton.y = 6;
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