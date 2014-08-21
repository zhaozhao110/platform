package com.editor.project_pop.getLocale
{
	import com.air.io.SelectFile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.project_pop.getLocale.locale.GetLocaleProcessor;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class AppGetLocaleWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppGetLocaleWinMediator"
		public function AppGetLocaleWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():AppGetLocaleWin
		{
			return viewComponent as AppGetLocaleWin
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
	}
}