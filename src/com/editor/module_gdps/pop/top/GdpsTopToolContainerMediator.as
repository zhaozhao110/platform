package com.editor.module_gdps.pop.top
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.event.AppEvent;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.model.AppOpenMessageData;
	import com.editor.module_gdps.app.GDPSMainUIContainerMediator;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.pop.left.GdpsLeftContainerMediator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.view.preloader.AppPreLoaderContainerMediator;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;

	public class GdpsTopToolContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsTopToolContainerMediator";
		
		public function GdpsTopToolContainerMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get topCell():GdpsTopToolContainer
		{
			return viewComponent as GdpsTopToolContainer;
		}
		public function get userInfo():UILabel
		{
			return topCell.userInfo;
		}
		public function get quitBtn():UIButton
		{
			return topCell.quitBtn;
		}
		public function get gotoGameBtn():UIButton
		{
			return topCell.gotoGameBtn;
		}
		public function get changeBtn():UIButton
		{
			return topCell.changeBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function respondToInitCompleteGDPSEvent(noti:Notification):void
		{
			userInfo.text = "欢迎您：" + CacheDataUtil.getUserInfo().getUsername + " | 当前项目：" + 
				CacheDataUtil.getUserInfo().getProjectName;
			
			topCell.visible = true;
			
			if(GDPSDataManager.getInstance().getProjects.length <= 1){
				changeBtn.enabled = false;
			}else{
				changeBtn.enabled  = true;
			}
		}
		
		public function reactToQuitBtnClick(e:MouseEvent):void
		{
			var vo:AppOpenMessageData = new AppOpenMessageData();
			vo.info = "您确认需要退出系统吗？";
			vo.showButtonType = 1;
			vo.okFunction = sureQuit;
			showConfirm(vo);
		}
		
		private function sureQuit():Boolean
		{
			NativeApplication.nativeApplication.exit();
			return true;
		}
		
		public function reactToGotoGameBtnClick(e:MouseEvent):void
		{
			sendAppNotification(AppEvent.sendGotoGameEditor_event);
		}
		
		public function reactToChangeBtnClick(e:MouseEvent):void
		{
			if(GDPSDataManager.getInstance().getProjects.length > 1)
			{
				sendNotification(GDPSAppEvent.showGDPSProjects_event);
			}
		}
		
		private function getLeftMedi():GdpsLeftContainerMediator
		{
			return retrieveMediator(GdpsLeftContainerMediator.NAME) as GdpsLeftContainerMediator;
		}
	}
}