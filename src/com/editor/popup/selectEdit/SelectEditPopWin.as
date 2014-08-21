package com.editor.popup.selectEdit
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.containers.ASDataGrid;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.common.bind.field.bool.TRUE;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * 选择资源 编辑
	 * UITabBar + SandyDataGrid 
	 */ 
	public class SelectEditPopWin extends AppPopupWithEmptyWin
	{
		public function SelectEditPopWin()
		{
			super()
			create_init()
		}
		
		
		public var tabBar:UITabBar;
		public var listDG:SandyDataGrid;
		public var input:UITextInputWidthLabel;
				
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 800;
			opts.height = 400;
			opts.title = "编辑动画"	
			return opts;
		}
		
		//程序生成
		private function create_init():void
		{
			
			//contentArea
			var gdpsvbox2:UIVBox = new UIVBox();
			gdpsvbox2.enabledPercentSize=true
			gdpsvbox2.paddingLeft = 10;
			gdpsvbox2.paddingRight = 10
			gdpsvbox2.paddingBottom = 5;
			addChild(gdpsvbox2);
			
			tabBar = new UITabBar();
			tabBar.labelField="type_str"
			tabBar.tabHeight=19;
			tabBar.height = 20;
			tabBar.enabled_anchor = true;
			gdpsvbox2.addChild(tabBar);
			
			listDG = new SandyDataGrid();
			listDG.enabledPercentSize = true
			listDG.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			gdpsvbox2.addChild(listDG);
			
			var columns3:Array = []
			
			var datagridcolumn4:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn4.headerText="ID"
			datagridcolumn4.dataField="id"
			datagridcolumn4.columnWidth = 150
			columns3.push(datagridcolumn4);
			
			var datagridcolumn5:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn5.headerText="名称"
			datagridcolumn5.columnWidth = 620
			datagridcolumn5.dataField="name"
			columns3.push(datagridcolumn5);
			
			listDG.columns = columns3;
			
			var hb3:UIHBox = new UIHBox();
			hb3.height = 30;
			hb3.percentWidth = 100;
			gdpsvbox2.addChild(hb3);
			
			input = new UITextInputWidthLabel();
			input.label = "输入ID: ";
			input.height = 30;
			input.width = 200
			hb3.addChild(input);	
			
			initComplete();
		}
				
		override protected function __init__() : void
		{
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.SelectEditPopWin_sign;
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new SelectEditPopWinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(SelectEditPopWinMediator.NAME);
		}
		
		
	}
}