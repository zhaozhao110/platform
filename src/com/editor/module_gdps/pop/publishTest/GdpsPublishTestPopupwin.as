package com.editor.module_gdps.pop.publishTest
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIRadioButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.NativeWindowType;

	public class GdpsPublishTestPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPublishTestPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var add_tip:UILabel;
		public var client_svn_code_cbox:UICheckBox;
		public var client_version_frame:UIVBox;
		public var client_version_rb2:UIRadioButton;
		public var client_version_text:UITextInput;
		public var client_version_showlog:UIButton;
		
		public var server_svn_code_cbox:UICheckBox;
		public var server_version_frame:UIVBox;
		public var server_version_rb2:UIRadioButton;
		public var server_version_text:UITextInput;
		public var server_version_showlog:UIButton;
		
		public var res_svn_code_cbox:UICheckBox;
		public var res_version_frame:UIVBox;
		public var res_version_rb2:UIRadioButton;
		public var res_version_text:UITextInput;
		public var res_version_showlog:UIButton;
		
		public var submitBtn:UIButton;
		public var resetBtn:UIButton;
		
		public var server_execute_datagrid:SandyDataGrid
		
		private function create_init():void
		{
			var vbox:UIVBox = new UIVBox();
			vbox.enabledPercentSize = true;
			vbox.padding = 10;
			vbox.verticalGap = 3;
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
			
			add_tip = new UILabel();
			add_tip.color = 0x0000FF;
			add_tip.bold = true;
			hbox.addChild(add_tip);
			
			
			var hbox1:UIHBox = new UIHBox();
			hbox1.enabledPercentSize = true;
			hbox1.horizontalGap = 5;
			hbox1.verticalAlign = "middle";
			vbox.addChild(hbox1);
			
			var vbox1:UIVBox = new UIVBox();
			vbox1.width = 200;
			vbox1.percentHeight = 100;
			vbox1.verticalGap = 15;
			hbox1.addChild(vbox1);
			
			var titleTxt:UILabel = new UILabel();
			titleTxt.height = 20;
			titleTxt.color = 0x698537;
			titleTxt.text = "SVN版本数据更新";
			vbox1.addChild(titleTxt);
			
			client_svn_code_cbox = new UICheckBox();
			client_svn_code_cbox.label = "更新客户端SVN代码";
			client_svn_code_cbox.selected = false;
			client_svn_code_cbox.toolTip = "选后可以选择客户端SVN代码的指定版本号";
			vbox1.addChild(client_svn_code_cbox);
			
			client_version_frame = new UIVBox();
			client_version_frame.paddingLeft = 10;
			client_version_frame.visible = false;
			client_version_frame.verticalGap = 5;
			vbox1.addChild(client_version_frame);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.verticalAlign = "middle";
			hbox2.horizontalGap = 10;
			client_version_frame.addChild(hbox2);
			
			client_version_rb2 = new UIRadioButton();
			client_version_rb2.label = "版本号";
			client_version_rb2.width = 70;
			client_version_rb2.selected = true;
			client_version_rb2.toolTip = "请在日志信息中指定需要更新的版本号";
			hbox2.addChild(client_version_rb2);
			
			client_version_text = new UITextInput();
			client_version_text.editable = false;
			client_version_text.width = 100;
			hbox2.addChild(client_version_text);
			
			client_version_showlog = new UIButton();
			client_version_showlog.label = "显示日志";
			client_version_showlog.width = 80;
			client_version_frame.addChild(client_version_showlog);
			
			server_svn_code_cbox = new UICheckBox();
			server_svn_code_cbox.label = "更新服务端SVN代码";
			server_svn_code_cbox.selected = false;
			server_svn_code_cbox.toolTip = "勾选后可以选择服务端SVN代码的指定版本号";
			vbox1.addChild(server_svn_code_cbox);
			
			server_version_frame = new UIVBox();
			server_version_frame.paddingLeft = 10;
			server_version_frame.visible = false;
			server_version_frame.verticalGap = 5;
			vbox1.addChild(server_version_frame);
			
			var hbox3:UIHBox = new UIHBox();
			hbox3.horizontalGap = 10;
			hbox3.verticalAlign = "middle";
			server_version_frame.addChild(hbox3);
			
			server_version_rb2 = new UIRadioButton();
			server_version_rb2.label = "版本号";
			server_version_rb2.width = 70;
			server_version_rb2.selected = true;
			server_version_rb2.toolTip = "请在日志信息中指定需要更新的版本号";
			hbox3.addChild(server_version_rb2);
			
			server_version_text = new UITextInput();
			server_version_text.editable = false;
			server_version_text.width = 100;
			hbox3.addChild(server_version_text);
			
			server_version_showlog = new UIButton();
			server_version_showlog.label = "显示日志";
			server_version_showlog.width = 80;
			server_version_frame.addChild(server_version_showlog);
			
			res_svn_code_cbox = new UICheckBox();
			res_svn_code_cbox.label = "更新资源SVN代码";
			res_svn_code_cbox.selected = false;
			res_svn_code_cbox.toolTip = "勾选后可以选择资源SVN的指定版本号";
			vbox1.addChild(res_svn_code_cbox);
			
			res_version_frame = new UIVBox();
			res_version_frame.paddingLeft = 10;
			res_version_frame.visible = false;
			res_version_frame.verticalGap = 5;
			vbox1.addChild(res_version_frame);
			
			var hbox4:UIHBox = new UIHBox();
			hbox4.horizontalGap = 10;
			hbox4.verticalAlign = "middle";
			res_version_frame.addChild(hbox4);
			
			res_version_rb2 = new UIRadioButton();
			res_version_rb2.label = "版本号";
			res_version_rb2.width = 70;
			res_version_rb2.selected = true;
			res_version_rb2.toolTip = "请在日志信息中指定需要更新的版本号";
			hbox4.addChild(res_version_rb2);
			
			res_version_text = new UITextInput();
			res_version_text.editable = false;
			res_version_text.width = 100;
			hbox4.addChild(res_version_text);
			
			res_version_showlog = new UIButton();
			res_version_showlog.label = "显示日志";
			res_version_showlog.width = 80;
			res_version_frame.addChild(res_version_showlog);
			
			server_execute_datagrid = new SandyDataGrid();
			server_execute_datagrid.enabledPercentSize = true;
			server_execute_datagrid.rowHeight = 30;
			server_execute_datagrid.horizontalScrollPolicy = "auto";
			server_execute_datagrid.verticalScrollPolicy = "auto";
			server_execute_datagrid.styleName = GDPSDataManager.dataGridDefaultTheme;
			hbox1.addChild(server_execute_datagrid);
			
			var hbox5:UIHBox = new UIHBox();
			hbox5.height = 30;
			hbox5.percentWidth = 100;
			hbox5.horizontalAlign = "right";
			hbox5.verticalAlign = "middle";
			hbox5.paddingRight = 10;
			hbox5.horizontalGap = 20;
			vbox.addChild(hbox5);
			
			submitBtn = new UIButton();
			submitBtn.label = "更 新";
			submitBtn.width = 60;
			submitBtn.height = 25;
			hbox5.addChild(submitBtn);
			
			resetBtn = new UIButton();
			resetBtn.label = "取 消";
			resetBtn.width = 60;
			resetBtn.height = 25;
			hbox5.addChild(resetBtn);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 900;
			opts.height = 605;
			opts.title = "更新发布测试";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsPublishTestPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPublishTestPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPublishTestPopupwinMediator.NAME);
		}
	}
}