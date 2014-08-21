package com.editor.module_gdps.pop.top
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;

	public class GdpsTopToolContainer extends UICanvas
	{
		public function GdpsTopToolContainer()
		{
			super();
			
			create_init();
		}
		
		public var systemSetBtn:UIButton;
		public var quitBtn:UIButton;
		public var userInfo:UILabel;
		public var changeBtn:UIButton;
		public var gotoGameBtn:UIButton;
		
		private function create_init():void
		{
			width = 800;
			height = 30;
			//visible = false;
			
			var hbox:UIHBox = new UIHBox();
			hbox.horizontalGap = 10;
			hbox.percentWidth = 100;
			hbox.height = 30;
			hbox.paddingLeft = 10;
			hbox.y = 6;
			addChild(hbox);
			
			systemSetBtn = new UIButton();
			systemSetBtn.label = "系统设置";
			systemSetBtn.enabled = false;
			systemSetBtn.visible = false;
			systemSetBtn.includeInLayout = false;
			hbox.addChild(systemSetBtn);

			quitBtn = new UIButton();
			quitBtn.label = "退出系统";
			hbox.addChild(quitBtn);
			
			gotoGameBtn = new UIButton();
			gotoGameBtn.label = "切换到引擎平台"
			hbox.addChild(gotoGameBtn);
			
			changeBtn = new UIButton();
			changeBtn.label = "切换项目";
			hbox.addChild(changeBtn);
			
			userInfo = new UILabel();
			userInfo.color = 0xFAFF2F;
			userInfo.bold = true;
			userInfo.fontSize = 13;
			userInfo.enabledFliter = true;
			hbox.addChild(userInfo);
			
			initComplete();
		}
	}
}