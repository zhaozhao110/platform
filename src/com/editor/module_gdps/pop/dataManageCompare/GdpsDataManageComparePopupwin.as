package com.editor.module_gdps.pop.dataManageCompare
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIHDividedBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.NativeWindowType;

	public class GdpsDataManageComparePopupwin extends AppPopupWithEmptyWin
	{
		public function GdpsDataManageComparePopupwin()
		{
			super();
			create_init();
		}
		
		public var left_label:UILabel;
		public var right_label:UILabel;
		public var left_comp_dataGrid:SandyDataGrid;
		public var right_comp_dataGrid:SandyDataGrid;
		public var comparisionSubmitBtn:UIButton;
		
		private function create_init():void
		{
			var arr:Array = [];
			var hdBox:UIHDividedBox = new UIHDividedBox();
			hdBox.enabledPercentSize = true
			hdBox.dragAndDrop = true;
			hdBox.padding = 10;
			addChild(hdBox);
			
			var vb1:UIVBox = new UIVBox();
			vb1.width = 480
			vb1.percentHeight = 100;
			arr.push(vb1);
			
			left_label = new UILabel();
			left_label.percentWidth = 100;
			left_label.color = 0x008000;
			left_label.bold = true;
			left_label.height = 25;
			vb1.addChild(left_label);
			
			left_comp_dataGrid = new SandyDataGrid();
			left_comp_dataGrid.enabledPercentSize = true;
			left_comp_dataGrid.rowHeight = 25;
			left_comp_dataGrid.verticalScrollPolicy = "auto";
			left_comp_dataGrid.horizontalScrollPolicy = "auto";
			left_comp_dataGrid.styleName = GDPSDataManager.dataGridDefaultTheme;
			vb1.addChild(left_comp_dataGrid);
			left_comp_dataGrid.addEventListener(ASEvent.SCROLLBARMOVEING,onscrollMove);
			
			var vb2:UIVBox = new UIVBox();
			vb2.enabledPercentSize = true
			arr.push(vb2);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.height = 25;
			hbox.verticalAlign = "middle";
			vb2.addChild(hbox);
			
			right_label = new UILabel();
			right_label.percentWidth = 100;
			right_label.color = 0x008000;
			right_label.bold = true;
			hbox.addChild(right_label);
			
			comparisionSubmitBtn = new UIButton();
			comparisionSubmitBtn.label = "提交";
			comparisionSubmitBtn.visible = false;
			hbox.addChild(comparisionSubmitBtn);
			
			right_comp_dataGrid = new SandyDataGrid();
			right_comp_dataGrid.enabledPercentSize = true;
			right_comp_dataGrid.rowHeight = 25;
			right_comp_dataGrid.verticalScrollPolicy = "auto";
			right_comp_dataGrid.horizontalScrollPolicy = "auto";
			right_comp_dataGrid.styleName = GDPSDataManager.dataGridDefaultTheme;
			vb2.addChild(right_comp_dataGrid);
			right_comp_dataGrid.addEventListener(ASEvent.SCROLLBARMOVEING,onscrollMove2);
			
			hdBox.areaComponent = arr;
			
			initComplete();
		}
		
		private function onscrollMove(e:ASEvent):void
		{
			if(e.addData){
				right_comp_dataGrid.verticalScrollPosition = int(e.data)
			}else{
				right_comp_dataGrid.horticalScrollPosition = int(e.data)
			}
		}
		
		private function onscrollMove2(e:ASEvent):void
		{
			if(e.addData){
				left_comp_dataGrid.verticalScrollPosition = int(e.data)
			}else{
				left_comp_dataGrid.horticalScrollPosition = int(e.data)
			}
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 1000;
			opts.height = 600;
			opts.title = "版本对比视图";
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= GDPSPopupwinSign.GdpsDataManageComparePopwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new GdpsDataManageComparePopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			removeMediator(GdpsDataManageComparePopupwinMediator.NAME);
		}
	}
}