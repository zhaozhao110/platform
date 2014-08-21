package com.editor.command.action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.manager.RPGSocketManager;
	import com.editor.model.AppMainModel;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectListMediator;
	import com.editor.modules.app.mediator.AppMainPopupwinMediator;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.global.AppMenuConfig;
	import com.editor.vo.user.UserInfoVO;
	import com.sandy.puremvc.interfaces.INotification;

	public class ChangeUserCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var user:String = String( notification.getBody());
			var userd:UserInfoVO = AppGlobalConfig.instance.user_vo.getUser(user);
			if(userd == null) return ;
			//
			AppMainModel.getInstance().user = userd;
			//重新连接服务器
			RPGSocketManager.getInstance().closeConn();
			RPGSocketManager.getInstance().connect();
			//
			ProjectCache.getInstance().changeUser();
			//窗口的标题栏
			get_AppMainPopupwinMediator().respondToLoginEvent();
			//项目文件列表的下拉菜单
			get_ProjectDirectListMediator().setProject();
		}
		
		private function get_AppMainPopupwinMediator():AppMainPopupwinMediator
		{
			return retrieveMediator(AppMainPopupwinMediator.NAME) as AppMainPopupwinMediator;
		}
		
		private function get_ProjectDirectListMediator():ProjectDirectListMediator
		{
			return retrieveMediator(ProjectDirectListMediator.NAME) as ProjectDirectListMediator;
		}
	}
}