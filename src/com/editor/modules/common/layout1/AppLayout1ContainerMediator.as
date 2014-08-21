package com.editor.modules.common.layout1
{
	import com.editor.mediator.AppStackMediator;
	import com.editor.modules.common.layout1.center.AppLayout1CenterContainer;
	import com.editor.modules.common.layout1.center.AppLayout1CenterContainerMediator;
	import com.editor.modules.common.layout1.left.AppLayout1LeftContainer;
	import com.editor.modules.common.layout1.left.AppLayout1LeftContainerMediator;
	import com.editor.modules.common.layout1.right.AppLayout1RightContainer;
	import com.editor.modules.common.layout1.right.AppLayout1RightContainerMediator;

	public class AppLayout1ContainerMediator extends AppStackMediator
	{
		public function AppLayout1ContainerMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout1ContainerMediator|"+_stack, viewComponent);
		}
		public function get layout1Container():AppLayout1Container
		{
			return viewComponent as AppLayout1Container
		}
		public function get leftContainer():AppLayout1LeftContainer
		{
			return layout1Container.leftContainer;
		}
		public function get middleContainer():AppLayout1CenterContainer
		{
			return layout1Container.middleContainer;
		}
		public function get rightContainer():AppLayout1RightContainer
		{
			return layout1Container.rightContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			registerMediator(new AppLayout1LeftContainerMediator(leftContainer,getStackType()));
			registerMediator(new AppLayout1CenterContainerMediator(middleContainer,getStackType()));
			registerMediator(new AppLayout1RightContainerMediator(rightContainer,getStackType()));
		}
		
	}
}