package com.editor.modules.view.console
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.expand.UIComboBoxWithLabel;

	public class ConsoleDockPopView extends UICanvas
	{
		public function ConsoleDockPopView()
		{
			super();
			create_init();
		}
		
		public var toolBar:UIHBox;
		public var cb:UIComboBoxWithLabel;
		public var txtArea:UITextArea;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			percentWidth = 100;
			height = 30;
			
			toolBar = new UIHBox();
			toolBar.paddingTop = 4
			//toolBar.backgroundColor = 0xd4d0c8;
			toolBar.percentWidth = 100;
			toolBar.height = 30;
			addChild(toolBar);
			
			cb = new UIComboBoxWithLabel();
			cb.label = "功能列表： ";
			cb.width = 300;
			cb.height = 30
			cb.dropDownWidth = 200
			toolBar.addChild(cb);
			
			txtArea = new UITextArea();
			txtArea.y = 32;
			txtArea.editable = false;
			txtArea.enabledPercentSize = true;
			addChild(txtArea);
		}
		
	}
}