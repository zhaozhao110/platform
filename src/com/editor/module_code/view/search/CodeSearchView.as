package com.editor.module_code.view.search
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIVlist;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class CodeSearchView extends UIVBox
	{
		public function CodeSearchView()
		{
			super();
			create_init();
		}
		
		public var comList:UIVlist;
		public var infoLb:UILabel;
		
		private function create_init():void
		{
			verticalGap = 5;
			styleName = "uicanvas"
			enabledPercentSize = true;
			mouseEnabled = true;
			mouseChildren = true;
			padding = 3;
			//visible = false
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.styleName = "uicanvas"
			hb1.percentWidth = 100;
			hb1.paddingRight = 5;
			hb1.paddingLeft = 10;
			hb1.verticalAlignMiddle = true
			hb1.verticalAlign = ASComponentConst.verticalAlign_middle;
			addChild(hb1);
			
			infoLb = new UILabel();
			hb1.addChild(infoLb);
			
			comList = new UIVlist();
			comList.name = "CodeOutLineView"
			comList.doubleClickEnabled = true
			comList.enabeldSelect = true
			comList.styleName = "list"
			comList.itemRenderer = CodeSearchViewItemRenderer;
			comList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			comList.paddingLeft = 2;
			comList.paddingRight = 2;
			comList.enabledPercentSize = true;
			addChild(comList);
			
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
		}
	}
}