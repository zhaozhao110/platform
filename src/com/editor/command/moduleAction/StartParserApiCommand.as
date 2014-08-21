package com.editor.command.moduleAction
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.command.BackgroundThreadCommand;
	import com.sandy.puremvc.interfaces.INotification;
	
	public class StartParserApiCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			BackgroundThreadCommand.instance.parserApi(notification.getBody() as Array);
		}
	}
}