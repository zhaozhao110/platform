package com.editor.manager
{
	import com.air.event.AIREvent;
	import com.air.io.WriteFile;
	import com.air.logging.CatchErrorLog;
	import com.air.net.p2p.P2PConn;
	import com.air.server.SandySocketServer;
	import com.air.utils.AIRUtils;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.model.ServerInterfaceConst;
	import com.editor.module_server.pop.systemRightBotTip.SystemRightTipVO;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.user.UserInfoVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.net.interfac.ISandyByteArray;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.desktop.NativeApplication;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	public class RPGSocketManager extends SandyManagerBase
	{
		private static var instance:RPGSocketManager ;
		public static function getInstance():RPGSocketManager{
			if(instance == null){
				instance =  new RPGSocketManager();
			}
			return instance;
		}
		
		//服务器的socket
		public var socket:SandySocketServer;
		
		
		//客户端的连接
		public function connect():void
		{
			if(AppGlobalConfig.instance.socket_port == 0){
				connP2P()
				stopTimer();
				return ;
			}
			if(StringTWLUtil.isWhitespace(AppGlobalConfig.instance.socket_url)){
				connP2P()
				stopTimer();
				return ;
			}
			if(conected){
				stopTimer();
				return ;
			}
			if(AppMainModel.getInstance().user.checkIsSystem()){
				connP2P()
				stopTimer();
				return ;
			}
						
			iManager.iSocket.connCloseF = startRetry;
			iManager.iSocket.connFaultF = startRetry;
			iManager.iSocket.connSuccessF = connSuc;
			iManager.iSocket.socketData_proxy = receiveSocketData;
			iManager.iSocket.connSocket(AppGlobalConfig.instance.socket_url,AppGlobalConfig.instance.socket_port);
		}
		
		public function closeConn():void
		{
			iManager.iSocket.closeSocket();
		}
		
		private function receiveSocketData(b:ByteArray,msgHead:int):void
		{
			b.readShort();
			var len:int = b.readShort();
			var msg:String = b.readMultiByte(len,"UTF-8");
			if(msgHead == ServerInterfaceConst.broad_msg){
				var vo:SystemRightTipVO = new SystemRightTipVO();
				vo.info = msg;
				sendAppNotification(AppEvent.openSystemRightBotTip_event,vo);
			}
		}
		
		private function connSuc():void
		{
			closeP2P()
			
			iManager.iSocket.sendSimpleMsg(userOnline(),ServerInterfaceConst.broad_msg);
			LogManager.getInstance().addBottomBarLog("socket connected suc");
			keepConnect();
			
			var error_s:String = CatchErrorLog.getInstance().getLog();
			if(!StringTWLUtil.isWhitespace(error_s)){
				iManager.iSocket.sendSimpleMsg("upload_error|"+
					AppMainModel.getInstance().user.name+"|"+
					error_s,ServerInterfaceConst.upload_error_msg);
				CatchErrorLog.getInstance().clear();
			}
		}
		
		private function userOnline():String
		{
			return "userOnline|"+AppMainModel.getInstance().user.name+
				"|"+AIRUtils.getAPP_version()+
				"|"+NativeApplication.nativeApplication.runtimeVersion+
				"|"+Capabilities.os
		}
		
		public function get conected():Boolean
		{
			return iManager.iSocket.checkConnIsSuc();
		}
		
		private var timer:Timer;
		private function startRetry():void
		{
			connP2P();
			LogManager.getInstance().addBottomBarLog("");
			if(timer == null){
				timer = new Timer(1000*15);
				timer.addEventListener(TimerEvent.TIMER , onTimer);
			}
			timer.stop();
			timer.start();
		}
		
		private function stopTimer():void
		{
			if(timer!=null) timer.stop();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			connect();
		}
		
		private var timer2:Timer;
		private function keepConnect():void
		{
			if(timer2 == null){
				timer2 = new Timer(1000*10);
				timer2.addEventListener(TimerEvent.TIMER,onKeepConn)
			}
			timer2.stop();
			timer2.start();
		}
		private function onKeepConn(e:TimerEvent):void
		{
			iManager.iSocket.sendSimpleMsg("keepConnect|"+AppMainModel.getInstance().user.name,ServerInterfaceConst.keepConnect_msg);
		}
		
		
		
		
		////////////////// 服务器端的逻辑 ////////////////////////////
		public var onlineChange_f:Function;
		public var online_ls:Array = [];
		
		public function getOnlineList(group:int):Array
		{
			var a:Array = [];
			for(var i:int=0;i<online_ls.length;i++){
				var user:UserInfoVO = online_ls[i] as UserInfoVO;
				if(user!=null){
					if(user.checkInGroup(group)){
						a.push(user);
					}
				}
			}
			return a;
		}
		
		public function clearOnlineList():void
		{
			online_ls = null;online_ls = [];
		}
		
		public function removeOnline(id:String):void
		{
			for(var i:int=0;i<online_ls.length;i++){
				var user:UserInfoVO = online_ls[i] as UserInfoVO;
				if(user!=null){
					if(user.user_addres == id){
						online_ls.splice(i,1);
						break;
					}
				}
			}
		}
		
		public function addMsg(msg:String,address:String):void
		{
			var a:Array = msg.split("|");
			var sign:String = a[0];
			
			if(sign == "userOnline")
			{
				var userName:String = a[1];
				var user:UserInfoVO = AppGlobalConfig.instance.user_vo.getUser(userName);
				user.user_addres 	= address;
				user.app_version  	= a[2];
				user.air_version 	= a[3];
				user.os 			= a[4];
				online_ls.push(user);
				trace("userOnline",userName)
				if(onlineChange_f!=null) onlineChange_f();
			}
			else if(sign == "upload_error")
			{
				userName = a[1];
				var error_s:String = a[2];
				var file:File = new File(File.applicationStorageDirectory.nativePath+File.separator+"uerror"+File.separator+userName+"_error.txt");
				var write:WriteFile = new WriteFile();
				write.write(file,error_s);
			}
		}
		
		public var selected_ls:Array = [];
		public function addSelectUser(user:UserInfoVO):void
		{
			if(user == null) return ;
			if(selected_ls.indexOf(user)==-1){
				selected_ls.push(user);
			}
		}
		
		public function removeSelectUser(user:UserInfoVO):void
		{
			var ind:int = selected_ls.indexOf(user);
			if(ind>=0){
				selected_ls.splice(ind,1);
			}
		}
		
		public function clearSelectedList():void
		{
			selected_ls = null;
			selected_ls = [];
		}
		
		
		
		
		//////////////////////////////////////////// p2p ////////////////////////////////////////////
				
		public function connP2P():void
		{
			return 
			P2PConn.getInstance().addEventListener(AIREvent.CLIENT_SOCKETDATA,p2pConnData); 
			P2PConn.getInstance().addEventListener(AIREvent.CONNECT_EVENT,p2pConnSuc); 
			P2PConn.getInstance().conn();
		}
				
		public function closeP2P():void
		{return 
			P2PConn.getInstance().close();
		}
		
		private function p2pConnSuc(e:ASEvent):void
		{
			P2PConn.getInstance().send({msg:userOnline(),code:ServerInterfaceConst.broad_msg});
		}
		
		private function p2pConnData(e:ASEvent):void
		{
			var obj:Object = e.data;
			addMsg(obj.msg,obj.address);
		}
		
	}
}