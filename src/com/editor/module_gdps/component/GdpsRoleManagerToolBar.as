package com.editor.module_gdps.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;

	public class GdpsRoleManagerToolBar extends UIHBox
	{
		public function GdpsRoleManagerToolBar()
		{
			super();
			create_init();
		}
		
		public var addBtn:UIButton;
		public var modifyBtn:UIButton;
		public var deleteBtn:UIButton;
		public var userBtn:UIButton;
		public var rightBtn:UIButton;
		
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
			addBtn.label = "添加角色";
			addBtn.name = "add";
			hbox.addChild(addBtn);
			
			modifyBtn = new UIButton();
			modifyBtn.label = "修改角色";
			modifyBtn.name = "modify";
			hbox.addChild(modifyBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.label = "删除角色";
			deleteBtn.name = "delete";
			hbox.addChild(deleteBtn);
			
			userBtn = new UIButton();
			userBtn.label = "角色用户列表";
			userBtn.name = "user";
			hbox.addChild(userBtn);
			
			rightBtn = new UIButton();
			rightBtn.label = "角色权限设定";
			rightBtn.name = "right";
			rightBtn.visible = false;
			hbox.addChild(rightBtn);
			
			initComplete();
		}
	}
}