package com.editor.module_html.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class HtmlModuleToolBar extends UICanvas
	{
		public function HtmlModuleToolBar()
		{
			super();
			create_init();
		}
		
		public var reflashBtn:UIAssetsSymbol; 
		public var text:UITextInputWidthLabel;
		public var gotoBtn:UIAssetsSymbol;
		public var addBtn:UIAssetsSymbol;
		
		private function create_init():void
		{
			this.height = 30;
			this.percentWidth = 100;
						
			var hb:UIHBox = new UIHBox();
			hb.paddingLeft = 20;
			hb.enabledPercentSize = true;
			hb.horizontalGap = 10;
			hb.verticalAlign = ASComponentConst.verticalAlign_middle;
			addChild(hb);
			
			reflashBtn = new UIAssetsSymbol();
			reflashBtn.source = "web_ref_a"
			reflashBtn.width = 16;
			reflashBtn.height = 16;
			reflashBtn.buttonMode = true;
			hb.addChild(reflashBtn);
			
			text = new UITextInputWidthLabel();
			text.width = 500;
			text.label = "地址："
			hb.addChild(text);
			
			gotoBtn = new UIAssetsSymbol();
			gotoBtn.source = "web_goto_a"
			gotoBtn.width = 16;
			gotoBtn.height = 16;
			gotoBtn.buttonMode = true;
			hb.addChild(gotoBtn);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.width = 16;
			addBtn.height = 16;
			addBtn.toolTip = "打开新网页"
			addBtn.buttonMode = true;
			hb.addChild(addBtn);
		}
	}
}