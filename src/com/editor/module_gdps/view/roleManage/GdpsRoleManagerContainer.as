package com.editor.module_gdps.view.roleManage
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsRoleManagerToolBar;

	public class GdpsRoleManagerContainer extends UICanvas
	{
		public function GdpsRoleManagerContainer()
		{
			super();
			create_init();
		}
		
		public var toolBar:GdpsRoleManagerToolBar;
		public var infoText:UIText;
		public var list:GdpsModuleDataGrid;
		
		private function create_init():void
		{
			visible = true;
			enabledPercentSize = true;
			padding = 0;
			backgroundColor = 0xFFFFFF;
			
			var vbox:UIVBox = new UIVBox();
			vbox.enabledPercentSize = true;
			vbox.verticalGap = 2;
			vbox.horizontalGap = 2;
			vbox.horizontalAlign = "center";
			vbox.padding = 5;
			addChild(vbox);
			
			toolBar = new GdpsRoleManagerToolBar();
			vbox.addChild(toolBar);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.height = 30;
			hbox.paddingLeft = 20;
			hbox.paddingTop = 10;
			vbox.addChild(hbox);
			
			infoText = new UIText();
			infoText.percentWidth = 100;
			infoText.verticalCenter = 0;
			infoText.wordWrap = false;
			infoText.text = "角色管理，包括添加、删除、修改等操作......";
			hbox.addChild(infoText);
			
			list = new GdpsModuleDataGrid();
			list.enabledPercentSize = true;
			vbox.addChild(list);
			
			initComplete();
		}
	}
}