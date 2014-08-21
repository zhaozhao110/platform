package com.editor.popup.upload
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.component.expand.UITextInputComboBox;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.air.component.SandySelectFileButton;
	import com.air.popupwin.data.AIRPopOptions;
	
	
	import flash.display.NativeWindowType;
	
	public class UploadFilePopwin extends AppPopupWithEmptyWin
	{
		public function UploadFilePopwin()
		{
			super()
			create_init();
		}
		
		public var uploadBtn:UIButton;
		public var selectBtn:UIButton;
		public var text:UITextArea;
		public var textInput:UITextInputWidthLabel;
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			form.verticalGap = 10;
			form.y = 20;
			form.padding = 5;
			form.enabledPercentSize = true
			this.addChild(form);
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.percentWidth = 100;
			form.addChild(hb1);
			
			textInput = new UITextInputWidthLabel();
			textInput.label = "选择上传的文件";
			hb1.addChild(textInput);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择";
			hb1.addChild(selectBtn);
			
			uploadBtn = new UIButton();
			uploadBtn.label = "上传";
			hb1.addChild(uploadBtn);
					
			text = new UITextArea();
			text.enabledPercentSize = true;
			form.addChild(text);
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 800;
			opts.height = 300;
			opts.title = "解析二进制文件"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.UploadFilePopwin_sign
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new UploadFilePopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(UploadFilePopwinMediator.NAME)
		}
	}
}