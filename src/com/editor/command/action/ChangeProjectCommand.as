package com.editor.command.action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.module_code.CodeEditorModuleMediator;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectViewMediator;
	import com.editor.modules.app.mediator.AppMainPopupwinMediator;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.sandy.puremvc.interfaces.INotification;
	
	import flash.filesystem.File;

	public class ChangeProjectCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var f:File = notification.getBody() as File;
			if(f == null) return ;
			if(!f.exists) return ;
			if(f.nativePath == AppMainModel.getInstance().applicationStorageFile.curr_project) return ;
			iLogger.info("changeProject:"+f.nativePath);
			//改变缓存
			AppMainModel.getInstance().applicationStorageFile.changeProject(f);
			
			//解析项目
			sendAppNotification(AppEvent.importProject_event,f);
			
			if(get_CodeEditorModuleMediator()!=null){
				get_CodeEditorModuleMediator().removeAllTab();
			}
			
			//窗口的标题栏
			get_AppMainPopupwinMediator().respondToLoginEvent();
			//
			ProjectAllUserCache.getInstance().loadExpndComp();
			
		}
		
		private function get_CodeEditorModuleMediator():CodeEditorModuleMediator
		{
			return retrieveMediator(CodeEditorModuleMediator.NAME) as CodeEditorModuleMediator
		}
		
		private function get_AppMainPopupwinMediator():AppMainPopupwinMediator
		{
			return retrieveMediator(AppMainPopupwinMediator.NAME) as AppMainPopupwinMediator;
		}
		
	}
}