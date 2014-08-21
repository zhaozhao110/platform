package com.editor.module_ui.view.uiAttri
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.expand.SandyReflashButton;

	/**
	 * 组件的属性列表
	 */ 
	public class UIEditorAttriListView extends UIVBox
	{
		public function UIEditorAttriListView()
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
			padding = 5;
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100;
			hb.height = 30;
			hb.horizontalGap=5;
			hb.styleName = "uicanvas"
			hb.verticalAlign = ASComponentConst.verticalAlign_middle;
			addChild(hb);
			
			comNameLb = new UILabel();
			comNameLb.width = 200
			hb.addChild(comNameLb);
			
			createBtn = new SandyReflashButton();
			createBtn.label = "发布并保存";
			//createBtn.visible = false;
			createBtn.toolTip = "生成as文件"
			hb.addChild(createBtn);
			
			vs = new UIViewStack();
			vs.enabledPercentSize = true;
			addChild(vs);
			
		}
	}
}