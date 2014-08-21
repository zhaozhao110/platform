package com.editor.module_gdps.view.dataBase
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.component.GdpsDataBaseToolBar;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	
	public class GdpsDataBaseContainer extends UICanvas
	{
		public function GdpsDataBaseContainer()
		{
			super();
			create_init();
		}
		
		public var toolBar:GdpsDataBaseToolBar;
		public var infoText:UIText;
		public var databaseFileDataGridContainer:GdpsModuleDataGrid;
		
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
			
			toolBar = new GdpsDataBaseToolBar();
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
			infoText.text = "提供db数据、sql脚本的上传操作，主要针对非基础数据表的sql维护、表结构调整、存储过程执行等。";
			hbox.addChild(infoText);
			
			databaseFileDataGridContainer = new GdpsModuleDataGrid();
			databaseFileDataGridContainer.enabledPercentSize = true;
			vbox.addChild(databaseFileDataGridContainer);
			
			initComplete();
		}
	}
}