package com.editor.popup.log
{
	import com.air.logging.CatchLog;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class SysLogPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SysLogPopwinMediator"
		public function SysLogPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get inputWin():SysLogPopwin
		{
			return viewComponent as SysLogPopwin;
		}
		public function get textInput():UITextArea
		{
			return inputWin.textInput;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			textInput.htmlText = StringTWLUtil.replaceNewLine(CatchLog.getInstance().getContent(),"<br>")
		}
		
	}
}