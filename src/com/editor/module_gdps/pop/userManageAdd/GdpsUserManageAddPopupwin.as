package com.editor.module_gdps.pop.userManageAdd
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsUserManageAddPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsUserManageAddPopupwin()
		{
			super();
			create_init();
		}
		
		public var form1:UIForm;
		public var loginCodeTxt:UITextInput;
		public var passwdTxt:UITextInput;
		public var sexCb:UICombobox;
		public var departmentTxt:UITextInput;
		public var issuerIdTxt:UITextInput;
		public var form2:UIForm;
		public var realNameTxt:UITextInput;
		public var surePasswdTxt:UITextInput;
		public var telTxt:UITextInput;
		public var emailTxt:UITextInput;
		public var statusCb:UICombobox;
		public var restrictedTime1:UITextInput;
		public var restrictedTime2:UITextInput;
		public var descTxt:UITextArea;
		public var saveBtn:UIButton;
		public var closeBtn:UIButton;
		public var resetBtn:UIButton;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.verticalAlign = "middle";
			vbox.paddingTop = 0;
			vbox.verticalGap = 10;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.width = 560;
			hbox1.height = 145;
			hbox1.horizontalGap = 10;
			hbox1.paddingLeft = 10;
			hbox1.paddingRight = 10;
			vbox.addChild(hbox1);
			
			form1 = new UIForm();
			form1.percentWidth = 50;
			form1.height = 145;
			form1.leftWidth = 75;
			form1.verticalGap = 4;
			form1.horizontal_gap = 5;
			form1.horizontalAlign = "right";
			hbox1.addChild(form1);
			
			loginCodeTxt = new UITextInput();
			loginCodeTxt.width = 200;
			loginCodeTxt.height = 24;
			loginCodeTxt.formLabel = "登陆帐号 *";
			form1.addFormItem(loginCodeTxt);
			
			passwdTxt = new UITextInput();
			passwdTxt.width = 200;
			passwdTxt.height = 24;
			passwdTxt.formLabel = "登陆密码 *";
			form1.addFormItem(passwdTxt);
			
			sexCb = new UICombobox();
			sexCb.width = 200;
			sexCb.height = 24;
			sexCb.labelField = "label";
			sexCb.formLabel = "性别 *";
			sexCb.dataProvider = GDPSDataManager.sexList;
			form1.addFormItem(sexCb);
			sexCb.selectedIndex = 1;
			
			departmentTxt = new UITextInput();
			departmentTxt.width = 200;
			departmentTxt.height = 24;
			departmentTxt.formLabel = "所在部门";
			form1.addFormItem(departmentTxt);
			
			issuerIdTxt = new UITextInput();
			issuerIdTxt.width = 200;
			issuerIdTxt.height = 24;
			issuerIdTxt.formLabel = "隶属运营商ID";
			form1.addFormItem(issuerIdTxt);
			
			form2 = new UIForm();
			form2.percentWidth = 50;
			form2.height = 145;
			form2.leftWidth = 75;
			form2.horizontalAlign = "right";
			form2.verticalGap = 4;
			form2.horizontal_gap = 5;
			hbox1.addChild(form2);
			
			realNameTxt = new UITextInput();
			realNameTxt.width = 200;
			realNameTxt.height = 24;
			realNameTxt.formLabel = "真实姓名 *";
			form2.addFormItem(realNameTxt);
			
			surePasswdTxt = new UITextInput();
			surePasswdTxt.width = 200;
			surePasswdTxt.height = 24;
			surePasswdTxt.formLabel = "密码确认 *";
			form2.addFormItem(surePasswdTxt);
			
			statusCb = new UICombobox();
			statusCb.width = 200;
			statusCb.height = 24;
			statusCb.labelField = "label";
			statusCb.formLabel = "状态 *";
			statusCb.dataProvider = GDPSDataManager.statusList;
			form2.addFormItem(statusCb);
			statusCb.selectedIndex = 1;
			
			emailTxt = new UITextInput();
			emailTxt.width = 200;
			emailTxt.height = 24;
			emailTxt.formLabel = "邮箱";
			form2.addFormItem(emailTxt);
			
			telTxt = new UITextInput();
			telTxt.width = 200;
			telTxt.height = 24;
			telTxt.formLabel = "电话号码";
			form2.addFormItem(telTxt);
			
			var hbox3:UIHBox = new UIHBox();
			hbox3.width = 565;
			hbox3.height = 24;
			hbox3.horizontalGap = 5;
			hbox3.verticalAlign = "middle";
			hbox3.horizontalAlign = "right";
			vbox.addChild(hbox3);
			
			var lab1:UILabel = new UILabel();
			lab1.width = 75;
			lab1.textAlign = "right";
			lab1.text = "限时登陆";
			hbox3.addChild(lab1);
			
			restrictedTime1 = new UITextInput();
			restrictedTime1.width = 200;
			restrictedTime1.height = 24;
			hbox3.addChild(restrictedTime1);
			
			var lab2:UILabel = new UILabel();
			lab2.width = 64;
			lab2.textAlign = "center";
			lab2.text = "至";
			hbox3.addChild(lab2);
			
			restrictedTime2 = new UITextInput();
			restrictedTime2.width = 200;
			restrictedTime2.height = 24;
			hbox3.addChild(restrictedTime2);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.width = 565;
			hbox2.height = 60;
			hbox2.horizontalGap = 5;
			hbox2.horizontalAlign = "right";
			vbox.addChild(hbox2);
			
			var descLb:UILabel = new UILabel();
			descLb.text = "描述";
			descLb.width = 75;
			descLb.textAlign = "right";
			hbox2.addChild(descLb);
			
			descTxt = new UITextArea();
			descTxt.width = 476;
			descTxt.height = 60;
			hbox2.addChild(descTxt);
			
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
			
			closeBtn = new UIButton();
			closeBtn.label = "关闭";
			closeBtn.width = 50;
			closeBtn.height = 25;
			hbox.addChild(closeBtn);
			
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
			opts.width = 600;
			opts.height = 350;
			opts.title = "添加用户";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsUserManageAddPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsUserManageAddPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsUserManageAddPopupwinMediator.NAME);
		}
	}
}