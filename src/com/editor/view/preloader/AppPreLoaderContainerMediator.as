package com.editor.view.preloader
{
	import com.air.render2D.SandyAirApplication;
	import com.air.sql.ConnLocalSqlManager;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.component.expand.UIComboBoxWithLabel;
	import com.editor.event.AppEvent;
	import com.editor.manager.LogManager;
	import com.editor.manager.RPGSocketManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.global.AppMenuConfig;
	import com.editor.vo.project.AppProjectItemVO;
	import com.editor.vo.user.UserInfoVO;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.controls.text.SandyTextField;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.data.SQLResult;
	import flash.desktop.NativeApplication;
	import flash.events.MouseEvent;

	public class AppPreLoaderContainerMediator extends AppMediator
	{
		public static const NAME:String = "AppPreLoaderContainerMediator"
		public function AppPreLoaderContainerMediator(viewComponent:*=null)
		{
			super(NAME,viewComponent);
		}
		public function get preLoader():AppPreLoaderContainer
		{
			return viewComponent as AppPreLoaderContainer;
		}
		public function get txt():SandyTextField
		{
			return preLoader.txt;
		}
		public function get nameTI():UITextInput
		{
			return preLoader.nameTI;
		}
		public function get passTI():UITextInput
		{
			return preLoader.passTI;
		}
		public function get projectCB():UICombobox
		{
			return preLoader.projectCB;
		}
		public function get loginBtn():UIButton
		{
			return preLoader.loginBtn;
		}
		public function get quitBtn():UIButton
		{
			return preLoader.quitBtn;
		}
		public function get minBtn():UIButton
		{
			return preLoader.minBtn;
		}
		public function get enter3DBtn():UICheckBox
		{
			return preLoader.enter3DBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		
			nameTI.text = iSharedObject.find("","loginName");
		//	nameTI.enterKeyDown_proxy = onKeyDown;
			projectCB.addEventListener(ASEvent.CHANGE,onProjectChange)
			enter3DBtn.addEventListener(ASEvent.CHANGE,enter3DChange);
		}
		
		public function respondToAddPreLoaderMsgEvent(noti:Notification):void
		{
			LogManager.getInstance().addLog(String(noti.getBody()))
			txt.htmlText += String(noti.getBody())+"<br>"
			txt.scrollV = txt.maxScrollV;
		}
		
		public function respondToAppCreateCompleteEvent(noti:Notification):void
		{
			var enterGDPS:Boolean = iManager.iSharedObject.find("","enterGDPS") == "1"?true:false;
			if(enterGDPS){
				preLoader.visible =false;
				reactToMinBtnClick();
				return ;
			}
			
			showGameEditor()
		}
		
		private function showGameEditor():void
		{
			engineEditor.instance.getNativeWindow().width = 657;
			engineEditor.instance.getNativeWindow().height = 199
			engineEditor.instance.getNativeWindow().toCenter();
				
			preLoader.mouseChildren = true;
			preLoader.visible = true
			projectCB.labelField = "label"
			projectCB.dataProvider = AppGlobalConfig.instance.projects.list;
			projectCB.selectedIndex = int(iSharedObject.find("","loginProject"))
			
			enter3DBtn.selected = int(iSharedObject.find("","enter3D"))==1?true:false;
			
			loginBtn.visible = true;
			quitBtn.visible = true
			minBtn.visible = true;
			
			engineEditor.instance.getNativeWindow().activateTopContainer();
		}
		
		private function onProjectChange(e:ASEvent):void
		{
			trace(projectCB.selectedIndex);
		}
		
		private function onKeyDown():void
		{
			reactToLoginBtnClick();
		}
		
		public function reactToLoginBtnClick(e:MouseEvent=null):Boolean
		{
			/*projectCB.selectedIndex = -1;
			return false*/
			
			if(StringTWLUtil.isWhitespace(nameTI.text)){
				sendAppNotification(AppEvent.add_preLoader_msg_event,"帐号出错");
				return false;
			}
			
			var user:UserInfoVO = AppGlobalConfig.instance.user_vo.getUser(nameTI.text);
			if(user == null){
				sendAppNotification(AppEvent.add_preLoader_msg_event,"帐号不存在");
				return false;
			}
			
			_login()
			return true;
		}
		
		private function _login():void
		{
			var user:UserInfoVO = AppGlobalConfig.instance.user_vo.getUser(nameTI.text);
			iSharedObject.put("","loginProject",projectCB.selectedIndex);
			iSharedObject.put("","loginName",nameTI.text);
			AppMainModel.getInstance().user = user;
			AppMainModel.getInstance().selectProject = projectCB.selectedItem as AppProjectItemVO;
			AppMainModel.getInstance().enterGDPS = false;
			//过滤权限
			AppMenuConfig.instance.filterPower();
			
			if(AppMainModel.getInstance().user.checkInPower([1,2])){
				//解析项目
				loginBtn.visible = false;
				quitBtn.visible = false
				minBtn.visible = false;
				
				sendAppNotification(AppEvent.app_startLoad_event,"loginSystem");
				return ;
			}
						
			applogin();
		}
		
		public static function applogin():void
		{
			//显示主界面
			SandyEngineGlobal.iManager.sendAppNotification(AppEvent.login_event);
			RPGSocketManager.getInstance().connect();
			//ProjectCache.getInstance().reflash();
		}
		
		public function reactToQuitBtnClick(e:MouseEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		//gdps
		public function reactToMinBtnClick(e:MouseEvent=null):void
		{
			if(GDPSDataManager.getInstance().getUserInfo != null){
				sendAppNotification(AppEvent.sendGotoGDPS_event);
				return ;
			}
			
			var user:UserInfoVO = new UserInfoVO();
			user.name = "gdps"
			user.power = [3];
			AppMainModel.getInstance().user = user;
			//AppMainModel.getInstance().selectProject = projectCB.selectedItem as AppProjectItemVO;
			
			AppMainModel.getInstance().enterGDPS = true
			preLoader.visible = false;
			engineEditor.gdpsLogin.visible = true;
			
			engineEditor.instance.getNativeWindow().activateTopContainer();
		}
		
		private function enter3DChange(e:ASEvent):void
		{
			iSharedObject.put("","enter3D",enter3DBtn.selected==true?1:0);
			AppMainModel.getInstance().enter3DScene = enter3DBtn.selected;
		}
		
		public function respondToSendGotoGameEditorEvent(noti:Notification):void
		{
			if(AppMainModel.getInstance().selectProject == null){	
				showGameEditor()
			}
		}
		
		public function respondToSendGotoGDPSEvent(noti:Notification):void
		{
			if(GDPSDataManager.getInstance().getUserInfo == null){
				preLoader.visible =false;
				reactToMinBtnClick();
			}
		}
		
		
	}
}