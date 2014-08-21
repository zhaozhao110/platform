package com.editor.modules.common.layout2.left
{
	import com.editor.mediator.AppStackMediator;

	public class AppLayout2LeftContainerMediator extends AppStackMediator
	{
		public function AppLayout2LeftContainerMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout2LeftContainerMediator|"+_stack, viewComponent);
		}
		public function get leftContainer():AppLayout2LeftContainer
		{
			return viewComponent as AppLayout2LeftContainer;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
		}
	}
}