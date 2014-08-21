package com.editor.modules.common.layout1.right
{
	import com.editor.mediator.AppStackMediator;

	public class AppLayout1RightContainerMediator extends AppStackMediator
	{
		public function AppLayout1RightContainerMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout1RightContainerMediator|"+_stack, viewComponent);
		}
		public function get rightContainer():AppLayout1RightContainer
		{
			return viewComponent as AppLayout1RightContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
	}
}