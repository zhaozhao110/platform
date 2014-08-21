package com.editor.module_gdps.pop.dataBaseHistory
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsDataBaseHistoryPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsDataBaseHistoryPopupwin()
		{
			super();
			create_init();
		}
		
		public var tip_version_info:UILabel;
		public var historyList:GdpsModuleDataGrid;
		
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
			
			tip_version_info = new UILabel();
			tip_version_info.color = 0x008000;
			tip_version_info.bold = true;
			tip_version_info.text = "显示历史提交至版本库的SQL文件记录";
			hbox.addChild(tip_version_info);
			
			historyList = new GdpsModuleDataGrid();
			historyList.enabledPercentSize = true;
			vbox.addChild(historyList);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 850;
			opts.height = 590;
			opts.title = "历史版本查看";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsDataBaseHistoryPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsDataBaseHistoryPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsDataBaseHistoryPopupwinMediator.NAME);
		}
	}
}