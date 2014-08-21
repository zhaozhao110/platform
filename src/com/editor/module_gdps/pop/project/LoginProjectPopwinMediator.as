package com.editor.module_gdps.pop.project
{
	import com.editor.component.containers.UITile;
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.vo.user.GDPSUserInfoVO;
	import com.editor.view.preloader.AppPreLoaderContainerMediator;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class LoginProjectPopwinMediator extends AppMediator
	{
		public static const NAME:String = 'LoginProjectPopwinMediator';
		
		public function LoginProjectPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get popWin():LoginProjectPopwin
		{
			return viewComponent as LoginProjectPopwin;
		}
		public function get projectList():UITile
		{
			return popWin.project_list;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function respondToShowGDPSProjectsEvent(noti:Notification):void
		{
			popWin.visible = true;
			initView();
		}
		
		private function initView():void
		{
			projectList.dataProvider = null;
			
			var projects:Array = GDPSDataManager.getInstance().getProjects;
			if(projects.length > 0)
			{
				var out:Array = [];
				for(var i:int=0; i<projects.length; i++)
				{
					if(int(projects[i].areaId) == GDPSDataManager.systemManagerType)//系统管理平台
					{
						out.unshift(projects[i]);
					}
					else
					{
						out.push(projects[i]);
					}
				}
				
				projectList.dataProvider = out;
			}
		}
		
		public function clickHandler(event:MouseEvent):void
		{
			iLogger.debug('Project ' + String(event.target.id) + ' pressed[username:' + CacheDataUtil.getUserInfo().getUsername+ ']');
			var getUserInfo:GDPSUserInfoVO = GDPSDataManager.getInstance().getUserInfo;
			var proid:int = int(event.target.data.projectId);
			var proname:String = String(event.target.data.projectName);
			var protype:String = String(event.target.data.projectType);
			getUserInfo.setProjectId = proid;
			getUserInfo.setProjectName = proname;
			getUserInfo.setProjectType = protype;
			GDPSDataManager.getInstance().setUserInfo = getUserInfo;
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "projectId": proid };
			http.sucResult_f = successCallback;
			http.conn(GDPSServices.getLoginProject_url);
		}
		
		private function successCallback(a:*):void
		{
			AppPreLoaderContainerMediator.applogin();
			var uv:GDPSUserInfoVO = CacheDataUtil.getUserInfo();
			iLogger.debug(uv.getUsername + ' ===>> 登陆产品主页 --- ' + uv.getProjectName);
			popWin.visible = false;
			sendNotification(GDPSAppEvent.enterGDPSMainUI_event);
			
		}
		
		public function respondToEnterGDPSMainUIEvent(noti:Notification):void
		{
			popWin.visible = false;
		}
	}
}