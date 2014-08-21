package com.editor.modules.common.layout1.left
{
	import com.editor.mediator.AppStackMediator;

	public class AppLayout1LeftContainerMediator extends AppStackMediator
	{
		public function AppLayout1LeftContainerMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout1LeftContainerMediator|"+_stack, viewComponent);
		}
		public function get leftContainer():AppLayout1LeftContainer
		{
			return viewComponent as AppLayout1LeftContainer;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
		}
	}
}