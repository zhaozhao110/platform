package com.editor.module_ui.view.comList
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIVlist;
	import com.sandy.asComponent.controls.ASLabel;
	import com.sandy.asComponent.vo.ASComponentConst;

	/**
	 * 组件列表
	 */ 
	public class UIEditorComponentListView extends UIVBox
	{
		public function UIEditorComponentListView()
		{
			super();
			create_init();
		}
		
		public var comType_ls:UICombobox;
		public var comList:UIVlist;
		
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
			lb.text = "组件类型 : ";
			lb.width = 60;
			hb1.addChild(lb);
			lb.enabledFliter
			
			comType_ls = new UICombobox();
			comType_ls.height = 20;
			comType_ls.percentWidth = 100;
			comType_ls.dropDownWidth = 200
			hb1.addChild(comType_ls);
			
			comList = new UIVlist();
			//comList.background_red = true;
			comList.name = "compList"
			comList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			comList.itemRenderer = UIEditorComListItemRenderer;
			comList.dragAndDrop = true;
			comList.rowHeight = 25;
			comList.paddingLeft = 2;
			comList.paddingRight = 2;
			comList.enabledPercentSize = true
			addChild(comList);
			
		}
		
	}
}