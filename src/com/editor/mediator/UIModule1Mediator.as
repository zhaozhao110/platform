package com.editor.mediator
{
	import com.editor.modules.common.layout1.AppLayout1Container;
	import com.editor.modules.common.layout1.AppLayout1ContainerMediator;

	public class UIModule1Mediator extends AppMediator
	{
		public function UIModule1Mediator(name:String=null, viewComponent:Object=null)
		{
			super(name, viewComponent);
		}
		public function get layout1Container():AppLayout1Container
		{
			return Object(viewComponent).layout1Container;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new AppLayout1ContainerMediator(layout1Container,getStackType()));
		}
		
		protected function getStackType():int
		{
			return -1;
		}
		
	}
}