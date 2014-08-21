package com.editor.command.action
{
	import com.editor.command.interceptor.AppAbstractInterceptor;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.manager.StageManager;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class ChangeTo2DSceneInterceptor extends AppAbstractInterceptor
	{
		
		override public function intercept():void 
		{			
			super.intercept();
						
			SandyEngineGlobal.config.appFrame = 30
			StageManager.setSystemFrame(null,SandyEngineGlobal.config.appFrame);
			
			AppMainModel.getInstance().isIn3DScene = false;
			
			var url:String = AppMainModel.getInstance().applicationStorageFile.curr_project;
			if(!StringTWLUtil.isWhitespace(url)){
				var file:File = new File(url);
				if(file.exists){
					sendAppNotification(AppEvent.importProject_event,file);
				}
			}
			
			proceed();	
		}
	}
}