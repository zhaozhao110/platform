package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsDataBaseToolBar extends UIHBox
	{
		public var addBtn:UIButton;
		public var deleteBtn:UIButton;
		public var submitBtn:UIButton;
		public var versionBtn:UIButton;
		
		public function GdpsDataBaseToolBar()
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
			
			deleteBtn = new UIButton();
			deleteBtn.label = "删除";
			deleteBtn.name = "delete";
			hbox.addChild(deleteBtn);
			
			versionBtn = new UIButton();
			versionBtn.label = "历史版本";
			versionBtn.name = "version";
			hbox.addChild(versionBtn);
			
			submitBtn = new UIButton();
			submitBtn.label = "提交版本";
			submitBtn.name = "submit";
			hbox.addChild(submitBtn);
			
			initComplete();
		}
	}
}