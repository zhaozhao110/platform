package com.editor.module_gdps.pop.serverSave
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsServerSavePopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsServerSavePopupwin()
		{
			super();
			create_init();
		}
		
		public var form:UIForm;
		public var SBid:UITextInput;
		public var oprCB:UICombobox;
		public var oprBtn:UILinkButton;
		public var oprAreaTxt:UITextArea;
		public var server_svn_version:UITextInput;
		public var dbBtn:UILinkButton;
		public var server_db_version:UITextInput;
		public var svnBtn:UILinkButton;
		public var STopic:UITextInput;
		public var SDesc:UITextArea;
		public var saveBtn:UIButton;
		public var resetBtn:UIButton;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.verticalAlign = "middle";
			vbox.horizontalAlign = "center";
			vbox.paddingLeft = 40;
			vbox.paddingTop = 0;
			vbox.verticalGap = 15;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			form = new UIForm();
			form.percentWidth = 100;
			form.percentHeight = 80;
			form.leftWidth = 95;
			form.verticalGap = 7;
			form.horizontalAlign = "right";
			vbox.addChild(form);
			
			SBid = new UITextInput();
			SBid.formLabel = "更新批次号 *";
			SBid.editable = true;
			SBid.width = 230;
			SBid.height = 24;
			form.addFormItem(SBid);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.formLabel = "更新指定平台 *";
			hbox1.width = 230;
			hbox1.verticalAlign = "middle";
			hbox1.horizontalGap = 0;
			form.addFormItem(hbox1);
			
			oprCB = new UICombobox();
			oprCB.width = 170;
			oprCB.height = 24;
			oprCB.labelField = "label";
			oprCB.enabled = false;
			hbox1.addChild(oprCB);
			
			oprBtn = new UILinkButton();
			oprBtn.color = 0x0000FF;
			oprBtn.text = "查看运营商";
			oprBtn.bold = true;
			oprBtn.width = 110;
			hbox1.addChild(oprBtn);
			
			oprAreaTxt = new UITextArea();
			oprAreaTxt.width = 230;
			oprAreaTxt.height = 85;
			oprAreaTxt.horizontalScrollPolicy = "off";
			oprAreaTxt.verticalScrollPolicy = "auto";
			oprAreaTxt.formLabel = "更新运营商包括";
			oprAreaTxt.editable = false;
			form.addFormItem(oprAreaTxt);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.formLabel = "更新SVN版本号 *";
			hbox2.width = 230;
			hbox2.verticalAlign = "middle";
			hbox2.horizontalGap = 0;
			form.addFormItem(hbox2);
			
			server_svn_version = new UITextInput();
			server_svn_version.width = 120;
			server_svn_version.editable = false;
			hbox2.addChild(server_svn_version);
			
			svnBtn = new UILinkButton();
			svnBtn.color = 0x0000FF;
			svnBtn.text = "点此修改SVN版本";
			svnBtn.bold = true;
			svnBtn.width = 110;
			hbox2.addChild(svnBtn);
			
			var hbox3:UIHBox = new UIHBox();
			hbox3.formLabel = "更新DB版本号";
			hbox3.width = 230;
			hbox3.verticalAlign = "middle";
			hbox3.horizontalGap = 0;
			form.addFormItem(hbox3);
			
			server_db_version = new UITextInput();
			server_db_version.width = 120;
			server_db_version.editable = false;
			hbox3.addChild(server_db_version);
			
			dbBtn = new UILinkButton();
			dbBtn.color = 0x0000FF;
			dbBtn.text = "点此修改DB版本";
			dbBtn.bold = true;
			dbBtn.width = 110;
			hbox3.addChild(dbBtn);
			
			STopic = new UITextInput();
			STopic.formLabel = "批次主题 *";
			STopic.width = 230;
			STopic.height = 24;
			form.addFormItem(STopic);
			
			SDesc = new UITextArea();
			SDesc.formLabel = "更新内容描述 *";
			SDesc.width = 230;
			SDesc.height = 80;
			form.addFormItem(SDesc);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.horizontalAlign = "center";
			hbox.horizontalGap = 20;
			vbox.addChild(hbox);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存";
			saveBtn.width = 50;
			saveBtn.height = 25;
			hbox.addChild(saveBtn);
			
			resetBtn = new UIButton();
			resetBtn.label = "重置";
			resetBtn.width = 50;
			resetBtn.height = 25;
			hbox.addChild(resetBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 460;
			opts.title = "添加服务端数据更新批次";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsServerSavePopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsServerSavePopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsServerSavePopupwinMediator.NAME);
		}
	}
}