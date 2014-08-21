package com.editor.command.interceptor
{
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;

	public class OpenFileInUIEditorEventInterceptor extends AppAbstractInterceptor
	{
		public function OpenFileInUIEditorEventInterceptor()
		{
			super();
		}
		
		override public function intercept():void 
		{			
			super.intercept();
			
			StackManager.getInstance().changeStack(DataManager.stack_ui)
			
			proceed();
		}
	}
}