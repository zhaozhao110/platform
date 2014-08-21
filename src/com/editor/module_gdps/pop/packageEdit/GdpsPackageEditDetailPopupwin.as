package com.editor.module_gdps.pop.packageEdit
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsPackageEditDetailPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPackageEditDetailPopupwin()
		{
			super();
			create_init();
		}
		
		
		public var saveBtn:UIButton;
		public var list:GdpsModuleDataGrid;
		public var local_batchno_tip:UILabel;
		
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
			
			local_batchno_tip = new UILabel();
			local_batchno_tip.color = 0x00BB00;
			local_batchno_tip.bold = true;
			hbox.addChild(local_batchno_tip);
			
			saveBtn = new UIButton();
			saveBtn.label = "添加编辑表到批次";
			saveBtn.color = 0xCF6A27;
			hbox.addChild(saveBtn);
			
			list = new GdpsModuleDataGrid();
			list.enabledPercentSize = true;
			vbox.addChild(list);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 808;
			opts.height = 600;
			opts.title = "直接添加编辑表明细";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPackageEditDetailPopwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPackageEditDetailPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPackageEditDetailPopupwinMediator.NAME);
		}
	}
}