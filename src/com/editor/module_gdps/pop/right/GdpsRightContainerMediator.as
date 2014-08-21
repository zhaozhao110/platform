package com.editor.module_gdps.pop.right
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsLoadingProgressBar;
	import com.editor.module_gdps.component.GdpsMsgProgressBar;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.proxy.GdpsTreeConfigProxy;
	import com.editor.module_gdps.view.columnProfile.GdpsColumnProfileContainer;
	import com.editor.module_gdps.view.columnProfile.mediator.GdpsColumnProfileContainerMediator;
	import com.editor.module_gdps.view.dataBase.GdpsDataBaseContainer;
	import com.editor.module_gdps.view.dataBase.mediator.GdpsDataBaseContainerMediator;
	import com.editor.module_gdps.view.dataManage.GdpsDataManagerContainer;
	import com.editor.module_gdps.view.dataManage.mediator.GdpsDataManagerContainerMediator;
	import com.editor.module_gdps.view.fileData.GdpsFileDataManagerContainer;
	import com.editor.module_gdps.view.fileData.mediator.GdpsFileDataManagerContainerMediator;
	import com.editor.module_gdps.view.packaging.GdpsPackagingContainer;
	import com.editor.module_gdps.view.packaging.mediator.GdpsPackagingContainerMediator;
	import com.editor.module_gdps.view.productManage.GdpsProductManagerContainer;
	import com.editor.module_gdps.view.productManage.mediator.GdpsProductManagerContainerMediator;
	import com.editor.module_gdps.view.publish.GdpsPublishContainer;
	import com.editor.module_gdps.view.publish.mediator.GdpsPublishContainerMediator;
	import com.editor.module_gdps.view.publishClient.GdpsPublishClientContainer;
	import com.editor.module_gdps.view.publishClient.mediator.GdpsPublishClientContainerMediator;
	import com.editor.module_gdps.view.publishRes.GdpsPublishResContainer;
	import com.editor.module_gdps.view.publishRes.mediator.GdpsPublishResContainerMeidator;
	import com.editor.module_gdps.view.publishServer.GdpsPublishServerContainer;
	import com.editor.module_gdps.view.publishServer.mediator.GdpsPublishServerContainerMediator;
	import com.editor.module_gdps.view.roleManage.GdpsRoleManagerContainer;
	import com.editor.module_gdps.view.roleManage.mediator.GdpsRoleManagerContainerMediator;
	import com.editor.module_gdps.view.serverManage.GdpsServerManagerContainer;
	import com.editor.module_gdps.view.serverManage.mediator.GdpsServerManagerContainerMediator;
	import com.editor.module_gdps.view.tableSpace.GdpsTableSpaceContaier;
	import com.editor.module_gdps.view.tableSpace.mediator.GdpsTableSpaceContainerMediator;
	import com.editor.module_gdps.view.userManage.GdpsUserManagerContainer;
	import com.editor.module_gdps.view.userManage.mediator.GdpsUserManagerContainerMediator;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.module_gdps.vo.module.AppModuleConfBase;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.module_gdps.vo.module.IAppModuleConfBase;
	import com.editor.module_gdps.vo.tree.AppLeftTreeItemVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class GdpsRightContainerMediator extends AppMediator
	{
		public static const NAME:String = "GdpsRightContainerMediator";
		
		public function GdpsRightContainerMediator(view:Object = null)
		{
			super(NAME, view);
		}
		public function get rightCell():GdpsRightContainer
		{
			return viewComponent as GdpsRightContainer;
		}
		public function get tabNav():UITabBarNav
		{
			return rightCell.tabNav;
		}
		public function get loadingProgressBar():GdpsLoadingProgressBar
		{
			return rightCell.loadingProgressBar;
		}
		public function get backCell():UICanvas
		{
			return rightCell.backCell;
		}
		public function get msgProgressBar():GdpsMsgProgressBar
		{
			return rightCell.msgProgressBar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			rightCell.visible = true;
			backCell.visible = true;
			
			tabNav.addEventListener(ASEvent.CHILDREMOVE , tabBarRemoveHandle);
		}
		
		public function showContentView(conf:AppModuleConfBase):void
		{
			trace(conf.swfPath);
			var swf:String = conf.swfPath;
			var treeVO:AppLeftTreeItemVO = treeProxy.getItemByMenuId(conf.menuId);
			if(treeVO == null)
			{
				showError("加载当前菜单项失败！");
				return;
			}
			
			var menuName:String = treeVO.name;
			var cell:ASComponent;
			switch(swf)
			{
				case GDPSDataManager.tableSpaceType:
					cell = new GdpsTableSpaceContaier();
					break;
				
				case GDPSDataManager.columnProfileStye:
					cell = new GdpsColumnProfileContainer();
					break;
				
				case GDPSDataManager.fileDataManagerType:
					cell = new GdpsFileDataManagerContainer();
					break;
				
				case GDPSDataManager.dataManagerType:
					cell = new GdpsDataManagerContainer();
					break;
				
				case GDPSDataManager.dataBaseFileType:
					cell = new GdpsDataBaseContainer();
					break;
				
				case GDPSDataManager.publishType:
					cell = new GdpsPublishContainer();
					break;
				
				case GDPSDataManager.packagingType:
					cell = new GdpsPackagingContainer();
					break;
				
				case GDPSDataManager.publishResType:
					cell = new GdpsPublishResContainer();
					break;
				
				case GDPSDataManager.publishClientType:
					cell = new GdpsPublishClientContainer();
					break;
				
				case GDPSDataManager.publishServerType:
					cell = new GdpsPublishServerContainer();
					break;
				
				case GDPSDataManager.userManagerType:
					cell = new GdpsUserManagerContainer();
					break;
				
				case GDPSDataManager.roleManagerType:
					cell = new GdpsRoleManagerContainer();
					break;
				
				case GDPSDataManager.serverManagerType:
					cell = new GdpsServerManagerContainer();
					break;
				
				case GDPSDataManager.productManagerType:
					cell = new GdpsProductManagerContainer();
					break;
				
				default:
					break;
			}
			
			addToTabNav(cell , conf, menuName);
		}
		
		private function addToTabNav(cell:ASComponent,conf:AppModuleConfBase , menuName:String):void
		{
			if(cell){
				backCell.visible = false;
				var haveOpen:Boolean;
				var n:int = tabNav.getTabLength();
				for(var i:int=0;i<n;i++){
					if(getDataByIndex(i)!=null&&getDataByIndex(i).menuId == conf.menuId){
						tabNav.selectedIndex = i;
						haveOpen = true;
						break;
					}
				}
				if(!haveOpen){
					cell.label = menuName;
					cell.data = conf;
					tabNav.addChild(cell);
					tabNav.setSelectByLabel(menuName,true,true);
					tabNav.getTabAt(tabNav.getTabLength()-1).toolTip = menuName;
					registModuleMediator(cell,conf);
				}
			}
		}
		
		private function registModuleMediator(cell:ASComponent,conf:AppModuleConfBase):void
		{
			switch(conf.swfPath)
			{
				case GDPSDataManager.tableSpaceType:
					registerMediator(new GdpsTableSpaceContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.columnProfileStye:
					registerMediator(new GdpsColumnProfileContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.fileDataManagerType:
					registerMediator(new GdpsFileDataManagerContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.dataManagerType:
					registerMediator(new GdpsDataManagerContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.dataBaseFileType:
					registerMediator(new GdpsDataBaseContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.publishType:
					registerMediator(new GdpsPublishContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.packagingType:
					registerMediator(new GdpsPackagingContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.publishResType:
					registerMediator(new GdpsPublishResContainerMeidator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.publishClientType:
					registerMediator(new GdpsPublishClientContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.publishServerType:
					registerMediator(new GdpsPublishServerContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.userManagerType:
					registerMediator(new GdpsUserManagerContainerMediator(cell,conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.roleManagerType:
					registerMediator(new GdpsRoleManagerContainerMediator(cell , conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.serverManagerType:
					registerMediator(new GdpsServerManagerContainerMediator(cell , conf as AppModuleConfItem));
					break;
				
				case GDPSDataManager.productManagerType:
					registerMediator(new GdpsProductManagerContainerMediator(cell , conf as AppModuleConfItem));
					break;
				
				default:
					break;
			}
		}
		
		private function tabBarRemoveHandle(e:ASEvent):void
		{
			if(tabNav.getTabLength() == 0){
				backCell.visible = true;
			}
			removeMediator(e.addData.mediator.getMediatorName());
		}
		
		/**
		 * 没进度条的遮罩
		 */
		public function respondToShowLoadingProgressBarGdpsEvent(noti:Notification):void
		{
			var str:String = noti.getBody() as String;
			
			loadingProgressBar.showBar();
			if(!str){
				loadingProgressBar.setProgressMsg("Loading start...");
			}else{
				loadingProgressBar.setProgressMsg(str);
			}
		}
		
		public function respondToHideLoadingProgressBarGdpsEvent(noti:Notification):void
		{
			loadingProgressBar.hideBar();
		}
		
		/**
		 * 有进度条的遮罩
		 */
		public function respondToShowMsgProgressBarGdpsEvent(noti:Notification):void
		{
			msgProgressBar.showPopwin();
		}
		
		public function respondToHideMsgProgressBarGdpsEvent(noti:Notification):void
		{
			msgProgressBar.hidePopwin();
		}
		
		private function parseMsg(info:String):void
		{
			msgProgressBar.appendProgressMsg(info);
			
			msgProgressBar.progressBtn.enabled = true;
		}
		
		public function respondToPublishClientMsg(noti:Notification):void
		{
			var gdpsXmlSocketData:GDPSXmlSocketData = noti.getBody() as GDPSXmlSocketData;
			parseMsg(String(gdpsXmlSocketData.getItem(4)));
			iLogger.info("服务端返回socket消息串: " + gdpsXmlSocketData.getString());
		}
		
		public function respondToPublishServerMsg(noti:Notification):void
		{
			respondToPublishClientMsg(noti);
		}
		
		public function respondToPublishResMsg(noti:Notification):void
		{
			respondToPublishClientMsg(noti);
		}
		
		public function respondToPublishTiyanMsg(noti:Notification):void
		{
			respondToPublishClientMsg(noti);
		}
		
		public function respondToPublishUatMsg(noti:Notification):void
		{
			respondToPublishClientMsg(noti);
		}
		
		public function respondToPublishConfigMsg(noti:Notification):void
		{
			respondToPublishClientMsg(noti);
		}
		
		public function respondToPackagingMsg(noti:Notification):void
		{
			respondToPublishClientMsg(noti);
		}
		
		public function respondToPublishAdddetailMsg(noti:Notification):void
		{
			respondToPublishClientMsg(noti);
		}
		
		public function respondToDetectMsg(noti:Notification):void
		{
			respondToPublishClientMsg(noti);
		}
		
		public function getViewByIndex(ind:int):ASComponent
		{
			return tabNav.getChildAt(ind) as ASComponent;
		}
		
		public function getDataByIndex(ind:int):IAppModuleConfBase
		{
			return getViewByIndex(ind).data as IAppModuleConfBase;
		}
		
		private function get treeProxy():GdpsTreeConfigProxy
		{
			return retrieveProxy(GdpsTreeConfigProxy.NAME) as GdpsTreeConfigProxy;
		}
	}
}