package com.editor.module_server.mediator
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextArea;
	import com.editor.manager.RPGSocketManager;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.model.ServerInterfaceConst;
	import com.editor.module_server.manager.ServerListMenu;
	import com.editor.module_server.view.ServerMod_broadcast;
	import com.editor.popup.input.InputTextPopwinVO;
	import com.editor.vo.dict.DictItemVO;
	import com.editor.vo.dict.DictListVO;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.user.UserInfoVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;
	
	public class ServerModBroadcastMediator extends AppMediator
	{
		public static const NAME:String = "ServerModBroadcastMediator"
		public function ServerModBroadcastMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get broadcast():ServerMod_broadcast
		{
			return viewComponent as ServerMod_broadcast;
		}
		public function get vbox():UIVBox
		{
			return broadcast.vbox;
		}
		public function get tabBar():UITabBar
		{
			return broadcast.tabBar;
		}
		public function get clearBtn():UIButton
		{
			return broadcast.clearBtn;
		}
		public function get broadBtn():UIButton
		{
			return broadcast.broadBtn;
		}
		public function get broadBtn2():UIButton
		{
			return broadcast.broadBtn2;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			tabBar.labelField = "value";
			var a:Array = DictListVO.getGroup(3).list;
			var item:DictItemVO = new DictItemVO();
			item.value = "选中人员";
			item.key = -1;
			a.push(item);
			tabBar.dataProvider = a;
			tabBar.addEventListener(ASEvent.CHANGE,onTabBarChange);
			tabBar.selectedIndex = 0;
			
			vbox.addEventListener(ASEvent.CHANGE,_winRightClick)
			
			RPGSocketManager.getInstance().onlineChange_f = onTabBarChange;
		}
		
		private function _winRightClick(e:ASEvent):void
		{
			if(e.isRightClick){
				var user:UserInfoVO = vbox.getSelectItem() as UserInfoVO;
				ServerListMenu.getInstance().openRightMenu(user);
			}
		}
		
		
		public var selectedKey:int;
		
		private function onTabBarChange(e:ASEvent=null):void
		{
			if(tabBar.selectedItem == null) return;
			selectedKey = int((tabBar.selectedItem as DictItemVO).key);
			if(selectedKey == -1){
				vbox.dataProvider = RPGSocketManager.getInstance().selected_ls;
			}else{
				vbox.dataProvider = RPGSocketManager.getInstance().getOnlineList(selectedKey);
			}
		}
		
		public function reflashUserList():void
		{
			onTabBarChange();
		}
		
		public function reactToClearBtnClick(e:MouseEvent):void
		{
			RPGSocketManager.getInstance().clearSelectedList();
			reflashUserList();
		}
		
		public function reactToBroadBtnClick(e:MouseEvent):void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.InputTextAreaPopwin_sign
			var d:InputTextPopwinVO = new InputTextPopwinVO();
			d.title = "发送广播文字"
			d.okButtonFun = sendBroadcast;
			open.data = d;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		private function sendBroadcast(msg:String):void
		{
			RPGSocketManager.getInstance().socket.broadcast(msg,ServerInterfaceConst.broad_msg);
		}
		
		public function reactToBroadBtn2Click(e:MouseEvent):void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.InputTextAreaPopwin_sign
			var d:InputTextPopwinVO = new InputTextPopwinVO();
			d.title = "发送广播文字"
			d.okButtonFun = sendBroadcast2;
			open.data = d;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			openPopupwin(open);
		}
		
		private function sendBroadcast2(msg:String):void
		{
			var b:Array = [];
			var a:Array = RPGSocketManager.getInstance().selected_ls;
			for(var i:int=0;i<a.length;i++){
				b.push(UserInfoVO(a[i]).user_addres);
			}
			RPGSocketManager.getInstance().socket.broadcastClient(b,msg,ServerInterfaceConst.broad_msg);
		}
		
	}
}