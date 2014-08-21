package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsPublishToolBar extends UIHBox
	{
		public function GdpsPublishToolBar()
		{
			super();
			create_init();
		}
		
		public var uploadTestBtn:UIButton;
		public var uploadTiyanBtn:UIButton;
		
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
			
			uploadTestBtn = new UIButton();
			uploadTestBtn.label = "更新测试服";
			uploadTestBtn.name = "uploadTest";
			hbox.addChild(uploadTestBtn);
			
			uploadTiyanBtn = new UIButton();
			uploadTiyanBtn.label = "更新体验服";
			uploadTiyanBtn.name = "uploadTiyan";
			hbox.addChild(uploadTiyanBtn);
			
			initComplete();
		}
	}
}