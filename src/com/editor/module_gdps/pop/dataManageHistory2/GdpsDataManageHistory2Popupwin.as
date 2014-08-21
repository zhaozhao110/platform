package com.editor.module_gdps.pop.dataManageHistory2
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILinkButton;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	
	public class GdpsDataManageHistory2Popupwin extends AppPopupWithEmptyWin
	{
		public function GdpsDataManageHistory2Popupwin()
		{
			super();
			create_init();
		}
		
		public var prepare_cbox:UICheckBox;
		public var publish_cbox:UICheckBox;
		public var comparisonBtn:UIButton;
		public var msg_text:UILabel;
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
			hbox.verticalAlign = "middle";
			vbox.addChild(hbox);
			
			prepare_cbox = new UICheckBox();
			prepare_cbox.label = "当前编辑版数据";
			prepare_cbox.bold = true;
			prepare_cbox.selected = true;
			hbox.addChild(prepare_cbox);
			
			publish_cbox = new UICheckBox();
			publish_cbox.label = "公网版本数据";
			publish_cbox.bold = true;
			hbox.addChild(publish_cbox);
			
			comparisonBtn = new UIButton();
			comparisonBtn.label = "对比";
			comparisonBtn.width = 50;
			hbox.addChild(comparisonBtn);
			
			msg_text = new UILabel();
			msg_text.text = "[任两个版本可对比，编辑版和公网版对比后才能提交]";
			msg_text.width = 530;
			msg_text.color = 0xcc0000;
			msg_text.textAlign = "right";
			hbox.addChild(msg_text);
			
			hostoryList = new GdpsModuleDataGrid();
			hostoryList.enabledPercentSize = true;
			vbox.addChild(hostoryList);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 850;
			opts.height = 590;
			opts.title = "选择版本对比";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsDataManageHistory2Popupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsDataManageHistory2PopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsDataManageHistory2PopupwinMediator.NAME);
		}
	}
}