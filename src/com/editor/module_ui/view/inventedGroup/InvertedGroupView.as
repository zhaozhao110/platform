package com.editor.module_ui.view.inventedGroup
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIVlist;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class InvertedGroupView extends UIVBox
	{
		public function InvertedGroupView()
		{
			super();
			create_init();
		}
		
		public var comList:UIVBox;
		public var addBtn:UIAssetsSymbol;
		
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
			hb1.paddingLeft = 20;
			hb1.verticalAlign = ASComponentConst.verticalAlign_middle;
			addChild(hb1);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a";
			addBtn.buttonMode = true;
			addBtn.toolTip = "新建"
			hb1.addChild(addBtn);
			
			comList = new UIVBox();
			comList.styleName = "list";
			comList.paddingTop = 2;
			comList.itemRenderer = InvertedGroupItemRenderer;
			comList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			comList.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			comList.rowHeight = 25;
			comList.paddingLeft = 2;
			comList.paddingRight = 2;
			comList.percentWidth =100;
			comList.verticalGap = 2;
			comList.height = 650
			addChild(comList);
			
		}
		
		
		
	}
}