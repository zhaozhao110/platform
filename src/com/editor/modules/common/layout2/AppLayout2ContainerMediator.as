package com.editor.modules.common.layout2
{
	import com.editor.mediator.AppStackMediator;
	import com.editor.modules.common.layout2.top.AppLayout2ToolBar;
	import com.editor.modules.common.layout2.top.AppLayout2ToolBarMediator;

	public class AppLayout2ContainerMediator extends AppStackMediator
	{
		public function AppLayout2ContainerMediator(viewComponent:Object=null,_stack:int=-1)
		{
			super("AppLayout2ContainerMediator|"+_stack, viewComponent);
		}
		public function get layout2Container():AppLayout2Container
		{
			return viewComponent as AppLayout2Container
		}
		public function get toolBar():AppLayout2ToolBar
		{
			return layout2Container.toolBar;
		}
		public function get middleContainer():AppLayout2MiddleContainer
		{
			return layout2Container.middleContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			registerMediator(new AppLayout2ToolBarMediator(toolBar,getStackType()));
			registerMediator(new AppLayout2MiddleContainerMediator(middleContainer,getStackType()));
		}
	}
}