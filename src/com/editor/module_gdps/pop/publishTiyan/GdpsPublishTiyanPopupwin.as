package com.editor.module_gdps.pop.publishTiyan
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.NativeWindowType;

	public class GdpsPublishTiyanPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsPublishTiyanPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var add_tip:UILabel;
		public var client_text:UIText;
		public var server_text:UIText;
		public var res_text:UIText;
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
			vbox1.width = 180;
			vbox1.percentHeight = 100;
			vbox1.verticalGap = 15;
			hbox1.addChild(vbox1);
			
			var titleTxt:UILabel = new UILabel();
			titleTxt.height = 20;
			titleTxt.color = 0x698537;
			titleTxt.text = "SVN版本数据更新";
			vbox1.addChild(titleTxt);
			
			var hbox2:UIHBox = new UIHBox();
			hbox2.verticalAlign = "middle";
			hbox2.horizontalGap = 0;
			vbox1.addChild(hbox2);
			
			var lb1:UILabel = new UILabel();
			lb1.text = "客户端更新版本号：";
			lb1.color = 0x7FA139;
			lb1.width = 130;
			hbox2.addChild(lb1);
			
			client_text = new UIText();
			client_text.color = 0xDC1111;
			client_text.bold = true;
			hbox2.addChild(client_text);
			
			var hbox3:UIHBox = new UIHBox();
			hbox3.horizontalGap = 0;
			hbox3.verticalAlign = "middle";
			vbox1.addChild(hbox3);
			
			var lb2:UILabel = new UILabel();
			lb2.text = "服务端更新版本号：";
			lb2.color = 0x7FA139;
			lb2.width = 130;
			hbox3.addChild(lb2);
			
			server_text = new UIText();
			server_text.color = 0xDC1111;
			server_text.bold = true;
			hbox3.addChild(server_text);
			
			var hbox4:UIHBox = new UIHBox();
			hbox4.horizontalGap = 0;
			hbox4.verticalAlign = "middle";
			vbox1.addChild(hbox4);
			
			var lb3:UILabel = new UILabel();
			lb3.text = "资源文件更新版本号：";
			lb3.color = 0x7FA139;
			lb3.width = 130;
			hbox4.addChild(lb3);
			
			res_text = new UIText();
			res_text.color = 0xDC1111;
			res_text.bold = true;
			hbox4.addChild(res_text);
			
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
			popupSign  		= GDPSPopupwinSign.GdpsPublishTiyanPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsPublishTiyanPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsPublishTiyanPopupwinMediator.NAME);
		}
	}
}