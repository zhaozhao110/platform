package com.editor.popup.input
{
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.StringTWLUtil;

	public class InputTextPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "InputTextPopwinMediator"
		public function InputTextPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get inputWin():InputTextPopwin
		{
			return viewComponent as InputTextPopwin;
		}
		public function get textInput():UITextInputWidthLabel
		{
			return inputWin.textInput;
		}
		public function get infoTxt():UIText
		{
			return inputWin.infoTxt;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			inputWinVO = (inputWin.item as OpenPopwinData).data as InputTextPopwinVO;
			inputWin.title = inputWinVO.title;
			infoTxt.htmlText = inputWinVO.info;		
			textInput.text = inputWinVO.text;
		}
		
		private var inputWinVO:InputTextPopwinVO;
		
		override protected function okButtonClick():void
		{
			if(StringTWLUtil.isWhitespace(textInput.text)) return ;
			if(inputWinVO.okButtonArgs!=null){
				inputWinVO.okButtonFun(textInput.text,inputWinVO.okButtonArgs)
			}else{
				inputWinVO.okButtonFun(textInput.text)
			}
			closeWin();
		}
		
		
	}
}