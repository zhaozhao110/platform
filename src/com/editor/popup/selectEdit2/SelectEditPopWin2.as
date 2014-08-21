package com.editor.popup.selectEdit2
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.containers.ASDataGrid;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * 选择资源 编辑
	 * UIVlist
	 */ 
	public class SelectEditPopWin2 extends AppPopupWithEmptyWin
	{
		public function SelectEditPopWin2()
		{
			super()
			create_init()
		}
		
		public var txt:UILabel ; 
		public var list:UIVlist
		public var input:UITextInputWidthLabel;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 800;
			opts.height = 400;
			opts.title = "选择"	
			return opts;
		}
		
		//程序生成
		private function create_init():void
		{
			//contentArea
			var vb:UIVBox = new UIVBox();
			//vb.background_red = true;
			vb.enabledPercentSize=true
			vb.paddingLeft = 10;
			vb.paddingRight = 10
			vb.paddingBottom = 10;
			addChild(vb);
			
			txt = new UILabel();
			txt.height = 30;
			vb.addChild(txt);
			
			list = new UIVlist();
			list.enabeldSelect = true
			list.doubleClickEnabled = true;
			list.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			list.enabledPercentSize = true;
			list.rowHeight = 30;
			vb.addChild(list);
			
			var hb3:UIHBox = new UIHBox();
			hb3.height = 30;
			hb3.percentWidth = 100;
			vb.addChild(hb3);
			
			input = new UITextInputWidthLabel();
			input.label = "输入ID: ";
			input.height = 30;
			input.width = 300
			hb3.addChild(input);	
			
			initComplete();
		}
				
		override protected function __init__() : void
		{
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.SelectEditPopWin2_sign;
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new SelectEditPopWin2Mediator(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeMediator(SelectEditPopWin2Mediator.NAME);
		}
		
		
	}
}