package com.editor.d3.app.view.ui.middle
{
	import com.editor.mediator.AppMediator;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class App3DSceneContainerMediator extends AppMediator
	{
		public static const NAME:String = "App3DSceneContainerMediator"
		public function App3DSceneContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get sceneContainer():App3DSceneContainer
		{
			return viewComponent as App3DSceneContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
	}
}