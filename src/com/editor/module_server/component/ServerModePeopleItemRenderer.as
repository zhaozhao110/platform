package com.editor.module_server.component
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.manager.RPGSocketManager;
	import com.editor.module_server.mediator.ServerModBroadcastMediator;
	import com.editor.vo.user.UserInfoVO;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	
	import flash.events.MouseEvent;

	public class ServerModePeopleItemRenderer extends ASHListItemRenderer
	{
		public function ServerModePeopleItemRenderer()
		{
			super();
		}
		
		public var user:UserInfoVO;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			mouseEnabled = true;
			mouseChildren = true
			createUI();
			
			user = data as UserInfoVO;
			txt.text = user.getInfo();
			txt.toolTip = user.user_addres+"<br>"+user.getInfo();
			
			if(get_ServerModBroadcastMediator().selectedKey == -1){
				cb.source = "close2_a"
				cb.toolTip = "删除"
			}else{
				cb.source = "add_a"
				cb.toolTip = "添加"
			}
		}
		
		override protected function renderTextField():void{};
		
		private var txt:UILabel;
		private var cb:UIAssetsSymbol;
		
		override public function poolDispose():void
		{
			super.poolDispose();
			
		}
		
		private function createUI():void
		{
			if(cb != null) return;
						
			txt = new UILabel();
			txt.width = 300;
			addChild(txt);
			
			cb = new UIAssetsSymbol();
			cb.toolTip = "添加"
			cb.source = "add_a";
			cb.buttonMode = true;
			cb.addEventListener(MouseEvent.CLICK,add);
			addChild(cb);
		}
		
		private function add(e:MouseEvent):void
		{
			if(get_ServerModBroadcastMediator().selectedKey == -1){
				RPGSocketManager.getInstance().removeSelectUser(user);
			}else{
				RPGSocketManager.getInstance().addSelectUser(user);
			}
		}
		
		private function get_ServerModBroadcastMediator():ServerModBroadcastMediator
		{
			return iManager.retrieveMediator(ServerModBroadcastMediator.NAME) as ServerModBroadcastMediator;
		}
	}
}