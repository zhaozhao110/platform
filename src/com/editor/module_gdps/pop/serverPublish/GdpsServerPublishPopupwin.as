package com.editor.module_gdps.pop.serverPublish
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsServerPublishPopupwin  extends AppPopupWithEmptyWin
	{
		public function GdpsServerPublishPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var revision_tip:UILabel;
		public var dbvision_tip:UILabel;
		public var topic_tip:UILabel;
		public var desc_tip:UILabel;
		public var platform:UILabel;//平台
		public var prt_tip:UITextArea;//运营商
		public var submitBtn:UIButton;
		public var resetBtn:UIButton;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.horizontalAlign = "left";
			vbox.paddingLeft = 65;
			vbox.paddingTop = 30;
			vbox.verticalGap = 5;
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
			
			dbvision_tip = new UILabel();
			dbvision_tip.color = 0x211CEA;
			dbvision_tip.bold = true;
			vbox.addChild(dbvision_tip);
			
			topic_tip = new UILabel();
			topic_tip.color = 0x00BB00;
			topic_tip.bold = true;
			vbox.addChild(topic_tip);
			
			desc_tip = new UILabel();
			desc_tip.color = 0x00BB00;
			desc_tip.bold = true;
			vbox.addChild(desc_tip);
			
			platform = new UILabel();
			platform.color = 0x00BB00;
			platform.bold = true;
			platform.text = "预发布平台: ";
			vbox.addChild(platform);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.percentWidth = 100;
			hbox1.horizontalGap = 0;
			hbox1.verticalAlign = "top";
			vbox.addChild(hbox1);
			
			var prt_lb:UILabel = new UILabel();
			prt_lb.color = 0x00BB00;
			prt_lb.bold = true;
			prt_lb.text = "运营商列表: ";
			hbox1.addChild(prt_lb);
			
			prt_tip = new UITextArea();
			prt_tip.editable = false;
			prt_tip.width = 230;
			prt_tip.height = 150;
			hbox1.addChild(prt_tip);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.height = 30;
			hbox2.percentWidth = 100;
			hbox2.verticalAlign = "middle";
			hbox2.horizontalGap = 30;
			hbox2.paddingLeft = 75;
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
			opts.width = 420;
			opts.height = 450;
			opts.title = "服务端资源发布外网";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsServerPublishPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsServerPublishPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsServerPublishPopupwinMediator.NAME);
		}
	}
}