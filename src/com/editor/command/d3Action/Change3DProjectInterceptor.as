package com.editor.command.d3Action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.command.interceptor.AppAbstractInterceptor;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.model.AppMainModel;
	import com.sandy.puremvc.interfaces.INotification;
	
	import flash.filesystem.File;

	public class Change3DProjectInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			
			var f:File = notification.getBody() as File;
			Stack3DManager.getInstance().changeStack(D3ComponentConst.stack3d_scene);
			
			if(notification.getBody() == null){
				clearCache()
				proceed();
				return ;
			}
						
			if(D3ProjectFilesCache.getInstance().projectFile!=null){
				if(D3ProjectFilesCache.getInstance().projectFile.nativePath == f.nativePath){
					D3ProjectCache.getInstance().afterParserProject();
					proceed();
					return ;
				}else{
					AppMainModel.getInstance().applicationStorageFile.putKey_3dprojectFold("");
				}
			}else{
				
			}
			
			//clear all data
			clearCache();
						
			//parser 3d project
			//thread parser
			AppMainModel.getInstance().applicationStorageFile.putKey_3dproject(f.nativePath);
			AppMainModel.getInstance().applicationStorageFile.putKey_recent3DProject(f.nativePath);
			D3ProjectCache.getInstance().readConfig();
			
			skip();
		}
		
		private function clearCache():void
		{
			if(D3SceneManager.getInstance().currScene){
				if(D3SceneManager.getInstance().currScene.sceneContianer){
					D3SceneManager.getInstance().currScene.sceneContianer.removeAllItems();
				}
			}
			D3SceneManager.getInstance().displayList.dispose();
			D3ResChangeProxy.getInstance().dispose();
			D3ProjectFilesCache.getInstance().dispose();
			
			AppMainModel.getInstance().applicationStorageFile.putKey_3dproject("");
		}
		
	}
}