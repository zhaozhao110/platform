package com.editor.module_gdps.pop.svnLog
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.NativeWindowType;

	public class GdpsPublishSvnLogPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPublishSvnLogPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var confirmBtn:UIButton;
		public var cancelBtn:UIButton;
		public var svnlog_datagrid:SandyDataGrid;
		public var svnlog_datagrid_detail:SandyDataGrid;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.enabledPercentSize = true;
			vbox.padding = 10;
			vbox.verticalGap = 3;
			addChild(vbox);
			
			var hbox:UIHBox = new UIHBox();
			hbox.height = 25;
			hbox.percentWidth = 100;
			hbox.horizontalGap = 6;
			hbox.verticalAlign = "middle";
			vbox.addChild(hbox);
			
			choose_tip = new UILabel();
			choose_tip.color = 0x00BB00;
			choose_tip.bold = true;
			choose_tip.text = "显示最近一个月的svn版本日志信息";
			hbox.addChild(choose_tip);
			
			svnlog_datagrid = new SandyDataGrid();
			svnlog_datagrid.height = 300;
			svnlog_datagrid.percentWidth = 100;
			svnlog_datagrid.rowHeight = 25;
			svnlog_datagrid.horizontalScrollPolicy = "off";
			svnlog_datagrid.verticalScrollPolicy = "auto";
			svnlog_datagrid.styleName = GDPSDataManager.dataGridDefaultTheme;
			vbox.addChild(svnlog_datagrid);
			
			svnlog_datagrid_detail = new SandyDataGrid();
			svnlog_datagrid_detail.enabledPercentSize = true;
			svnlog_datagrid_detail.rowHeight = 25;
			svnlog_datagrid_detail.horizontalScrollPolicy = "off";
			svnlog_datagrid_detail.verticalScrollPolicy = "auto";
			svnlog_datagrid_detail.styleName = GDPSDataManager.dataGridDefaultTheme;
			vbox.addChild(svnlog_datagrid_detail);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.height = 25;
			hbox2.percentWidth = 100;
			hbox2.horizontalGap = 20;
			hbox2.paddingRight = 10;
			hbox2.horizontalAlign = "right";
			hbox2.verticalAlign = "middle";
			vbox.addChild(hbox2);
			
			confirmBtn = new UIButton();
			confirmBtn.label = "确定";
			confirmBtn.width = 60;
			confirmBtn.height = 25;
			hbox2.addChild(confirmBtn);
			
			cancelBtn = new UIButton();
			cancelBtn.label = "取消";
			cancelBtn.width = 60;
			cancelBtn.height = 25;
			hbox2.addChild(cancelBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 900;
			opts.height = 605;
			opts.title = "SVN日志信息";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPublishSvnLogPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPublishSvnLogPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPublishSvnLogPopupwinMediator.NAME);
		}
	}
}