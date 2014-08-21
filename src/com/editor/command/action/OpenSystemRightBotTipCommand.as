package com.editor.command.action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.module_server.pop.systemRightBotTip.SystemRightBotTip;
	import com.editor.module_server.pop.systemRightBotTip.SystemRightTipVO;
	import com.sandy.puremvc.interfaces.INotification;

	public class OpenSystemRightBotTipCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var item:SystemRightTipVO = notification.getBody() as SystemRightTipVO;
			var win:SystemRightBotTip = new SystemRightBotTip();
			win.setItem(item);
		}
	}
}