package com.editor.command.action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.model.AppMainModel;
	import com.editor.modules.cache.ProjectCache;
	import com.sandy.puremvc.interfaces.INotification;

	public class CloseProjectCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			ProjectCache.getInstance().currEditProjectFile = null;
			AppMainModel.getInstance().applicationStorageFile.putKey_project("");
			AppMainModel.getInstance().applicationStorageFile.putKey_projectFold("");
			
		}
		
	}
}