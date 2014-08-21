package com.editor.module_map
{
	import com.editor.component.UIModule2;
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map.view.left.MapEditorLeftContainer;
	import com.editor.module_map.view.right.MapEditorRightContainer;
	import com.editor.module_map.view.top.MapEditorToolBar;
	import com.editor.modules.common.layout2.AppLayout2Container;

	public class MapEditorModule extends UIModule2
	{
		public function MapEditorModule()
		{
			super();
		}
		
		public var topToolBar:MapEditorToolBar;
		public var leftContainer:MapEditorLeftContainer;
		public var rightContainer:MapEditorRightContainer;
		
		override public function create_init():void
		{
			super.create_init();
			
			topToolBar = new MapEditorToolBar();
			layout2Container.getToolBar().addChild(topToolBar);
			
			leftContainer = new MapEditorLeftContainer();
			layout2Container.getLeftContainer().addChild(leftContainer);
			layout2Container.getLeftContainer().width = 200;
			
			rightContainer = new MapEditorRightContainer();
			layout2Container.getRightContainer().addChild(rightContainer);
				
		}
	}
}