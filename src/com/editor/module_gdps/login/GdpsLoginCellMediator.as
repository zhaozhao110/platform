package com.editor.module_gdps.login
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.module_gdps.vo.login.LoginServerAddressConst;
	import com.editor.module_gdps.vo.user.GDPSUserInfoVO;
	import com.editor.view.preloader.AppPreLoaderContainerMediator;
	import com.sandy.manager.timer.ISandyTimer;
	import com.sandy.manager.timer.TimerManager;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;

	public class GdpsLoginCellMediator extends AppMediator
	{
		public static const NAME:String = "GdpsLoginCellMediator";
		
		public function GdpsLoginCellMediator(viewComponent:*=null)
		{
			super(NAME,viewComponent);
		}
		public function get content():GdpsLoginCell
		{
			return viewComponent as GdpsLoginCell;
		}
		public function get addressCBox():UICombobox
		{
			return content.addressCBox;
		}
		public function get rememberUserNameCbox():UICheckBox
		{
			return content.rememberUserNameCbox;
		}
		public function get rememberPasswordCbox():UICheckBox
		{
			return content.rememberPasswordCbox;
		}
		public function get loginBtn():UIButton
		{
			return content.loginBtn;
		}
		public function get exitBtn():UIButton
		{
			return content.exitBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
				
			var getLocal:SharedObject = SharedObject.getLocal("gdps_cn_cn_user_data", "/");
			var localData:Object = getLocal.data;
			if (localData != null && localData.nameRemember == true && localData.username != null)
			{
				content.username.text = localData.username;
				rememberUserNameCbox.selected = true;
			}
			if (localData != null && localData.pwdRemember == true && localData.password != null)
			{
				content.password.text = localData.password;
				rememberPasswordCbox.selected = true;
			}
			
			rememberUserNameCbox.addEventListener(MouseEvent.CLICK, rememberUserNameCboxHandler);
			
			//初始化访问服务器地址
			LoginServerAddressConst.init();
			addressCBox.dataProvider = LoginServerAddressConst.address_ls;
			addressCBox.selectedIndex = 0;
		}
		
		protected function rememberUserNameCboxHandler(event:MouseEvent):void
		{
			if (!rememberUserNameCbox.selected)
			{
				rememberPasswordCbox.selected = rememberUserNameCbox.selected;
			}
		}
		
		public function reactToExitBtnClick(e:MouseEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		public function reactToLoginBtnClick(e:MouseEvent):void
		{
			var address:String = addressCBox.selectedItem as String;
			if (address == null)
			{
				showError("请选择需要登录的服务器地址", true);
				return;
			}
			var ip_port:String = address.split('|')[0];
			GDPSDataManager.getInstance().setServerAddress = ip_port;
			GDPSServices.init(ip_port);
			
			if (content.username.text == "" || content.password.text == "")
			{
				showError("请输入用户名或密码", true);
				return;
			}
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SLoginCode": content.username.text, "SPasswd": content.password.text };
			http.sucResult_f = successCallback;
			http.conn(GDPSServices.getLoginVerify_url, "POST");
		}
		
		private function successCallback(a:*):void
		{
			var dat:Object = a;
			var vo:GDPSUserInfoVO = new GDPSUserInfoVO(dat.uio);
			GDPSDataManager.getInstance().setUserInfo = vo;
			
			iXMLSocket.connSocket(GDPSServices.socketDomain, GDPSServices.SOCKET_PORT);
			iXMLSocket.connSuccessF = connectSuccessCallback;
			
			var getLocal:SharedObject = SharedObject.getLocal("gdps_cn_cn_user_data", "/");
			if (rememberUserNameCbox.selected)
			{
				getLocal.data.username = content.username.text;
				getLocal.data.nameRemember = true;
			}
			if (rememberPasswordCbox.selected)
			{
				getLocal.data.password = content.password.text;
				getLocal.data.pwdRemember = true;
			}
			if (!rememberUserNameCbox.selected && !rememberPasswordCbox.selected)
			{
				getLocal.clear();
			}
			getLocal.flush();
			
			var pros:Array = dat.projects;
			
			GDPSDataManager.getInstance().setProjects = pros;
			
			if(pros.length > 1)
			{
				showProjectPopwin(vo, dat.projects);
			}
			else
			{
				switchProject(pros[0]);
			}
		}
		
		protected function switchProject(pro:Object):void
		{
			var getUserInfo:GDPSUserInfoVO = GDPSDataManager.getInstance().getUserInfo;
			var proid:int = int(pro.areaId);
			getUserInfo.setProjectId = proid;
			getUserInfo.setProjectName = String(pro.areaName);
			getUserInfo.setProjectType = String(pro.areaType);
			GDPSDataManager.getInstance().setUserInfo = getUserInfo;
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "projectId": proid };
			http.sucResult_f = switchProjectCallback;
			http.conn(GDPSServices.getLoginProject_url, "POST");
		}
		
		private function switchProjectCallback(a:*):void
		{
			var uv:GDPSUserInfoVO = CacheDataUtil.getUserInfo();
			iLogger.debug(uv.getUsername + ' ===>> 自动转向产品主页 --- ' + uv.getProjectName);
			AppPreLoaderContainerMediator.applogin();
			sendNotification(GDPSAppEvent.enterGDPSMainUI_event);
			content.visible = false;
		}
		
		private function showProjectPopwin(vo:GDPSUserInfoVO, projects:Array):void
		{
			if(vo == null || projects.length == 0)
			{
				showError("非法用户或权限限制！");
				return;
			}
			content.visible = false;
			sendNotification(GDPSAppEvent.showGDPSProjects_event);
		}
		
		private function connectSuccessCallback():void
		{
			var timer:ISandyTimer = iTimer.createSandyTimer();
			timer.step = 60;
			timer.sign = "checkGdpsConnectTimer";
			timer.timer_fun = timerChange;
			iTimer.addTimer(timer);
			
			iLogger.debug("客户端xmlsocket连接服务器成功!!!");
			
			GDPSDataManager.getInstance().registerXMLSocket(GdpsXmlSocketConst.client_type_login);
			
			var sessionTime:ISandyTimer = iTimer.createSandyTimer();
			sessionTime.step = 600;
			sessionTime.sign = "checkHttpSessionTimer";
			sessionTime.timer_fun = sessionTimerChange;
			iTimer.addTimer(sessionTime);
		}
		
		/**
		 * 保持http session连接
		 */
		protected function sessionTimerChange(e:*):void
		{
//			iLogger.info("http session连接...");
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.sucResult_f = refSessionCallback;
			http.conn(GDPSServices.getRefSession_url, "POST");
		}
		
		private function refSessionCallback(a:*):void
		{
			iLogger.info("http session连接成功!");
		}
		
		/**
		 * socket连接 心跳--保证和后台连接不断开
		 */
		private function timerChange(e:*):void
		{
//			iLogger.info("测试连接心跳，服务端不处理!");
			var buf:GDPSXmlSocketData = GDPSDataManager.getInstance().getXMLSocketData(GdpsXmlSocketConst.timer_msg);
			buf.addItem(GdpsXmlSocketConst.timer_msg);
			GDPSDataManager.getInstance().sendXMLSocketData(buf);
		}
		
		public function respondToRegisterMsg(noti:Notification):void
		{
			var gdpsXmlSocketData:GDPSXmlSocketData = noti.getBody() as GDPSXmlSocketData;
			iLogger.info(gdpsXmlSocketData.getString());
			iLogger.info("客户端【类型:" + String(gdpsXmlSocketData.getItem(3)) + "】注册xmlsocket成功!");
		}
		
		public function respondToReceivedMsg(noti:Notification):void
		{
			var gdpsXmlSocketData:GDPSXmlSocketData = noti.getBody() as GDPSXmlSocketData;
			iLogger.info(gdpsXmlSocketData.getString());
			iLogger.info("客户端【类型:" + String(gdpsXmlSocketData.getItem(3)) + "】接收到服务器推送的消息!");
		}
	}
}