package com.editor.command.d3Action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.command.interceptor.AppAbstractInterceptor;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.event.App3DEvent;
	import com.editor.model.AppMainModel;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.manager.StageManager;
	import com.sandy.puremvc.interfaces.INotification;

	public class ChangeTo3DSceneInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			
			if(!AppMainModel.getInstance().d3SceneInited){
				
				D3ComponentConst.init();
				D3ComponentProxy.getInstance().load();
				
				AppMainModel.getInstance().d3SceneInited = true
				sendAppNotification(App3DEvent.d3SceneInit_event);

			}
			
			SandyEngineGlobal.config.appFrame = 60
			StageManager.setSystemFrame(null,SandyEngineGlobal.config.appFrame);
			
			AppMainModel.getInstance().isIn3DScene = true;
			
			proceed();	
			
			AppMainModel.getInstance().d3SceneCreated = true;
		}
	}
}