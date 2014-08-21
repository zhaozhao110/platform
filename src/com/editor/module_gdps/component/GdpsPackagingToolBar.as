package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsPackagingToolBar extends UIHBox
	{
		public function GdpsPackagingToolBar()
		{
			super();
			create_init();
		}
		
		public var addBtn:UIButton;
		public var updateBtn:UIButton;
		public var deleteBtn:UIButton;
		public var detailBtn:UIButton;
		public var detectBtn:UIButton;
		public var packagingBtn:UIButton;
		public var publishBtn:UIButton;
		public var cloneBtn:UIButton;
		
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
			addBtn.label = "新增批次号";
			addBtn.name = "add";
			hbox.addChild(addBtn);
			
			updateBtn = new UIButton();
			updateBtn.label = "修改批次号";
			updateBtn.name = "update";
			hbox.addChild(updateBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.label = "删除批次号";
			deleteBtn.name = "delete";
			hbox.addChild(deleteBtn);
			
			detailBtn = new UIButton();
			detailBtn.label = "批次号明细/设定";
			detailBtn.name = "detail";
			hbox.addChild(detailBtn);
			
			detectBtn = new UIButton();
			detectBtn.label = "批次检测";
			detectBtn.name = "detect";
			hbox.addChild(detectBtn);
			
			packagingBtn = new UIButton();
			packagingBtn.label = "批次打包";
			packagingBtn.name = "packaging";
			hbox.addChild(packagingBtn);
			
			publishBtn = new UIButton();
			publishBtn.label = "批次发布";
			publishBtn.name = "publish";
			hbox.addChild(publishBtn);
			
			cloneBtn = new UIButton();
			cloneBtn.label = "批次克隆";
			cloneBtn.name = "clone";
			hbox.addChild(cloneBtn);
			
			
			initComplete();
		}
	}
}