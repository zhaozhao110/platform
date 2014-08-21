package com.editor.module_gdps.app
{
	import com.editor.manager.DataManager;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.pop.left.GdpsLeftContainer;
	import com.editor.module_gdps.pop.left.GdpsLeftContainerMediator;
	import com.editor.module_gdps.pop.project.LoginProjectPopwin;
	import com.editor.module_gdps.pop.project.LoginProjectPopwinMediator;
	import com.editor.module_gdps.pop.right.GdpsRightContainer;
	import com.editor.module_gdps.pop.right.GdpsRightContainerMediator;
	import com.editor.module_gdps.pop.top.GdpsTopToolContainer;
	import com.editor.module_gdps.pop.top.GdpsTopToolContainerMediator;
	import com.editor.module_gdps.proxy.GdpsTreeConfigProxy;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.desktop.NativeApplication;
	import flash.events.NativeWindowBoundsEvent;

	public class GDPSMainUIContainerMediator extends AppMediator
	{
		public static const NAME:String = 'GDPSMainUIContainerMediator'
		public function GDPSMainUIContainerMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get container():GDPSMainUIContainer
		{
			return viewComponent as GDPSMainUIContainer;
		}
		public function get topCell():GdpsTopToolContainer
		{
			return container.topCell;
		}
		public function get leftCell():GdpsLeftContainer
		{
			return container.leftCell as GdpsLeftContainer;
		}
		public function get rightCell():GdpsRightContainer
		{
			return container.rightCell;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			respondToEnterGDPSMainUIEvent();
		}
		
		public function respondToEnterGDPSMainUIEvent(noti:Notification=null):void
		{
			container.backgroundColor = DataManager.def_col;
			
			if(!hasProxy(GdpsTreeConfigProxy.NAME))
			{
				registerProxy(new GdpsTreeConfigProxy());
				registerMediator(new GdpsTopToolContainerMediator(topCell));
				registerMediator(new GdpsLeftContainerMediator(leftCell));
				registerMediator(new GdpsRightContainerMediator(rightCell));
			}
			
			if(CacheDataUtil.getUserInfo() != null){
				sendNotification(GDPSAppEvent.initCompleteGDPS_event);
			}
			
			NativeApplication.nativeApplication.activeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE , onResize);
		}
		
		private function onResize(e:NativeWindowBoundsEvent):void
		{
			container.width = e.afterBounds.width;
			container.height = e.afterBounds.height-20;
		}
		
		public function respondToSendGotoGameEditorEvent(noti:Notification):void
		{
			
		}
		
	}
}