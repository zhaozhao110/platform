package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsDataManagerToolBar extends UIHBox
	{
		public function GdpsDataManagerToolBar()
		{
			super();
			create_init();
		}
		
		public var importBtn:UIButton;
		public var exportBtn:UIButton;
		public var historyBtn:UIButton;
		public var comparisonBtn:UIButton;
		
		private function create_init():void
		{
			percentWidth = 100;
			height = 26;
			paddingLeft = 20;
			paddingTop = 5;
			verticalAlign = "middle";
			
			var hbox:UIHBox = new UIHBox();
			hbox.enabledPercentSize = true;
			hbox.verticalAlign = "middle";
			hbox.horizontalGap = 5;
			addChild(hbox);
			
			importBtn = new UIButton();
			importBtn.label = "导入Excel";
			importBtn.name = "import";
			hbox.addChild(importBtn);
			
			exportBtn = new UIButton();
			exportBtn.label = "导出Excel";
			exportBtn.name = "export";
			hbox.addChild(exportBtn);
			
			historyBtn = new UIButton();
			historyBtn.label = "查看历史版本";
			historyBtn.name = "history";
			hbox.addChild(historyBtn);
			
			comparisonBtn = new UIButton();
			comparisonBtn.label = "版本对比/提交";
			comparisonBtn.name = "comparison";
			hbox.addChild(comparisonBtn);
			
			initComplete();
		}
	}
}