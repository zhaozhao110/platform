package com.editor.module_changeLog.view
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.AppMainModel;
	import com.editor.module_changeLog.component.ChangeLogLeftViewItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class ChangeLogLeftView extends UIVBox
	{
		public function ChangeLogLeftView()
		{
			super();
			create_init();
		}
		
		public var vbox:UIVlist;
		public var okButton:UIButton;
		public var delButton:UIButton;
		public var preBtn:UIButton;
		public var nextBtn:UIButton;
		
		private function create_init():void
		{
			padding = 5;	
			verticalGap = 5;
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			hb.styleName = "uicanvas"
			hb.verticalAlignMiddle = true
			addChild(hb);
			if(!AppMainModel.getInstance().user.checkIsSystem()){
				hb.visible = false; 
			}
			
			okButton = new UIButton();
			okButton.label = "新建"
			hb.addChild(okButton);
			
			delButton = new UIButton();
			delButton.label = "删除"
			hb.addChild(delButton);
			
			vbox = new UIVlist();
			vbox.percentWidth = 100;
			vbox.percentHeight = 100;
			vbox.styleName = "list"
			vbox.enabeldSelect = true;
			vbox.rightClickEnabled = true;
			vbox.itemRenderer = ChangeLogLeftViewItemRenderer;
			vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(vbox);
			
			hb = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			hb.styleName = "uicanvas"
			hb.verticalAlignMiddle = true
			addChild(hb);
			
			preBtn = new UIButton();
			preBtn.label = "上一页"
			hb.addChild(preBtn);
			
			nextBtn = new UIButton();
			nextBtn.label = "下一页"
			hb.addChild(nextBtn);
		}
		
	}
}