package com.editor.module_gdps.pop.serverList
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.NativeWindowType;

	public class GdpsServerListPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsServerListPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var cb:UICheckBox;
		public var saveBtn:UIButton;
		public var dgList:SandyDataGrid;
		
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
			
			choose_tip = new UILabel();
			choose_tip.color = 0x008000;
			choose_tip.bold = true;
			choose_tip.text = "[请在结果列表中选择您需要更新的平台]";
			hbox.addChild(choose_tip);
			
			cb = new UICheckBox();
			cb.selected = false;
			cb.label = "选择系统默认平台";
			hbox.addChild(cb);
			
			saveBtn = new UIButton();
			saveBtn.label = "确定";
			saveBtn.width = 50;
			saveBtn.height = 25;
			hbox.addChild(saveBtn);
			
			dgList = new SandyDataGrid();
			dgList.enabledPercentSize = true;
			dgList.isDoubleClick = true;
			dgList.rowHeight = 30;
			dgList.verticalScrollPolicy = "auto";
			dgList.horizontalScrollPolicy = "auto";
			dgList.styleName = GDPSDataManager.dataGridDefaultTheme;
			vbox.addChild(dgList);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 650;
			opts.height = 550;
			opts.title = "选择更新平台";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsServerListPopupwin_sign;
			isModel    		= true;
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsServerListPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsServerListPopupwinMediator.NAME);
		}
	}
}