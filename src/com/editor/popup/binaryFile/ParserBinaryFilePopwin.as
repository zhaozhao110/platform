package com.editor.popup.binaryFile
{
	import com.air.component.SandySelectFileButton;
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.expand.UITextInputComboBox;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
 
	public class ParserBinaryFilePopwin extends AppPopupWithEmptyWin
	{
		public function ParserBinaryFilePopwin()
		{
			super()
			create_init();
		}
		
		public var selectBtn:UIButton;
		public var saveBtn1:UIButton;
		public var saveBtn2:UIButton;
		public var selectBtn3:UIButton;
		public var selectBtn4:UIButton;
		public var text:UITextArea;
		/*public var textInput:UITextInputComboBox;
		public var downBtn:UIButton;*/
		public var isCompCB:UICheckBox
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			form.verticalGap = 10;
			form.y = 20;
			form.padding = 5;
			form.percentWidth = 100;
			form.height = 450
			addContentChild(form);
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.percentWidth = 100;
			form.addChild(hb1);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择二进制文件";
			hb1.addChild(selectBtn);
			
			selectBtn3 = new UIButton();
			selectBtn3.label = "选择解析后的文件";
			hb1.addChild(selectBtn3);
			
			saveBtn1 = new UIButton();
			saveBtn1.label = "保存二进制文件";
			hb1.addChild(saveBtn1);
			
			saveBtn2 = new UIButton();
			saveBtn2.label = "保存解析后的文件";
			hb1.addChild(saveBtn2);
			
			selectBtn4 = new UIButton();
			selectBtn4.label = "批量转文件成二进制";
			hb1.addChild(selectBtn4);
			
			var hb2:UIHBox = new UIHBox();
			hb2.percentWidth = 100;
			hb2.height = 30;
			hb2.paddingLeft = 5;
			hb2.paddingRight = 5
			form.addChild(hb2);
			
			/*textInput = new UITextInputComboBox();
			textInput.height = 25;
			textInput.percentWidth = 100;
			textInput.label = "输入二进制文件的http地址: "
			hb2.addChild(textInput);
			
			downBtn = new UIButton();
			downBtn.label = "下载";
			hb2.addChild(downBtn);*/
			
			isCompCB = new UICheckBox();
			isCompCB.label = "是压缩的"
			hb2.addChild(isCompCB);
			isCompCB.selected = true
			
			text = new UITextArea();
			text.percentWidth = 100;
			text.height = 300;
			form.addChild(text);
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL
			opts.width = 800;
			opts.height = 500;
			opts.title = "解析二进制文件"
			opts.minimizable = true
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.ParserBinaryFilePopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ParserBinaryFilePopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ParserBinaryFilePopwinMediator.NAME)
		}
	}
}