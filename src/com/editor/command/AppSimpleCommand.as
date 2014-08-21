package com.editor.command
{
	
	import com.editor.event.AppEvent;
	import com.editor.manager.LogManager;
	import com.sandy.fabrication.SandySimpleFabricationCommand;
	import com.sandy.puremvc.interfaces.INotification;
	
	public class AppSimpleCommand extends SandySimpleFabricationCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
		}
		
		protected function addLog(s:String):void
		{
			LogManager.getInstance().addLog(s);
		}
		
	}
}