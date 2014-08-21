package com.editor.command.action
{
	import com.air.io.queue.download.DownloadQueue;
	import com.editor.command.AppSimpleCommand;
	import com.editor.proxy.AppPlusProxy;
	import com.editor.vo.plus.PlusItemVO;
	import com.sandy.puremvc.interfaces.INotification;

	public class CheckNeedDownloadPlusEventCommand extends AppSimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			var a:Array = get_AppPlusProxy().serverList.list;
			var out:Array = [];
			for(var i:int=0;i<a.length;i++){
				var d:PlusItemVO = PlusItemVO(a[i]);
				if(d.checkNewVersion() || d.oldItem == null){
					var obj:Object = {};
					obj.from = d.swf_url;
					obj.to = d.locale_url;
					out.push(obj);
				}
			}
			if(out.length > 0){
				/*downQ.queueFinish_f = downComplete;
				downQ.downOneComplete_f = downOneComplete;
				downQ.downError_f = downError;*/
				downQ.start(out);
			}
		}
		
		private var downQ:DownloadQueue = new DownloadQueue();
		
		private function get_AppPlusProxy():AppPlusProxy
		{
			return retrieveProxy(AppPlusProxy.NAME) as AppPlusProxy
		}
	}
}