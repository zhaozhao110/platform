package com.editor.module_gdps.view.serverManage
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsServerManagerToolBar;

	public class GdpsServerManagerContainer extends UICanvas
	{
		public function GdpsServerManagerContainer()
		{
			super();
			create_init();
		}
		
		public var toolBar:GdpsServerManagerToolBar;
		public var infoText:UIText;
		public var list:GdpsModuleDataGrid;
		
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
			
			toolBar = new GdpsServerManagerToolBar();
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
			infoText.text = "服务器定义管理......";
			hbox.addChild(infoText);
			
			list = new GdpsModuleDataGrid();
			list.enabledPercentSize = true;
			vbox.addChild(list);
			
			initComplete();
		}
	}
}