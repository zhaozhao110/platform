package com.editor.module_gdps.pop.publishRecord
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILinkButton;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	
	public class GdpsPublishRecordPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPublishRecordPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var previewList:GdpsModuleDataGrid;
		
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
			
			choose_tip = new UILabel();
			choose_tip.color = 0x008000;
			choose_tip.bold = true;
			choose_tip.text = "请在结果列表中选择您需要添加的批次号 【双击记录返回】";
			hbox.addChild(choose_tip);
			
			previewList = new GdpsModuleDataGrid();
			previewList.enabledPercentSize = true;
			vbox.addChild(previewList);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 900;
			opts.height = 595;
			opts.title = "选择更新批次";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPublishRecordPopupwin_sign;
			isModel    		= true;
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPublishRecordPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPublishRecordPopupwinMediator.NAME);
		}
	}
}