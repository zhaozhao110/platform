package com.editor.modules.app.view.ui.topPopup
{
	import com.editor.mediator.AppMediator;
	
	
	public class AppTopPopContainerMediator  extends AppMediator
	{
		public static const NAME:String = 'AppTopPopContainerMediator'
		public function AppTopPopContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get topContainer():AppTopPopContainer
		{
			return viewComponent as AppTopPopContainer
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		
	}
}