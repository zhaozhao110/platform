package com.editor.popup.input
{
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.expand.UIEditTextToolBar;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class InputTextAreaPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "InputTextAreaPopwinMediator"
		public function InputTextAreaPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get inputWin():InputTextAreaPopwin
		{
			return viewComponent as InputTextAreaPopwin;
		}
		public function get textInput():UITextArea
		{
			return inputWin.textInput;
		}
		public function get infoTxt():UIText
		{
			return inputWin.infoTxt;
		}
		public function get toolBar():UIEditTextToolBar
		{
			return inputWin.toolBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			toolBar.showHtml_f = showHtml;
			toolBar.targetTF = textInput.getTextField().getTextField();
			toolBar.init();
						
			inputWinVO = (inputWin.item as OpenPopwinData).data as InputTextPopwinVO;
			if(inputWinVO == null) return ;
			inputWin.title = inputWinVO.title;
			infoTxt.htmlText = inputWinVO.info;		
			textInput.text = inputWinVO.text;
		}
		
		private var inputWinVO:InputTextPopwinVO;
		
		override protected function okButtonClick():void
		{
			if(StringTWLUtil.isWhitespace(textInput.text)) return ;
			if(inputWinVO!=null && inputWinVO.okButtonFun!=null){
				inputWinVO.okButtonFun(textInput.text)
			}
			closeWin();
		}
		
		public function showHtml():void
		{
			inputWin.form2.visible = true;
			inputWin.textInput2.text = textInput.htmlText;
		}
		
	}
}