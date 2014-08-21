package com.editor.popup.packImage
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
	
	public class PackImagePopwin extends AppPopupWithEmptyWin
	{
		public function PackImagePopwin()
		{
			super()
			create_init();
		}
		
		public var text:UITextArea;
		public var selectBtn:UIButton;
		public var textInput:UITextInputWidthLabel;
		public var selectBtn2:UIButton;
		public var textInput2:UITextInputWidthLabel;
		public var packBtn:UIButton;
		
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
			textInput.label = "选择jre的目录";
			//textInput.text = "C:\\Program Files\\Java\\jre6"
			textInput.width = 500
			hb1.addChild(textInput);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择";
			hb1.addChild(selectBtn);
			
			
			
			var hb2:UIHBox = new UIHBox();
			hb2.height = 30;
			hb2.percentWidth = 100;
			form.addChild(hb2);
			
			textInput2 = new UITextInputWidthLabel();
			textInput2.label = "选择存放图片的目录";
			textInput2.width = 500
			hb2.addChild(textInput2);
			
			selectBtn2 = new UIButton();
			selectBtn2.label = "选择";
			hb2.addChild(selectBtn2);
			
			packBtn = new UIButton();
			packBtn.label = "打包";
			form.addChild(packBtn);
			
			
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
			opts.title = "打包图片到fla库"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.PackImagePopwin_sign
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new PackImagePopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(PackImagePopwinMediator.NAME)
		}
	}
}