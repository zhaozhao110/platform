package com.editor.modules.common.layout2
{
	import com.editor.mediator.AppStackMediator;
	import com.editor.modules.common.layout2.left.AppLayout2LeftContainer;
	import com.editor.modules.common.layout2.left.AppLayout2LeftContainerMediator;
	import com.editor.modules.common.layout2.right.AppLayout2RightContainer;
	import com.editor.modules.common.layout2.right.AppLayout2RightContainerMediator;

	public class AppLayout2MiddleContainerMediator extends AppStackMediator
	{
		public function AppLayout2MiddleContainerMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout2MiddleContainerMediator|"+_stack, viewComponent);
		}
		public function get middleContainer():AppLayout2MiddleContainer
		{
			return viewComponent as AppLayout2MiddleContainer; 
		}
		public function get leftContainer():AppLayout2LeftContainer
		{
			return middleContainer.leftContainer;
		}
		public function get rightContainer():AppLayout2RightContainer
		{
			return middleContainer.rightContainer
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			registerMediator(new AppLayout2LeftContainerMediator(leftContainer,getStackType()))
			registerMediator(new AppLayout2RightContainerMediator(rightContainer,getStackType()))
		}
	}
}