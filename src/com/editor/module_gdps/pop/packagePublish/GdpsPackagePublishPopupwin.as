package com.editor.module_gdps.pop.packagePublish
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

	public class GdpsPackagePublishPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPackagePublishPopupwin()
		{
			super();
			create_init();
		}
		
		public var dataPublishBtn:UIButton;
		public var choose_tip:UILabel;
		public var updateBatchRecordDetail_datagrid:SandyDataGrid
		
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
			hbox.addChild(choose_tip);
			
			dataPublishBtn = new UIButton();
			dataPublishBtn.label = "批次发布";
			dataPublishBtn.color = 0xCF6A27;
			hbox.addChild(dataPublishBtn);
			
			updateBatchRecordDetail_datagrid = new SandyDataGrid();
			updateBatchRecordDetail_datagrid.enabledPercentSize = true;
			updateBatchRecordDetail_datagrid.rowHeight = 30;
			updateBatchRecordDetail_datagrid.horizontalScrollPolicy = "auto";
			updateBatchRecordDetail_datagrid.verticalScrollPolicy = "auto";
			updateBatchRecordDetail_datagrid.styleName = GDPSDataManager.dataGridDefaultTheme;
			vbox.addChild(updateBatchRecordDetail_datagrid);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 900;
			opts.height = 605;
			opts.title = "基础数据批次发布外网";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPackagePublishPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPackagePublishPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPackagePublishPopupwinMediator.NAME);
		}
	}
}