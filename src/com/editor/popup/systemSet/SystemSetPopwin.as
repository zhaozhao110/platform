package com.editor.popup.systemSet
{
	
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class SystemSetPopwin extends AppPopupWithEmptyWin
	{
		public function SystemSetPopwin()
		{
			super()
			create_init();
		}
		
		public var tabNav:UITabBarNav;
		public var tab1:SystemSetPopwinTab1;
		public var tab2:SystemSetPopwinTab2;
		public var tab3:SystemSetPopwinTab3;
		public var tab4:SystemSetPopwinTab4;
		public var tab5:SystemSetPopwinTab5;
		
		private function create_init():void
		{
			tabNav = new UITabBarNav();
			tabNav.y = 10;
			tabNav.x = 10;
			tabNav.width = 570;
			tabNav.height = 550;
			this.addChild(tabNav);
			tabNav.creationPolicy = ASComponentConst.creationPolicy_none;
			
			tab1 = new SystemSetPopwinTab1();
			tab1.label = "系统设置"
			tab1.enabledPercentSize = true;
			tabNav.addChild(tab1);
			
			tab2 = new SystemSetPopwinTab2();
			tab2.label = "项目设置"
			tab2.enabledPercentSize = true;
			tabNav.addChild(tab2);
			
			tab3 = new SystemSetPopwinTab3();
			tab3.label = "代码编辑器"
			tab3.enabledPercentSize = true;
			tabNav.addChild(tab3);
			
			if(AppMainModel.getInstance().user.checkIsSystem()){
				tab4 = new SystemSetPopwinTab4();
				tab4.label = "版本控制"
				tab4.enabledPercentSize = true;
				tabNav.addChild(tab4);
			}
			
			tab5 = new SystemSetPopwinTab5();
			tab5.label = "插件管理"
			tab5.enabledPercentSize = true;
			tabNav.addChild(tab5);
			
			initComplete();
			tabNav.selectedIndex = 0;
		}
		
		override protected function okButtonClick():void
		{
			tab1.okButtonClick();
			tab2.okButtonClick();
			tab3.okButtonClick();
			if(tab4!=null) tab4.okButtonClick();
			
			sendAppNotification(AppEvent.systemSetPopWin_close_event);
			
			closeWin();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY
			opts.width = 600;
			opts.height = 650;
			opts.title = "系统设置"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true;
			popupSign  		= PopupwinSign.SystemSetPopwin_sign
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new SystemSetPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			tab4.delPopwin();
			super.delPopwin()
			removeMediator(SystemSetPopwinMediator.NAME);
		}
		
		
	}
}