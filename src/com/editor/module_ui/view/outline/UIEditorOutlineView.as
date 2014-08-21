package com.editor.module_ui.view.outline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITree;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class UIEditorOutlineView extends UIVBox
	{
		public function UIEditorOutlineView()
		{
			super();
			create_init();
		}
		
		public var comList:UITree;
		
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
			
			var lb:UILabel = new UILabel();
			lb.text = "只允许向下有一层的容器"
			hb1.addChild(lb);
			
			comList = new UITree();
			comList.name = "compList"
			comList.leaf_itemRenderer = UIOutlineLeafItemRenderer;
			comList.branch_itemRenderer = UIOutlineBranchItemRenderer;
			comList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			comList.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			comList.rowHeight = 25;
			comList.paddingLeft = 2;
			comList.paddingRight = 2;
			comList.enabledPercentSize = true
			addChild(comList);
			
		}
		
	}
}