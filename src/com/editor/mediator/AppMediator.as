package com.editor.mediator
{
	
	import com.editor.event.AppEvent;
	import com.editor.manager.LogManager;
	import com.sandy.fabrication.SandyMediator;
	import com.sandy.popupwin.interfac.IPopupwinMangerMediator;
	
	import mx.utils.StringUtil;
	

	public class AppMediator extends SandyMediator
	{
		public function AppMediator(name:String = null, viewComponent:Object = null):void
		{
			super(name,viewComponent)
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		protected function getAppPopupwManagerMediator():IPopupwinMangerMediator
		{
			return iPopupwin.getManager();
		}
		
		protected function addLog(s:String):void
		{
			LogManager.getInstance().addLog(s);
		}
	}
}