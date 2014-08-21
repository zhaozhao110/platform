package com.editor.command.d3Action
{
	import com.editor.command.interceptor.AppAbstractInterceptor;
	import com.editor.d3.cache.D3ProjectCache;

	public class Change3DSceneInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			
			D3ProjectCache.getInstance().changeScene(String(notification.getBody()));
		}
	}
}