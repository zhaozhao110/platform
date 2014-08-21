package com.editor.popup.input
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.NativeWindowType;

	public class InputTextPopwin extends AppPopupWithEmptyWin
	{
		public function InputTextPopwin()
		{
			super()
			create_init();
		}
		
		
		public var textInput:UITextInputWidthLabel;
		public var infoTxt:UIText;
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			form.verticalGap = 10;
			form.y = 20;
			form.padding = 5;
			form.width = 400;
			form.height = 150
			this.addChild(form);
			
			textInput = new UITextInputWidthLabel();
			textInput.label = "输入：";
			textInput.width = 350;
			form.addChild(textInput);
			
			infoTxt = new UIText();
			infoTxt.width = 350;
			infoTxt.height = 60;
			infoTxt.multiline = true;
			form.addChild(infoTxt);
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 200;
			opts.title = "输入文本"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.InputTextPopwin_sign
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new InputTextPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(InputTextPopwinMediator.NAME)
		}
	}
}