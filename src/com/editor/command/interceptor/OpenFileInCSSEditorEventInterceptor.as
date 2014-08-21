package com.editor.command.interceptor
{
	import com.editor.manager.DataManager;
	import com.editor.manager.StackManager;

	public class OpenFileInCSSEditorEventInterceptor extends AppAbstractInterceptor
	{
		public function OpenFileInCSSEditorEventInterceptor()
		{
			super();
			
		}
		
		override public function intercept():void 
		{			
			super.intercept();
			
			StackManager.getInstance().changeStack(DataManager.stack_css)
				
			proceed();
		}
		
	}
}