package com.editor.module_gdps.pop.packageDetail
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILinkButton;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.NativeWindowType;

	public class GdpsPackageDetailPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPackageDetailPopupwin()
		{
			super();
			create_init();
		}
		
		
		public var deleteBtn:UIButton;
		public var addEditDetailBtn:UIButton;
		public var addDetailBtn:UIButton;
		public var listBatchRecordDetail_datagrid:SandyDataGrid;
		public var choose_tip:UILabel;
		
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
			
			addDetailBtn = new UIButton();
			addDetailBtn.label = "添加批次明细";
			hbox.addChild(addDetailBtn);
			
			deleteBtn = new UIButton();
			deleteBtn.label = "删除批次明细";
			hbox.addChild(deleteBtn);
			
			addEditDetailBtn = new UIButton();
			addEditDetailBtn.label = "直接添加编辑表数据";
			addEditDetailBtn.color = 0xCF6A27;
			hbox.addChild(addEditDetailBtn);
			
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
			opts.title = "批次明细/设定";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPackageDetailPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPackageDetailPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPackageDetailPopupwinMediator.NAME);
		}
	}
}