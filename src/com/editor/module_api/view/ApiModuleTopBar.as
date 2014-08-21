package com.editor.module_api.view
{
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.component.containers.SandyHBox;
	import com.sandy.component.controls.SandyButton;
	import com.sandy.component.controls.text.SandyLabel;
	import com.sandy.component.controls.text.SandyTextInput;
	import com.sandy.utils.ColorUtils;

	public class ApiModuleTopBar extends SandyHBox
	{
		public function ApiModuleTopBar()
		{
			super();
			create_init();
		}
		
		public var managerBtn:SandyButton;
		public var textTi:SandyTextInput;
		
		private function create_init():void
		{
			percentWidth = 100;
			height = 30;
			horizontalGap = 10;
			styleName = "uicanvas"
			verticalAlignMiddle = true
			paddingLeft = 20;
			
			var lb:SandyLabel = new SandyLabel();
			lb.text = "Sandy-engine api 文档"
			lb.color = ColorUtils.blue;
			lb.fontSize = 16;
			addChild(lb);
			
			managerBtn = new SandyButton();
			managerBtn.label = "管理"
			addChild(managerBtn);
			
			var sp:ASSpace = new ASSpace();
			sp.width = 50;
			addChild(sp);
			
			lb = new SandyLabel();
			lb.text = "搜索类名：(至少2个字符)"
			addChild(lb);
			
			textTi = new SandyTextInput();
			textTi.width = 150;
			addChild(textTi);
			
			
		}
	}
}