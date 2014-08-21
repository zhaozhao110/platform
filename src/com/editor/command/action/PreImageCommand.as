package com.editor.command.action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.puremvc.interfaces.INotification;

	public class PreImageCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var open:OpenPopwinData = new OpenPopwinData();
			open.data = notification.getBody();
			open.popupwinSign = PopupwinSign.PreImagePopWin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		
	}
}