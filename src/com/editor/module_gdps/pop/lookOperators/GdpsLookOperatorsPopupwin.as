package com.editor.module_gdps.pop.lookOperators
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIDataGrid;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class GdpsLookOperatorsPopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsLookOperatorsPopupwin()
		{
			super();
			create_init();
		}
		
		public var choose_tip:UILabel;
		public var dgList:UIDataGrid;
		
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
			hbox.addChild(choose_tip);
			
			
			dgList = new UIDataGrid();
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
			opts.width = 642;
			opts.height = 550;
			opts.title = "查看当前平台运营商";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsLookOperatorsPopupwin_sign;
			isModel    		= true;
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsLookOperatorsPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsLookOperatorsPopupwinMediator.NAME);
		}
	}
}