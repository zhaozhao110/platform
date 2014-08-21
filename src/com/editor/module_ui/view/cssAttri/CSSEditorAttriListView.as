package com.editor.module_ui.view.cssAttri
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.expand.SandyReflashButton;

	public class CSSEditorAttriListView extends UIVBox
	{
		public function CSSEditorAttriListView()
		{
			super();
			create_init();
		}
		
		public var comNameLb:UILabel;
		public var vs:UIViewStack;
		public var createBtn:SandyReflashButton;
		
		private function create_init():void
		{
			verticalGap = 5;
			styleName = "uicanvas"
			enabledPercentSize = true;
			mouseEnabled = true;
			mouseChildren = true;
			padding = 3;
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 30;
			hb.horizontalGap = 5;
			hb.verticalAlign = ASComponentConst.verticalAlign_middle;
			hb.styleName = "uicanvas"
			addChild(hb);
			
			comNameLb = new UILabel();
			hb.addChild(comNameLb);
			
			createBtn = new SandyReflashButton();
			createBtn.label = "发布并保存";
			createBtn.visible = false;
			createBtn.toolTip = "生成as文件"
			hb.addChild(createBtn);
			
			vs = new UIViewStack();
			vs.enabledPercentSize = true;
			addChild(vs);
			
		}
	}
}