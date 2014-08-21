package com.editor.module_gdps.view.tableSpace
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.component.GdpsLoadingProgressBar;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsTableSpaceToolBar;

	public class GdpsTableSpaceContaier extends UICanvas
	{
		public function GdpsTableSpaceContaier()
		{
			super();
			create_init();
		}
		
		public var toolBar:GdpsTableSpaceToolBar;
		public var infoText:UIText;
		public var tableSpaceDataGridContainer:GdpsModuleDataGrid;
		
		private function create_init():void
		{
			visible = true;
			enabledPercentSize = true;
		    padding = 0;
			backgroundColor = 0xFFFFFF;
			
			var vbox:UIVBox = new UIVBox();
			vbox.enabledPercentSize = true;
			vbox.verticalGap = 2;
			vbox.horizontalGap = 2;
			vbox.horizontalAlign = "center";
			vbox.padding = 5;
			addChild(vbox);
			
			toolBar = new GdpsTableSpaceToolBar();
			vbox.addChild(toolBar);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.height = 30;
			hbox.paddingLeft = 20;
			hbox.paddingTop = 10;
			vbox.addChild(hbox);
			
			infoText = new UIText();
			infoText.percentWidth = 100;
			infoText.verticalCenter = 0;
			infoText.wordWrap = false;
			infoText.text = "表空间管理菜单功能说明......";
			hbox.addChild(infoText);
			
			tableSpaceDataGridContainer = new GdpsModuleDataGrid();
			tableSpaceDataGridContainer.enabledPercentSize = true;
			vbox.addChild(tableSpaceDataGridContainer);
			
			initComplete();
		}
	}
}