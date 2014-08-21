package com.editor.module_map.view.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.module_map.view.right.layout.MapEditorLayoutContainer;

	public class MapEditorRightContainer extends UICanvas
	{
		public function MapEditorRightContainer()
		{
			super();
			create_init();
		}
		
		public var layoutContainer:MapEditorLayoutContainer;
		private function create_init():void
		{
			enabledPercentSize = true;
			
			layoutContainer = new MapEditorLayoutContainer();
			addChild(layoutContainer);
						
		}
		
	}
}