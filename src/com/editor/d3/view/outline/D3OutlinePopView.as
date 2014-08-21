package com.editor.d3.view.outline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIPopupButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITree;
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.view.outline.component.D3OutlinePopHBox;
	import com.editor.d3.view.outline.component.D3OutlinePopViewItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class D3OutlinePopView extends UIVBox
	{
		public function D3OutlinePopView()
		{
			super();
			create_init();
		}
		
		public var ti:UITextInput;
		public var infoTxt:UILabel;
		public var reflashBtn:UIImage;
		public var hbox:D3OutlinePopHBox;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			
			var h:UIHBox = new UIHBox();
			h.paddingLeft = 5;
			h.height = 25;
			h.percentWidth = 100;
			h.horizontalGap = 5;
			h.verticalAlignMiddle = true;
			h.styleName = "uicanvas"
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "搜索"
			h.addChild(lb);
			
			ti = new UITextInput();
			ti.width = 150;
			h.addChild(ti);
			
			reflashBtn = new UIImage();
			reflashBtn.source = "reflash_a"
			reflashBtn.width = 18;
			reflashBtn.height = 18;
			h.addChild(reflashBtn);
			reflashBtn.toolTip = "刷新"
			reflashBtn.buttonMode = true;
			
			infoTxt = new UILabel();
			h.addChild(infoTxt);
			
			hbox = new D3OutlinePopHBox();
			addChild(hbox);		
		}
	}
}