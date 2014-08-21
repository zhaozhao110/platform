package com.editor.modules.app.view.main
{
	
	import com.editor.mediator.AppPopupwinMangerMediator;
	import com.editor.modules.app.view.ui.popup.AppPopupContainerMediator;
	import com.editor.modules.app.view.ui.topPopup.AppTopPopContainerMediator;
	import com.sandy.popupwin.interfac.IPopupwinContainer;
	import com.sandy.popupwin.interfac.ITopPopConfirmContainer;
	
	import flash.display.DisplayObject;
	
	public class AppMainPopupContainerMediator extends AppPopupwinMangerMediator
	{
		public static const NAME:String = "AppMainPopupContainerMediator"
		public function AppMainPopupContainerMediator(viewComponent:Object=null, isApplicationPopupwinManager:Boolean=false)
		{
			super(NAME, viewComponent, isApplicationPopupwinManager);
		}
		public function get mainPopContainer():AppMainPopupContainer
		{
			return viewComponent as AppMainPopupContainer;
		}
		override public function get popupContainer():IPopupwinContainer
		{
			return mainPopContainer.popup;
		}
		override public function get topPopContainer():ITopPopConfirmContainer
		{
			return mainPopContainer.topPopup;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new AppPopupContainerMediator(popupContainer));
			registerMediator(new AppTopPopContainerMediator(topPopContainer));
		}
		
		
	}
}