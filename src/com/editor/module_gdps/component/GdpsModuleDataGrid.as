package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIVBox;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.sandy.component.containers.SandyDataGrid;

	public class GdpsModuleDataGrid extends UIVBox
	{
		public function GdpsModuleDataGrid()
		{
			super();
			
			create_init();
		}
		
		public var tableSpace_grid:SandyDataGrid;
		public var tableSpace_page_bar:GdpsPageBar;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			verticalGap = 4;
			horizontalGap = 4;
			styleName = "uicanvas"
			
			tableSpace_grid = new SandyDataGrid();
			tableSpace_grid.name = "GdpsModuleDataGrid"
			tableSpace_grid.enabledPercentSize = true;
			tableSpace_grid.rowHeight = 30;
			tableSpace_grid.verticalScrollPolicy = "auto";
			tableSpace_grid.horizontalScrollPolicy = "auto";
			tableSpace_grid.styleName = GDPSDataManager.dataGridDefaultTheme;
			addChild(tableSpace_grid);
			
			tableSpace_page_bar = new GdpsPageBar();
			addChild(tableSpace_page_bar);
			
			initComplete();
		}
	}
}