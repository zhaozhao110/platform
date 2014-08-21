package com.editor.command.d3Action
{
	import com.editor.command.interceptor.AppAbstractInterceptor;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.cache.D3ComponentConst;

	public class EditParticleEventInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			Stack3DManager.getInstance().changeStack(D3ComponentConst.stack3d_particle);
			
			proceed();
		}
	}
}