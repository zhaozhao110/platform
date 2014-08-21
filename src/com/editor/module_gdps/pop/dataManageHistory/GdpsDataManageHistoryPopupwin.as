package com.editor.module_gdps.pop.dataManageHistory
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILinkButton;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsDataManageHistoryPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsDataManageHistoryPopupwin()
		{
			super();
			create_init();
		}
		
		public var history_btn:UILinkButton;
		public var publish_btn:UILinkButton;
		public var hostoryList:GdpsModuleDataGrid;
		
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
			
			history_btn = new UILinkButton();
			history_btn.text = "当前编辑版数据》";
			history_btn.bold = true;
			hbox.addChild(history_btn);
			
			publish_btn = new UILinkButton();
			publish_btn.text = "公网版本数据》";
			publish_btn.bold = true;
			hbox.addChild(publish_btn);
			
			hostoryList = new GdpsModuleDataGrid();
			hostoryList.enabledPercentSize = true;
			vbox.addChild(hostoryList);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 845;
			opts.height = 580;
			opts.title = "选择历史版本";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsDataManageHistoryPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsDataManageHistoryPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsDataManageHistoryPopupwinMediator.NAME);
		}
	}
}