package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsColunmProfileToolBar extends UIHBox
	{
		public function GdpsColunmProfileToolBar()
		{
			super();
			create_init();
		}
		
		public var propertyBtn:UIButton;
		public var annotationBtn:UIButton;
		
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
			
			propertyBtn = new UIButton();
			propertyBtn.label = "字段属性定义";
			propertyBtn.name = "property";
			hbox.addChild(propertyBtn);
			
			annotationBtn = new UIButton();
			annotationBtn.label = "下载属性注释";
			annotationBtn.name = "annotation";
			hbox.addChild(annotationBtn);
			
			initComplete();
		}
	}
}