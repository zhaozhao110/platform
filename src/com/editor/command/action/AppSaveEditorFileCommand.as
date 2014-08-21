package com.editor.command.action
{
	import com.editor.command.AppSimpleCommand;
	import com.sandy.puremvc.interfaces.INotification;
	
	import flash.filesystem.File;

	public class AppSaveEditorFileCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var fl:File = File.applicationStorageDirectory;
			trace(fl.nativePath)
		}
	}
}