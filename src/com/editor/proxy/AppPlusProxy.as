package com.editor.proxy
{
	import com.editor.event.AppEvent;
	import com.editor.services.Services;
	import com.editor.vo.plus.PlusItemVO;
	import com.editor.vo.plus.PlusListVO;
	import com.sandy.component.controls.SandyLoader;

	public class AppPlusProxy extends AppProxy
	{
		public static const NAME:String = "AppPlusProxy"
		
		public function AppPlusProxy()
		{
			super(NAME);
			if(instance!=null) return ;
			instance = this;
		}
		
		public static var instance:AppPlusProxy;
		
		public var list:PlusListVO;
		public var serverList:PlusListVO;
		
		public function load():void
		{
			list = new PlusListVO(getXML(Services.plus_fold_url + "plus.xml"));
			
			loadSeverXML();
		}
		
		private function loadSeverXML():void
		{
			var url:String = Services.server_res_url + "plus.xml?"+Math.random();
			var ld:SandyLoader = new SandyLoader();
			ld.complete_fun = loadSeverXMLComplete;
			ld.load(url);
		}
		
		private function loadSeverXMLComplete(x:*):void
		{
			serverList = new PlusListVO(XML(x));
			
			var a:Array = serverList.list;
			for(var i:int=0;i<a.length;i++){
				PlusItemVO(a[i]).oldItem = list.getItem(PlusItemVO(a[i]).name);
			}
			
			sendAppNotification(AppEvent.checkNeed_downloadPlus_event);
		}
		
		public function cloneServerXml():void
		{
			list = new PlusListVO(serverList.org_xml);
			
			var a:Array = serverList.list;
			for(var i:int=0;i<a.length;i++){
				PlusItemVO(a[i]).oldItem = list.getItem(PlusItemVO(a[i]).name);
			}
		}
		
	}
}