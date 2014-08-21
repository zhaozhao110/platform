package com.editor.project_pop.selectProject
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.NativeWindowType;

	/**
	 * 选择项目
	 */ 
	public class SelectProjectPopwin extends AppPopupWithEmptyWin
	{
		public function SelectProjectPopwin()
		{
			super()
			create_init()
		}
		
		
		public var originalTI:UILabel;
		public var projectCB:UICombobox;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 300;
			opts.height = 150;
			opts.title = "选择编辑的项目"	
			return opts;
		}
		
		//程序生成
		private function create_init():void
		{
			
			//contentArea
			var gdpsvbox19:UIHBox = new UIHBox();
			gdpsvbox19.width = 280 ;
			gdpsvbox19.height = 90
			gdpsvbox19.paddingTop = 10;
			gdpsvbox19.paddingLeft = 10;
			gdpsvbox19.horizontalAlign = ASComponentConst.horizontalAlign_center;
			addChild(gdpsvbox19);
			
			originalTI = new UILabel();
			originalTI.text="选择编辑项目: "
			gdpsvbox19.addChild(originalTI);
			
			projectCB = new UICombobox();
			projectCB.width = 180
			projectCB.height = 25;
			gdpsvbox19.addChild(projectCB);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		
		override protected function __init__() : void
		{
			useDefaultBotButton = true
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.SelectProjectPopwin_sign;
			isModel    		= true;
			
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new SelectProjectPopwinMediator(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeMediator(SelectProjectPopwinMediator.NAME);
		}
		
		
	}
}