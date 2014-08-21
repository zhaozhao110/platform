package com.editor.mediator
{
	import com.editor.component.LogContainer;
	import com.editor.modules.common.layout2.AppLayout2Container;
	import com.editor.modules.common.layout2.AppLayout2ContainerMediator;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class UIModule2Mediator extends AppMediator
	{
		public function UIModule2Mediator(name:String=null, viewComponent:Object=null)
		{
			super(name, viewComponent);
		}
		public function get layout2Container():AppLayout2Container
		{
			return Object(viewComponent).layout2Container;
		}
		public function get logContainer():LogContainer
		{
			return layout2Container.getLogContainer();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
				
			registerMediator(new AppLayout2ContainerMediator(layout2Container,getStackType()));
		}
				
		protected function getStackType():int
		{
			return -1;
		}
		
		public function addLog2(s:String):void
		{
			layout2Container.getLogContainer().addLog(s);
		}
		
		public function respondToOpenLogEvent(noti:Notification):void
		{
			if(layout2Container.visible && layout2Container.getLogContainer()!=null){
				layout2Container.getLogContainer().forceOpen();
			}
		}
	}
}