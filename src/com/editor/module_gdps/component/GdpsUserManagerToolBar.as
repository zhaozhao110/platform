package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsUserManagerToolBar extends UIHBox
	{
		public function GdpsUserManagerToolBar()
		{
			super();
			create_init();
		}
		
		public var addBtn:UIButton;
		public var modifyBtn:UIButton;
		public var deleteBtn:UIButton;
		public var roleBtn:UIButton;
		public var productBtn:UIButton;
		
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
			addBtn.label = "添加用户";
			addBtn.name = "add";
			hbox.addChild(addBtn);
			
			modifyBtn = new UIButton();
			modifyBtn.label = "修改用户信息";
			modifyBtn.name = "modify";
			hbox.addChild(modifyBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.label = "删除用户";
			deleteBtn.name = "delete";
			hbox.addChild(deleteBtn);
			
			roleBtn = new UIButton();
			roleBtn.label = "用户绑定角色";
			roleBtn.name = "role";
			hbox.addChild(roleBtn);
			
			productBtn = new UIButton();
			productBtn.label = "用户绑定项目";
			productBtn.name = "product";
			hbox.addChild(productBtn);
			
			initComplete();
		}
	}
}