package com.editor.module_code.view.outline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class CodeOutLineView extends UIVBox
	{
		public function CodeOutLineView()
		{
			super();
			create_init();
		}
		
		public var comList:UIVBox;
		
		private function create_init():void
		{
			verticalGap = 5;
			styleName = "uicanvas"
			enabledPercentSize = true;
			mouseEnabled = true;
			mouseChildren = true;
			padding = 3;
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.styleName = "uicanvas"
			hb1.percentWidth = 100;
			hb1.paddingRight = 5;
			hb1.paddingLeft = 10;
			hb1.verticalAlign = ASComponentConst.verticalAlign_middle;
			addChild(hb1);
			
			comList = new UIVBox();
			comList.name = "CodeOutLineView"
			//comList.background_red = true
			comList.enabeldSelect = true
			comList.styleName = "list"
			comList.itemRenderer = CodeOutlineViewItemRenderer;
			comList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			comList.paddingLeft = 2;
			comList.paddingRight = 2;
			comList.enabledPercentSize = true;
			addChild(comList);
			
		}
		
	}
}