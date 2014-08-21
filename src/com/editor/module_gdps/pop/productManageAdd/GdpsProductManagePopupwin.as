package com.editor.module_gdps.pop.productManageAdd
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

	public class GdpsProductManagePopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsProductManagePopupwin()
		{
			super();
			create_init();
		}
		
		public var form1:UIForm;
		public var SName:UITextInput;
		public var NGidTxt:UITextInput;
		public var STypeCb:UICombobox;
		public var SSvnNameTxt:UITextInput;
		public var form2:UIForm;
		public var SAliasTxt:UITextInput;
		public var SSvnPwdTxt:UITextInput;
		public var statusCb:UICombobox;
		public var descTxt:UITextArea;
		public var saveBtn:UIButton;
		public var closeBtn:UIButton;
		public var resetBtn:UIButton;
		public var clientTxt:UITextInput;
		public var serverTxt:UITextInput;
		public var resTxt:UITextInput;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.verticalAlign = "middle";
			vbox.paddingTop = 0;
			vbox.verticalGap = 10;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.width = 600;
			hbox1.height = 140;
			hbox1.horizontalGap = 10;
			hbox1.paddingLeft = 10;
			hbox1.paddingRight = 10;
			vbox.addChild(hbox1);
			
			form1 = new UIForm();
			form1.percentWidth = 50;
			form1.height = 145;
			form1.leftWidth = 85;
			form1.verticalGap = 4;
			form1.horizontal_gap = 5;
			form1.horizontalAlign = "right";
			hbox1.addChild(form1);
			
			SName = new UITextInput();
			SName.width = 200;
			SName.height = 24;
			SName.formLabel = "项目名称 *";
			form1.addFormItem(SName);
			
			STypeCb = new UICombobox();
			STypeCb.width = 200;
			STypeCb.height = 24;
			STypeCb.labelField = "label";
			STypeCb.formLabel = "产品类型 *";
			STypeCb.dataProvider = GDPSDataManager.typeList;
			form1.addFormItem(STypeCb);
			STypeCb.selectedIndex = 0;
			
			SSvnNameTxt = new UITextInput();
			SSvnNameTxt.width = 200;
			SSvnNameTxt.height = 24;
			SSvnNameTxt.formLabel = "svn用户名";
			form1.addFormItem(SSvnNameTxt);
			
			NGidTxt = new UITextInput();
			NGidTxt.width = 200;
			NGidTxt.height = 24;
			NGidTxt.restrict = "0-9";
			NGidTxt.formLabel  = "所属游戏ID *";
			form1.addFormItem(NGidTxt);
			
			serverTxt = new UITextInput();
			serverTxt.width = 200;
			serverTxt.height = 24;
			serverTxt.formLabel = "服务端SVN地址";
			form1.addFormItem(serverTxt);
			
			form2 = new UIForm();
			form2.percentWidth = 50;
			form2.height = 145;
			form2.leftWidth = 85;
			form2.horizontalAlign = "right";
			form2.verticalGap = 4;
			form2.horizontal_gap = 5;
			hbox1.addChild(form2);
			
			SAliasTxt = new UITextInput();
			SAliasTxt.width = 200;
			SAliasTxt.height = 24;
			SAliasTxt.formLabel = "项目别名 *";
			form2.addFormItem(SAliasTxt);
			
			statusCb = new UICombobox();
			statusCb.width = 200;
			statusCb.height = 24;
			statusCb.labelField = "label";
			statusCb.formLabel = "状态 *";
			statusCb.dataProvider = GDPSDataManager.statusList;
			form2.addFormItem(statusCb);
			statusCb.selectedIndex = 1;
			
			SSvnPwdTxt = new UITextInput();
			SSvnPwdTxt.width = 200;
			SSvnPwdTxt.height = 24;
			SSvnPwdTxt.formLabel = "svn密码";
			form2.addFormItem(SSvnPwdTxt);
			
			clientTxt = new UITextInput();
			clientTxt.width = 200;
			clientTxt.height = 24;
			clientTxt.formLabel = "客户端SVN地址";
			form2.addFormItem(clientTxt);
			
			resTxt = new UITextInput();
			resTxt.width = 200;
			resTxt.height = 24;
			resTxt.formLabel = "资源SVN地址";
			form2.addFormItem(resTxt);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.width = 605;
			hbox2.height = 60;
			hbox2.horizontalGap = 5;
			hbox2.horizontalAlign = "center";
			vbox.addChild(hbox2);
			
			var descLb:UILabel = new UILabel();
			descLb.text = "扩展描述";
			descLb.width = 85;
			descLb.textAlign = "right";
			hbox2.addChild(descLb);
			
			descTxt = new UITextArea();
			descTxt.width = 496;
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
			opts.width = 620;
			opts.height = 340;
			opts.title = "添加项目";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsProductManageAddPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsProductManagePopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsProductManagePopupwinMediator.NAME);
		}
	}
}