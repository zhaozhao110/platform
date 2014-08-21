package com.editor.component
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;

	public class LogContainer extends UIVBox
	{
		public function LogContainer()
		{
			super();
			create_init()
		}
		
		private var logTxt:UITextArea;
		private var closeBtn:UIImage;
		private var closeCB:UICheckBox;
		
		private function create_init():void
		{
			percentWidth = 100;
			height = 300;
			bottom = 0;
			visible = false;
			backgroundColor = ColorUtils.black;
			padding =5;
			styleName = "uicanvas";
			name = "LogContainer"
			
			var hbox29:UIHBox = new UIHBox();
			hbox29.name = "UIHBox123"
			hbox29.height=30
			hbox29.verticalAlignMiddle = true;
			hbox29.horizontalGap = 10;
			hbox29.percentWidth = 100;
			hbox29.paddingLeft=20
			addChild(hbox29);
						
			var lb:UILabel = new UILabel();
			lb.text = "记录log";
			lb.color = ColorUtils.white;
			lb.height = 20
			hbox29.addChild(lb);
			
			closeBtn = new UIImage();
			closeBtn.buttonMode = true;
			closeBtn.width = 16;
			closeBtn.height = 16;
			closeBtn.source = "close2_a";
			closeBtn.addEventListener(MouseEvent.CLICK , onCloseBtnClick);
			hbox29.addChild(closeBtn);
			
			closeCB = new UICheckBox();
			closeCB.selected = false;
			closeCB.label = "总不再提示";
			closeCB.color = ColorUtils.white;
			hbox29.addChild(closeCB);
			
			lb = new UILabel();
			lb.text = "快捷键(CTRL+L)可再次打开";
			hbox29.addChild(lb)
			
			logTxt = new UITextArea();
			logTxt.name="logTxt123"
			//logTxt.color = ColorUtils.white;
			logTxt.editable = false;
			logTxt.enabledPercentSize = true;
			addChild(logTxt);
		}
		
		public function addLog(s:String):void
		{
			logTxt.htmlText += s + "<br>"
			if(closeCB.selected) return ;
			visible = true;
		}
		
		private function onCloseBtnClick(e:MouseEvent):void
		{
			visible = false;	
		}
		
		public function forceOpen():void
		{
			visible = true;
		}
	}
}