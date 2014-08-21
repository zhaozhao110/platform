package com.editor.module_gdps.pop.packagePacking
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

	public class GdpsPackagePackingPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPackagePackingPopupwin()
		{
			super();
			create_init();
		}
		
		
		public var packagingBtn:UIButton;
		public var choose_tip:UILabel;
		public var listBatchRecordDetail_datagrid:SandyDataGrid
		
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
			
			packagingBtn = new UIButton();
			packagingBtn.label = "批次打包";
			packagingBtn.color = 0xCF6A27;
			hbox.addChild(packagingBtn);
			
			listBatchRecordDetail_datagrid = new SandyDataGrid();
			listBatchRecordDetail_datagrid.enabledPercentSize = true;
			listBatchRecordDetail_datagrid.rowHeight = 30;
			listBatchRecordDetail_datagrid.horizontalScrollPolicy = "auto";
			listBatchRecordDetail_datagrid.verticalScrollPolicy = "auto";
			listBatchRecordDetail_datagrid.styleName = GDPSDataManager.dataGridDefaultTheme;
			vbox.addChild(listBatchRecordDetail_datagrid);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 900;
			opts.height = 605;
			opts.title = "批次打包";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPackagePackingPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPackagePackingPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPackagePackingPopupwinMediator.NAME);
		}
	}
}