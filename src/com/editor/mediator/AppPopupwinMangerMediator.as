package com.editor.mediator
{
	
	import com.sandy.fabrication.SandyMediator;
	import com.sandy.popupwin.PopupwinMangerMediator;
	import com.sandy.popupwin.interfac.IPopupwinMangerMediator;
	
	import mx.utils.StringUtil;
	
	public class AppPopupwinMangerMediator extends PopupwinMangerMediator
	{
		public function AppPopupwinMangerMediator(name:String=null, viewComponent:Object=null,isApplicationPopupwinManager:Boolean=false)
		{
			super(name, viewComponent,isApplicationPopupwinManager);
		}
		
		
	}
}