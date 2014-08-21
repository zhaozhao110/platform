package com.editor.module_gdps.view.fileData
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.component.GdpsFileManagerToolBar;
	import com.editor.module_gdps.component.GdpsLoadingProgressBar;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	
	public class GdpsFileDataManagerContainer extends UICanvas
	{
		public function GdpsFileDataManagerContainer()
		{
			super();
			create_init();
		}
		
		public var toolBar:GdpsFileManagerToolBar;
		public var infoText:UIText;
		public var dataManageDataGridContainer:GdpsModuleDataGrid;
		
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
			
			toolBar = new GdpsFileManagerToolBar();
			toolBar.visible = false;
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
			infoText.text = "当前模块提供文件数据对象的定义、表数据配置文件的定义等功能。";
			hbox.addChild(infoText);
			
			dataManageDataGridContainer = new GdpsModuleDataGrid();
			dataManageDataGridContainer.enabledPercentSize = true;
			vbox.addChild(dataManageDataGridContainer);
			
			initComplete();
		}
	}
}