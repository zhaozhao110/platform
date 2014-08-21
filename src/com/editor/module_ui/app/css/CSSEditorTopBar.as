package com.editor.module_ui.app.css
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class CSSEditorTopBar extends UICanvas
	{
		public function CSSEditorTopBar()
		{
			super()
			create_init();
		}
		
		public var hb1:UIHBox;
		public var newBtn:UIButton;
		public var debugBtn:UIButton;
		public var css_cb:UICombobox;
		
		private function create_init():void
		{
			height = 30;
			percentWidth = 100;
			styleName = "uicanvas"
			//background_red = true
						
			hb1 = new UIHBox();
			hb1.verticalAlign = ASComponentConst.verticalAlign_middle;
			hb1.percentWidth = 100;
			hb1.height = 30;
			hb1.horizontalGap = 5;
			hb1.x = 20;
			addChild(hb1);
			
			newBtn = new UIButton();
			newBtn.label = "全局css类打开编辑";
			//newBtn.visible = false;
			hb1.addChild(newBtn);
			
			debugBtn = new UIButton();
			debugBtn.label = "调试"
			debugBtn.toolTip = "调试项目,预览效果"
			hb1.addChild(debugBtn);
			debugBtn.visible = false;
			
			var lb1:UILabel = new UILabel();
			lb1.text = "您所对应的主题类：";
			hb1.addChild(lb1);
			
			css_cb = new UICombobox();
			css_cb.width = 150;
			css_cb.height = 22;
			hb1.addChild(css_cb);
			
		}
	}
}