package com.editor.module_avg.popview.lib
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.module_avg.popview.lib.component.AVGLibViewItemRenderer;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;

	public class AVGLibView extends UIVBox
	{
		public function AVGLibView()
		{
			super();
			create_init();
		}
		
		public var pathTi:UITextInput;
		public var fileBox:UIVlist;
		public var preBtn:UIButton;
		public var sdBtn:UIButton;
		
		
		private function create_init():void
		{
			label = "资源库"
			enabledPercentSize = true;
			styleName = "uicanvas"
			
			var h:UIHBox = new UIHBox();
			h.height = 30;
			h.paddingLeft = 5;
			h.verticalAlignMiddle = true;
			h.percentWidth = 100;
			h.styleName = "uicanvas"
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.width = 40;
			lb.text = "路径: " 
			h.addChild(lb);
			
			pathTi = new UITextInput();
			pathTi.editable = false;
			//pathTi.selectable = false;
			pathTi.percentWidth = 100;
			pathTi.text = "res/res/avg/"
			h.addChild(pathTi);
			
			preBtn = new UIButton();
			preBtn.label = "上一级"
			h.addChild(preBtn);
			
			sdBtn = new UIButton();
			sdBtn.label = "暂停声音"
			h.addChild(sdBtn);
			
			fileBox = new UIVlist();
			fileBox.styleName = "list"
			fileBox.enabledPercentSize = true;
			fileBox.enabeldSelect = true;
			fileBox.itemRenderer = AVGLibViewItemRenderer;
			fileBox.addEventListener(ASEvent.CHANGE,onFileChange);
			fileBox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			fileBox.dragAndDrop = true;
			fileBox.rowHeight = 25;
			addChild(fileBox);
		}
		
		private function onFileChange(e:ASEvent):void
		{
			
		}
	}
}