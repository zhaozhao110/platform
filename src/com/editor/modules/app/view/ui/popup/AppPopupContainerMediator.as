package com.editor.modules.app.view.ui.popup
{
	import com.editor.mediator.AppMediator;
	
	public class AppPopupContainerMediator extends AppMediator
	{
		public static const NAME:String = 'AppPopupContainerMediator'
		public function AppPopupContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get container():AppPopupContainer
		{
			return viewComponent as AppPopupContainer
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
	}
}