package com.editor.module_gdps.pop.serverVersion
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsServerVersionPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsServerVersionPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
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
			
			choose_tip = new UILabel();
			choose_tip.text = "当前编辑版数据》";
			choose_tip.bold = true;
			choose_tip.color = 0x00CC00;
			hbox.addChild(choose_tip);
			
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
			opts.title = "选择DB版本";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsServerVersionPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsServerVersionPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsServerVersionPopupwinMediator.NAME);
		}
	}
}