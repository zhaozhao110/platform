package com.editor.project_pop.projectLog
{
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.net.LocalConnectionManager;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class ProjectLogPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectLogPopwinMediator"
		public function ProjectLogPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():ProjectLogPopwin
		{
			return viewComponent as ProjectLogPopwin
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var cache:String = iSharedObject.find("","localNames");
			if(!StringTWLUtil.isWhitespace(cache)){
				win.cb.dataProvider = cache.split(",");
			}
			
			win.connBtn.addEventListener(MouseEvent.CLICK , conn)
			win.cb.addEventListener(ASEvent.CHANGE,onCBChange);
			win.atcb.addEventListener(ASEvent.CHANGE,onATCBChange);
			
			NativeApplication.nativeApplication.addEventListener(Event.EXITING , onExit);
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			onExit();
			clearInterval(time_u);
		}
		
		private function onExit(e:Event=null):void
		{
			if(sendConn != null){
				sendConn.closeConn();
			}
			sendConn = null;
			if(recConn!=null){
				recConn.closeConn();
			}
			recConn = null;
			clearInterval(time_u);
		}
		
		private var sendConn:LocalConnectionManager;
		private var recConn:LocalConnectionManager;
		
		private function conn(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(win.ti)) return ;
			onExit();
			
			if(recConn == null){
				recConn = new LocalConnectionManager("_"+win.ti.text+"_server",true);
				recConn.receiveMessHandleF = recMessHandle;
				recConn.suc_f = connSuc;
				recConn.fault_f = connFault;
			}
			recConn.initReceiveMode();
			
			if(sendConn == null){
				sendConn = new LocalConnectionManager("_"+win.ti.text+"_client",true);
				//sendConn.receiveMessHandleF = recMessHandle;
				/*sendConn.suc_f = connSuc;
				sendConn.fault_f = connFault;*/
			}
			sendConn.initSenderMode();
			
			var cache:String = iSharedObject.find("","localNames");
			if(!StringTWLUtil.isWhitespace(cache)){
				var a:Array = cache.split(",");
				if(a.indexOf(win.ti.text)==-1){
					cache += ","+win.ti.text;
				}
				iSharedObject.put("","localNames",cache);
			}else{
				cache = win.ti.text;
				iSharedObject.put("","localNames",cache);
			}
			win.cb.dataProvider = cache.split(",");
		}
		
		private function connSuc():void
		{
			win.tipTxt.text = "连接成功";
		}
		
		private function connFault():void
		{
			win.tipTxt.text = "连接失败";
		}
		
		private function onCBChange(e:ASEvent):void
		{
			win.ti.text = win.cb.selectedItem.toString();	
		}
		
		private function onATCBChange(e:ASEvent):void
		{
			clearInterval(time_u);
			if(win.atcb.selectedIndex == 1){
				win.logTxt.htmlText = log_s.join("<br>");
			}else if(win.atcb.selectedIndex == 6){
				win.logTxt.htmlText = load_s.join("<br>");
			}else{
				sendConn.sendMessage("s_getData"+sign+win.atcb.selectedIndex);
				start_getInfoTime()
			}
		}
		
		private function start_getInfoTime():void
		{
			clearInterval(time_u);
			time_u = setInterval(_getInfoTime,2000);
		}
		
		private function _getInfoTime():void
		{
			sendConn.sendMessage("s_getData"+sign+win.atcb.selectedIndex);
		}
		
		private var time_u:uint;
		private static const sign:String = "●";
		private var log_s:Array=[];
		private var load_s:Array = [];
		
		public function recMessHandle(msg:String):void
		{
			var a:Array = msg.split(sign);
			var type:String = a[0];
			if(type == "c_keepConn"){
				sendConn.sendMessage("s_keepConn"+sign+a[1]);
			}else if(type == "c_addLog"){
				log_s.push(a[1]);
				if(win.atcb.selectedIndex == 1){
					win.logTxt.htmlText = log_s.join("<br>");
					win.logTxt.vscrollToBottom();
				}
			}else if(type == "c_addLoad"){
				load_s.push(a[1]);
				if(win.atcb.selectedIndex == 6){
					win.logTxt.htmlText = load_s.join("<br>");
					win.logTxt.vscrollToBottom();
				}
			}else if(type == "c_getData"){
				win.logTxt.htmlText = a[1];
			}
			
		}
		
	}
		
}