package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	
	public class GdpsPublishServerToolBar extends UIHBox
	{
		public function GdpsPublishServerToolBar()
		{
			super();
			create_init();
		}
		
		public var addBtn:UIButton;
		public var updateBtn:UIButton;
		public var deleteBtn:UIButton;
		public var auditBtn:UIButton;
		public var publishBtn:UIButton;
		public var svnSubmitBtn:UIButton;
		
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
			
			auditBtn = new UIButton();
			auditBtn.label = "批次审核";
			auditBtn.name = "audit";
			hbox.addChild(auditBtn);
			
			publishBtn = new UIButton();
			publishBtn.label = "批次发布";
			publishBtn.name = "publish";
			hbox.addChild(publishBtn);
			
			svnSubmitBtn = new UIButton();
			svnSubmitBtn.label = "批次发布";
			svnSubmitBtn.name = "svnSubmit";
			svnSubmitBtn.visible = false;
			svnSubmitBtn.includeInLayout = false;
			hbox.addChild(publishBtn);
			
			initComplete();
		}
	}
}