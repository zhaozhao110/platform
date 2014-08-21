package com.editor.module_gdps.pop.resPublish
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	
	public class GdpsResPublishPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsResPublishPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var revision_tip:UILabel;
		public var topic_tip:UILabel;
		public var desc_tip:UILabel;
		public var submitBtn:UIButton;
		public var resetBtn:UIButton;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.horizontalAlign = "left";
			vbox.paddingLeft = 65;
			vbox.paddingTop = 30;
			vbox.verticalGap = 15;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			var hbox:UIHBox = new UIHBox();
			hbox.height = 25;
			hbox.percentWidth = 100;
			hbox.horizontalGap = 15;
			hbox.verticalAlign = "middle";
			vbox.addChild(hbox);
			
			choose_tip = new UILabel();
			choose_tip.color = 0x00BB00;
			choose_tip.bold = true;
			hbox.addChild(choose_tip);
			
			revision_tip = new UILabel();
			revision_tip.color = 0x00BB00;
			revision_tip.bold = true;
			vbox.addChild(revision_tip);
			
			topic_tip = new UILabel();
			topic_tip.color = 0x00BB00;
			topic_tip.bold = true;
			vbox.addChild(topic_tip);
			
			desc_tip = new UILabel();
			desc_tip.color = 0x00BB00;
			desc_tip.bold = true;
			vbox.addChild(desc_tip);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.height = 30;
			hbox2.percentWidth = 100;
			hbox2.verticalAlign = "middle";
			hbox2.horizontalGap = 30;
			hbox2.paddingLeft = 55;
			hbox2.paddingTop = 20;
			vbox.addChild(hbox2);
			
			submitBtn = new UIButton();
			submitBtn.label = "发布";
			submitBtn.width = 50;
			submitBtn.height = 25;
			hbox2.addChild(submitBtn);
			
			resetBtn = new UIButton();
			resetBtn.label = "取消";
			resetBtn.width = 50;
			resetBtn.height = 25;
			hbox2.addChild(resetBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 370;
			opts.height = 300;
			opts.title = "RES资源发布外网";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsResPublishPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsResPublishPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsResPublishPopupwinMediator.NAME);
		}
	}
}