package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsFileManagerToolBar extends UIHBox
	{
		public function GdpsFileManagerToolBar()
		{
			super();
			create_init();
		}
		
		public var addBtn:UIButton;
		public var motifyBtn:UIButton;
		
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
			
			motifyBtn = new UIButton();
			motifyBtn.label = "修改";
			motifyBtn.name = "update";
			hbox.addChild(motifyBtn);
			
			initComplete();
		}
	}
}