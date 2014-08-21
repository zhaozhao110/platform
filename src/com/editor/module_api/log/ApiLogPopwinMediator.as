package com.editor.module_api.log
{
	import com.sandy.component.controls.text.SandyTextArea;
	import com.sandy.popupwin.mediator.DestroyPopupwinMediator;
	
	
	public class ApiLogPopwinMediator extends DestroyPopupwinMediator
	{
		public static const NAME:String = "ApiLogPopwinMediator"
		public function ApiLogPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get inputWin():ApiLogPopwin
		{
			return viewComponent as ApiLogPopwin;
		}
		public function get textInput():SandyTextArea
		{
			return inputWin.textInput;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
	}
}