package com.editor.command.moduleAction
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.command.BackgroundThreadCommand;
	import com.sandy.puremvc.interfaces.INotification;

	public class ParserApiCodeCodeEventCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var a:Array = notification.getBody() as Array;
			BackgroundThreadCommand.instance.colorAS(a[0],a[1]);
		}
	}
}