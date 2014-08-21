package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsServerManagerToolBar extends UIHBox
	{
		public function GdpsServerManagerToolBar()
		{
			super();
			create_init();
		}
		
		public var addBtn:UIButton;
		public var modifyBtn:UIButton;
		public var deleteBtn:UIButton;
		
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
			addBtn.label = "添加服务器";
			addBtn.name = "add";
			hbox.addChild(addBtn);
			
			modifyBtn = new UIButton();
			modifyBtn.label = "修改服务器";
			modifyBtn.name = "modify";
			hbox.addChild(modifyBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.label = "删除服务器";
			deleteBtn.name = "delete";
			hbox.addChild(deleteBtn);
			
			initComplete();
		}
	}
}