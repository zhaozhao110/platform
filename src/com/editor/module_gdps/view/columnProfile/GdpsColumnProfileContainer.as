package com.editor.module_gdps.view.columnProfile
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.component.GdpsColunmProfileToolBar;
	import com.editor.module_gdps.component.GdpsLoadingProgressBar;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	
	public class GdpsColumnProfileContainer extends UICanvas
	{
		public function GdpsColumnProfileContainer()
		{
			super();
			create_init();
		}
		
		public var toolBar:GdpsColunmProfileToolBar;
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
			
			toolBar = new GdpsColunmProfileToolBar();
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
			infoText.text = "当前模块提供游戏基础表数据配置、文件属性定义等功能......";
			hbox.addChild(infoText);
			
			tableSpaceDataGridContainer = new GdpsModuleDataGrid();
			tableSpaceDataGridContainer.enabledPercentSize = true;
			vbox.addChild(tableSpaceDataGridContainer);
			
			initComplete();
		}
	}
}