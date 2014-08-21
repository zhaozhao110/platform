package com.editor.command.action
{
	import com.editor.command.AppSimpleCommand;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.tool.ParserLocaleTool;
	import com.sandy.puremvc.interfaces.INotification;
	
	import flash.filesystem.File;

	public class PaserProjectLocaleCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var tool:ParserLocaleTool = new ParserLocaleTool();
			tool.parser()
			ProjectCache.getInstance().addLocales(tool.map);
		}
		
		
	}
}