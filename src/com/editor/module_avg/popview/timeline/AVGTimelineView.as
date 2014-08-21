package com.editor.module_avg.popview.timeline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.module_avg.popview.timeline.component.AVGTimelineViewItemRenderer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class AVGTimelineView extends UIVBox
	{
		public function AVGTimelineView()
		{
			super();
			create_init();
		}
		
		public var fileBox:UIVBox;
		public var addBtn:UIButton;
		public var delBtn:UIButton;
		public var copyBtn:UIButton;
		public var copyTi:UITextInput;
		
		private function create_init():void
		{
			label = "时间轴"
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
			
			delBtn = new UIButton();
			delBtn.label = "删除"
			h.addChild(delBtn);
			
			copyBtn = new UIButton();
			copyBtn.label = "复制"
			h.addChild(copyBtn);
			
			copyTi = new UITextInput();
			copyTi.width = 100;
			copyTi.onlyNumber = true;
			h.addChild(copyTi);
			
			fileBox = new UIVBox();
			fileBox.styleName = "list"
			fileBox.padding = 3;
			fileBox.rowHeight = 50;
			fileBox.enabledPercentSize = true;
			fileBox.enabeldSelect = true;
			fileBox.itemRenderer = AVGTimelineViewItemRenderer;
			fileBox.addEventListener(ASEvent.CHANGE,onFileChange);
			fileBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(fileBox);
		}
		
		private function onFileChange(e:ASEvent):void
		{
			
		}
	}
}