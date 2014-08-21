package com.editor.module_gdps.services
{
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.net.AS3HTTPServiceLocator;
	import com.sandy.net.json.SandyJSON;
	
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.utils.getTimer;
	import flash.xml.XMLNode;
	
	public class GdpsHttpServiceLocator extends AS3HTTPServiceLocator
	{
		public function GdpsHttpServiceLocator(stageDisable:Boolean=false):void
		{
			super();
			
		}
		
		private var _args2:Object;
		public function get args2():Object
		{
			return _args2;
		}
		public function set args2(value:Object):void
		{
			_args2 = value;
			for(var t:String in value){
				if(args == null){
					args = new URLVariables();
				}
				args[t] = value[t];
			}
		}

		
		override public function conn(urlStr:String , __method:String = "POST", __resultFor:String = "object"):void
		{ 
			createArgs();
			if(__resultFor == "object"){
				urlStr += "&srt=2";
			}
			super.conn(urlStr,__method,__resultFor);
			fault_f = callFault_f
		}
		
		private function createArgs():void
		{
			if(args == null){
				args = new URLVariables();
			}
			
			if(_resultFor == GDPSDataManager.resultFor_xml_type)
			{
				args.srt = 1;
			}
			else if(_resultFor == GDPSDataManager.resultFor_obj_type)
			{
				args.srt = 2;
			}
			
			//增加请求通用参数-当前项目id
			args.projectId = CacheDataUtil.getProjectId();
			
			//增加请求通用参数-当前session id
			args.jsessionid = CacheDataUtil.getSessionId();
			
			args.nocache = getTimer();
		}
		
		override protected function urlLoaderCompleteHandler(e:Event):void
		{
//			trace(getData());
			if(_resultFor == GDPSDataManager.resultFor_xml_type)
			{
				    
				var xml_val:XML = XML(getData());
				
				if(int(xml_val.@code)>0){
					iManager.iPopupwin.showError(XML(xml_val.msg[0]),false);
					return ;
				}
				//childNodes[1]).childNodes[0]).childNodes
				if(xml_val.children()[1] == null || xml_val.children()[1].children()[0] == null){
					sucResult_f(xml_val);
					return;
				}
				sucResult_f(xml_val.children()[1].children()[0].children());
			
			}
			else if(_resultFor == GDPSDataManager.resultFor_obj_type)
			{
				if(getData() == ""){
					iManager.iPopupwin.showError("请求出错",true);
					return 
				} 
				
				var value:* = SandyJSON.decode( String(getData()) )
				if(int(value.code)>0){
					iManager.iPopupwin.showError(value.msg,true);
					reLogin(value);
					return 
				}
				sucResult_f(value.obj);
				
			}
		}
		
		/**
		 * 针对特定的错误消息，重新登陆
		 * 
		 */
		private function reLogin(value:Object):void
		{
			if(value != null && value.hasOwnProperty("obj") && value.obj != null)
			{
				var obj:Object = value.obj;
				if(obj.hasOwnProperty("relogin") && obj.relogin != null && obj.relogin == true)
				{
					trace("relogin===============");
					/*var dat:GdpsPopupDataProxy = new GdpsPopupDataProxy();
					dat.popupwinSign = PopupwinSign.ReloginPopupwin_sign;
					sendNotification(PopupwinExtEvent.OPEN_POPUPWIN_EVENT , dat)*/
				}
			}
		}
		
		private function callFault_f():void
		{
			iManager.iPopupwin.showError("error")
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
	}
}