package com.editor.module_avg.view.top
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;

	public class AVGModuleTopContainer extends UICanvas
	{
		public function AVGModuleTopContainer()
		{
			super();
			create_init();	
		}
		
		public var saveBtn:UIButton;
		public var loadBtn:UIButton;
		public var infoLB:UILabel;
		public var preBtn:UIButton;
		
		private function create_init():void
		{
			height = 30;
			percentWidth = 100;
			styleName = "uicanvas";
			
			var h:UIHBox = new UIHBox();
			h.paddingLeft = 20;
			h.enabledPercentSize = true
			h.verticalAlignMiddle = true;
			h.horizontalGap = 10;
			addChild(h);
			
			loadBtn = new UIButton();
			loadBtn.label = "选择剧情"
			h.addChild(loadBtn);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存";
			h.addChild(saveBtn);
			
			preBtn = new UIButton();
			preBtn.label = "预览"
			h.addChild(preBtn);
				
			infoLB = new UILabel();
			h.addChild(infoLB);
			
		}
	}
}