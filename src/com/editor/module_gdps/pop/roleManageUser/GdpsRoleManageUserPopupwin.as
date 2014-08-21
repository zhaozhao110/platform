package com.editor.module_gdps.pop.roleManageUser
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILinkButton;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.NativeWindowType;

	public class GdpsRoleManageUserPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsRoleManageUserPopupwin()
		{
			super();
			create_init();
		}
		
		public var reflashBtn:UILinkButton;
		public var list:SandyDataGrid;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.enabledPercentSize = true;
			vbox.padding = 10;
			addChild(vbox);
			
			var hbox:UIHBox = new UIHBox();
			hbox.height = 25;
			hbox.percentWidth = 100;
			hbox.horizontalGap = 10;
			vbox.addChild(hbox);
			
			reflashBtn = new UILinkButton();
			reflashBtn.text = "刷新数据";
			reflashBtn.bold = true;
			reflashBtn.color = 0x0F76EB;
			hbox.addChild(reflashBtn);
			
			list = new SandyDataGrid();
			list.enabledPercentSize = true;
			list.rowHeight = 30;
			list.verticalScrollPolicy = "auto";
			list.horizontalScrollPolicy = "auto";
			list.styleName = GDPSDataManager.dataGridDefaultTheme;
			vbox.addChild(list);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 863;
			opts.height = 580;
			opts.title = "角色绑定用户列表";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsRoleManageUserPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsRoleManageUserPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsRoleManageUserPopupwinMediator.NAME);
		}
	}
}