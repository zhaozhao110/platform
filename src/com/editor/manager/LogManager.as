package com.editor.manager
{
	import com.editor.event.AppEvent;
	import com.editor.modules.app.view.ui.bottom.AppBottomContainerMediator;
	import com.sandy.manager.SandyManagerBase;

	public class LogManager extends SandyManagerBase
	{
		private static var instance:LogManager ;
		public static function getInstance():LogManager{
			if(instance == null){
				instance =  new LogManager();
			}
			return instance;
		}
		
		public var log_ls:Array = [];
		
		public function addLog(s:String):void
		{
			iManager.iLogger.info(s);
		}
		
		public function addBottomBarLog(s:String):void
		{
			if(get_AppBottomContainerMediator() == null) return ;
			get_AppBottomContainerMediator().addLog2(s);
		}
		
		private function get_AppBottomContainerMediator():AppBottomContainerMediator
		{
			return iManager.retrieveMediator(AppBottomContainerMediator.NAME) as AppBottomContainerMediator;
		}
	}
}