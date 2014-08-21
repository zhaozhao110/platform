package com.editor.modules.common.app
{
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.editor.mediator.AppStackMediator;
	import com.editor.mediator.UIModule1Mediator;
	import com.editor.mediator.UIModule2Mediator;
	import com.editor.modules.common.app.center.AppMiddleCenterContainer;
	import com.editor.modules.common.app.center.AppMiddleCenterContainerMediator;
	import com.editor.modules.common.app.left.AppMiddleLeftContainer;
	import com.editor.modules.common.app.left.AppMiddleLeftContainerMediator;
	import com.editor.modules.common.app.right.AppMiddleRightContainer;
	import com.editor.modules.common.app.right.AppMiddleRightContainerMediator;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	public class AppMiddleContainerMediator extends UIModule1Mediator
	{	
		public static const NAME:String = "AppMiddleContainerMediator";
		public function AppMiddleContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get middleContainer():AppMiddleContainer
		{
			return viewComponent as AppMiddleContainer;
		}
		public function get middleLeft():AppMiddleLeftContainer
		{
			return middleContainer.middleLeft
		}
		public function get middleRight():AppMiddleRightContainer
		{
			return middleContainer.middleRight
		}
		public function get middleCenter():AppMiddleCenterContainer
		{
			return middleContainer.middleCenter;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new AppMiddleLeftContainerMediator(middleLeft));
			registerMediator(new AppMiddleCenterContainerMediator(middleCenter));
			registerMediator(new AppMiddleRightContainerMediator(middleRight));
		}
				
		public function respondToSetVisibleRightEvent(noti:Notification):void
		{
			var b:Boolean = Boolean(noti.getBody());
			middleContainer.getRightContainer().includeInLayout=b
			middleContainer.getRightContainer().visible =b
		}
		
	}
}