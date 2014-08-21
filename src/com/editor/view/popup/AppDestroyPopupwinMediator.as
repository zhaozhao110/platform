package com.editor.view.popup
{
	import com.editor.event.AppEvent;
	import com.editor.manager.LogManager;
	import com.sandy.popupwin.mediator.DestroyPopupwinMediator;
	
	public class AppDestroyPopupwinMediator extends DestroyPopupwinMediator
	{
		public function AppDestroyPopupwinMediator(nm:String, viewComponent:Object=null)
		{
			super(nm, viewComponent);
		}
		
		protected function addLog(s:String):void
		{
			LogManager.getInstance().addLog(s);
		}
	}
}