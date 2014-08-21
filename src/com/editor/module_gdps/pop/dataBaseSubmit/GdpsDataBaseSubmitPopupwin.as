package com.editor.module_gdps.pop.dataBaseSubmit
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsDataBaseSubmitPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsDataBaseSubmitPopupwin()
		{
			super();
			create_init();
		}
		
		public var submit_rids_desc:UILabel;
		public var publishCbox:UICheckBox;
		public var totalBatchcbox:UICheckBox;
		public var committerLabel:UILabel;
		public var discribeLb:UILabel;
		public var remarksTextArea:UITextArea;
		public var submitForm:UIButton;
		public var cancelBtn:UIButton;
		
		public var vbox:UIVBox;
		public var hbox:UIHBox;
		
		private function create_init():void
		{
			vbox = new UIVBox();
			vbox.verticalAlign = "middle";
			vbox.paddingLeft = 40;
			vbox.paddingTop = 0; 
			vbox.verticalGap = 5;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			submit_rids_desc = new UILabel();
			submit_rids_desc.percentWidth = 100;
			submit_rids_desc.height = 24;
			vbox.addChild(submit_rids_desc);
			
			hbox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.height = 24;
			hbox.verticalAlign = "middle";
			vbox.addChild(hbox);
			
			publishCbox = new UICheckBox();
			publishCbox.label = "是否需要更新至公网";
			publishCbox.toolTip = "选择后当前提交的数据版本可以在打包发布时选择添加到公网服务器";
			publishCbox.selected = false;
			publishCbox.width = 180;
			publishCbox.color = 0xDC1111;
			publishCbox.height = 24;
			hbox.addChild(publishCbox);
			
			totalBatchcbox = new UICheckBox();
			totalBatchcbox.label = "是否需要添加至总更新批次";
			totalBatchcbox.toolTip = "当前数据版本是否需要在总更新批次中更新发布";
			totalBatchcbox.selected = false;
			totalBatchcbox.color = 0x729138;
			totalBatchcbox.visible = false;
			totalBatchcbox.includeInLayout = false;
			totalBatchcbox.percentWidth = 100;
			totalBatchcbox.height = 24;
			vbox.addChild(totalBatchcbox);
			
			committerLabel = new UILabel();
			committerLabel.text = "提交人：";
			vbox.addChild(committerLabel);
			
			discribeLb = new UILabel();
			discribeLb.text = "提交时的备注说明：";
			vbox.addChild(discribeLb);
			
			remarksTextArea = new UITextArea();
			remarksTextArea.width = 300;
			remarksTextArea.height = 100;
			vbox.addChild(remarksTextArea);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.percentWidth = 100;
			hbox1.paddingLeft = 102;
			hbox1.horizontalGap = 20;
			vbox.addChild(hbox1);
			
			submitForm = new UIButton();
			submitForm.label = "确定";
			submitForm.width = 50;
			submitForm.height = 25;
			hbox1.addChild(submitForm);
			
			cancelBtn = new UIButton();
			cancelBtn.label = "取消";
			cancelBtn.width = 50;
			cancelBtn.height = 25;
			hbox1.addChild(cancelBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 320;
			opts.title = "提交DB数据";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsDataBaseSubmitPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsDataBaseSubmitPopwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsDataBaseSubmitPopwinMediator.NAME);
		}
	}
}