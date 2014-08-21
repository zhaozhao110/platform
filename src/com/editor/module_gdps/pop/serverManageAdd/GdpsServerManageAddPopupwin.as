package com.editor.module_gdps.pop.serverManageAdd
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
	
	public class GdpsServerManageAddPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsServerManageAddPopupwin()
		{
			super();
			create_init();
		}
		
		public var form1:UIForm;
		public var SNameTxt:UITextInput;
		public var STypeCb:UICombobox;
		public var GSNameTxt:UITextInput;
		public var SStateCb:UICombobox;
		public var descTxt:UITextArea;
		public var saveBtn:UIButton;
		public var closeBtn:UIButton;
		public var resetBtn:UIButton;
		public var NAreaIdTxt:UITextInput;
		public var NGameid:UITextInput;
		public var NOpridTxt:UITextInput;
		public var NNidTxt:UITextInput;
		public var SNetlineCb:UICombobox;
		public var SDomainTxt:UITextInput;
		public var SWebUrlTxt:UITextInput;
		public var SWebKeyTxt:UITextInput;
		public var SLoginUrlTxt:UITextInput;
		public var STicketUrlTxt:UITextInput;
		public var DStartTxt:UITextInput;
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.verticalAlign = "middle";
			vbox.paddingTop = 0;
			vbox.verticalGap = 10;
			vbox.enabledPercentSize = true;
			addChild(vbox);
			
			form1 = new UIForm();
			form1.percentWidth = 100;
			form1.height = 418;
			form1.leftWidth = 110;
			form1.verticalGap = 4;
			form1.horizontal_gap = 5;
			form1.horizontalAlign = "right";
			form1.paddingLeft = 20;
			vbox.addChild(form1);
			
			SNameTxt = new UITextInput();
			SNameTxt.width = 200;
			SNameTxt.height = 24;
			SNameTxt.formLabel = "服务器名称 *";
			form1.addFormItem(SNameTxt);
			
			GSNameTxt = new UITextInput();
			GSNameTxt.width = 200;
			GSNameTxt.height = 24;
			GSNameTxt.formLabel = "服务器内显示名称 *";
			form1.addFormItem(GSNameTxt);
			
			STypeCb = new UICombobox();
			STypeCb.width = 200;
			STypeCb.height = 24;
			STypeCb.labelField = "label";
			STypeCb.formLabel = "服务器类型 *";
			STypeCb.dataProvider = GDPSDataManager.serverNames;
			form1.addFormItem(STypeCb);
			STypeCb.selectedIndex = 0;
			
			SStateCb = new UICombobox();
			SStateCb.width = 200;
			SStateCb.height = 24;
			SStateCb.labelField = "label";
			SStateCb.formLabel = "服务器状态 *";
			form1.addFormItem(SStateCb);
			
			SNetlineCb = new UICombobox();
			SNetlineCb.width = 200;
			SNetlineCb.height = 24;
			SNetlineCb.labelField = "label";
			SNetlineCb.formLabel = "网络线路 *";
			SNetlineCb.dataProvider = GDPSDataManager.netLines;
			form1.addFormItem(SNetlineCb);
			SNetlineCb.selectedIndex = 3;
			
			NGameid = new UITextInput();
			NGameid.width = 200;
			NGameid.height = 24;
			NGameid.formLabel = "所属游戏ID";
			NGameid.restrict = "0-9";
			form1.addFormItem(NGameid);
			
			NAreaIdTxt = new UITextInput();
			NAreaIdTxt.width = 200;
			NAreaIdTxt.height = 24;
			NAreaIdTxt.restrict = "0-9";
			NAreaIdTxt.formLabel = "所属项目ID *";
			form1.addFormItem(NAreaIdTxt);
			
			NNidTxt = new UITextInput();
			NNidTxt.width = 200;
			NNidTxt.height = 24;
			NNidTxt.formLabel = "所属节点ID";
			form1.addFormItem(NNidTxt);
			
			NOpridTxt = new UITextInput();
			NOpridTxt.width = 200;
			NOpridTxt.height = 24;
			NOpridTxt.restrict = "0-9";
			NOpridTxt.formLabel = "主运营商ID";
			NOpridTxt.text = "101";
			form1.addFormItem(NOpridTxt);
			
			DStartTxt = new UITextInput();
			DStartTxt.width = 200;
			DStartTxt.height = 24;
			DStartTxt.formLabel = "开服时间";
			form1.addFormItem(DStartTxt);
			
			SDomainTxt = new UITextInput();
			SDomainTxt.width = 200;
			SDomainTxt.height = 24;
			SDomainTxt.formLabel = "服务器域名";
			form1.addFormItem(SDomainTxt);
			
			SWebUrlTxt = new UITextInput();
			SWebUrlTxt.width = 200;
			SWebUrlTxt.height = 24;
			SWebUrlTxt.formLabel = "游戏WEB接口地址";
			form1.addFormItem(SWebUrlTxt);
			
			SWebKeyTxt = new UITextInput();
			SWebKeyTxt.width = 200;
			SWebKeyTxt.height = 24;
			SWebKeyTxt.formLabel = "游戏WEB接口密钥";
			form1.addFormItem(SWebKeyTxt);
			
			SLoginUrlTxt = new UITextInput();
			SLoginUrlTxt.width = 200;
			SLoginUrlTxt.height = 24;
			SLoginUrlTxt.formLabel = "游戏登陆接口地址";
			form1.addFormItem(SLoginUrlTxt);
			
			STicketUrlTxt = new UITextInput();
			STicketUrlTxt.width = 200;
			STicketUrlTxt.height = 24;
			STicketUrlTxt.formLabel = "游戏登陆票据接口";
			form1.addFormItem(STicketUrlTxt);
			
			descTxt = new UITextArea();
			descTxt.width = 200;
			descTxt.height = 60;
			descTxt.formLabel = "描述";
			form1.addChild(descTxt);
			
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
			opts.width = 420;
			opts.height = 524;
			opts.title = "添加服务器";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsServerManageAddPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsServerManageAddPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsServerManageAddPopupwinMediator.NAME);
		}
	}
}