package com.editor.modules.common.layout2.top
{
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.AppStackMediator;

	public class AppLayout2ToolBarMediator extends AppStackMediator
	{
		public function AppLayout2ToolBarMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout2ToolBarMediator|"+_stack, viewComponent);
		}
		
		public function get toolBar():AppLayout2ToolBar
		{
			return viewComponent as AppLayout2ToolBar
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
	}
}