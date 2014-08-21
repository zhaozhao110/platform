package com.editor.modules.common.layout1.center
{
	import com.editor.mediator.AppStackMediator;

	public class AppLayout1CenterContainerMediator extends AppStackMediator
	{
		public function AppLayout1CenterContainerMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout1CenterContainerMediator|"+_stack, viewComponent);
		}
		public function get middleContainer():AppLayout1CenterContainer
		{
			return viewComponent as AppLayout1CenterContainer; 
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
	}
}