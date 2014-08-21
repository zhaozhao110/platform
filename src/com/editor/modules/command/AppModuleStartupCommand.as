package com.editor.modules.command
{
	import com.editor.modules.proxy.AppModuleProxy;
	import com.sandy.fabrication.SandySimpleFabricationCommand;
	import com.sandy.module.ModulePopupwinStartupCommand;
	import com.sandy.puremvc.interfaces.INotification;

	public class AppModuleStartupCommand extends ModulePopupwinStartupCommand
	{	
		
		override public function registerAllProxy(notification:INotification):void
		{
			registerProxy(new AppModuleProxy());
		}
		
	}
}