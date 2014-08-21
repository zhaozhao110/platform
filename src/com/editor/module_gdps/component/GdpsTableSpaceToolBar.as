package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsTableSpaceToolBar extends UIHBox
	{
		public function GdpsTableSpaceToolBar()
		{
			super();
			create_init();
		}
		
		public var addBtn:UIButton;
		public var modifyBtn:UIButton;
		public var deleteBtn:UIButton;
		public var createExcelBtn:UIButton;
		public var excelModeBtn:UIButton;
		
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
			
			addBtn = new UIButton();
			addBtn.label = "添加";
			addBtn.name = "add";
			hbox.addChild(addBtn);
			
			modifyBtn = new UIButton();
			modifyBtn.label = "修改";
			modifyBtn.name = "update";
			hbox.addChild(modifyBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.label = "删除";
			deleteBtn.name = "delete";
			hbox.addChild(deleteBtn);
			
			createExcelBtn = new UIButton();
			createExcelBtn.label = "生成表对象";
			createExcelBtn.name = "create";
			hbox.addChild(createExcelBtn);
			
			excelModeBtn = new UIButton();
			excelModeBtn.name = "templete";
			excelModeBtn.label = "Excel模板";
			hbox.addChild(excelModeBtn);
			
			initComplete();
		}
	}
}