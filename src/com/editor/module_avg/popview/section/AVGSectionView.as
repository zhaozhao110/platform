package com.editor.module_avg.popview.section
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.module_avg.popview.section.component.AVGSectionViewItemRenderer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class AVGSectionView extends UIVBox
	{
		public function AVGSectionView()
		{
			super();
			create_init();
		}
		
		public var fileBox:UIVBox;
		public var addBtn:UIButton;
		
		private function create_init():void
		{
			label = "分段"
			enabledPercentSize = true;
			styleName = "uicanvas"
						
			var h:UIHBox = new UIHBox();
			h.height = 30;
			h.verticalAlignMiddle = true;
			h.paddingLeft = 10;
			h.percentWidth = 100;
			h.styleName = "uicanvas"
			addChild(h);
			
			addBtn = new UIButton();
			addBtn.label = "新建"
			h.addChild(addBtn);
			
			fileBox = new UIVBox();
			fileBox.styleName = "list"
			fileBox.padding = 3;
			fileBox.rowHeight = 25;
			fileBox.enabledPercentSize = true;
			fileBox.enabeldSelect = true;
			fileBox.itemRenderer = AVGSectionViewItemRenderer;
			fileBox.addEventListener(ASEvent.CHANGE,onFileChange);
			fileBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(fileBox);
		}
		
		private function onFileChange(e:ASEvent):void
		{
			
		}
	}
}