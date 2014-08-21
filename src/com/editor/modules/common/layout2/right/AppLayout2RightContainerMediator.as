package com.editor.modules.common.layout2.right
{
	import com.editor.component.LogContainer;
	import com.editor.mediator.AppStackMediator;

	public class AppLayout2RightContainerMediator extends AppStackMediator
	{
		public function AppLayout2RightContainerMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout2RightContainerMediator|"+_stack, viewComponent);
		}
		public function get rightContainer():AppLayout2RightContainer
		{
			return viewComponent as AppLayout2RightContainer;
		}
		public function get logContainer():LogContainer
		{
			return rightContainer.logContainer;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function addLog2(s:String):void
		{
			logContainer.addLog(s);
		}
	}
}