package com.editor.module_avg.popview.outline
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.module_avg.popview.outline.component.AVGOutlineItemRenderer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class AVGOutlineView extends UIVBox
	{
		public function AVGOutlineView()
		{
			super();
			create_init();
		}
		
		public var pathTi:UITextInput;
		public var fileBox:UIVBox
		
		private function create_init():void
		{
			label = "大纲"
			enabledPercentSize = true;
			styleName = "uicanvas"
			
			var h:UIHBox = new UIHBox();
			h.height = 30;
			h.verticalAlignMiddle = true;
			h.percentWidth = 100;
			h.styleName = "uicanvas"
			addChild(h);
			
			fileBox = new UIVBox();
			fileBox.enabledPercentSize = true;
			fileBox.enabeldSelect = true;
			fileBox.rowHeight = 25;
			fileBox.itemRenderer = AVGOutlineItemRenderer;
			fileBox.addEventListener(ASEvent.CHANGE,onFileChange);
			fileBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(fileBox);
		}
		
		private function onFileChange(e:ASEvent):void
		{
			
		}
	}
}