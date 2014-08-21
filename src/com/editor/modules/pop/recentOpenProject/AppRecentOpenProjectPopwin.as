package com.editor.modules.pop.recentOpenProject
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;

	//最近打开的项目列表
	public class AppRecentOpenProjectPopwin extends AppPopupWithEmptyWin
	{
		public function AppRecentOpenProjectPopwin()
		{
			super()
			create_init();
		}
		
		public var uiList:UIVlist;
		
		private function create_init():void
		{
			uiList = new UIVlist();
			uiList.styleName = "list"
			uiList.doubleClickEnabled = true;
			uiList.enabeldSelect = true
			uiList.itemRenderer = AppRecentOpenProjectItemRenderer;
			uiList.enabledPercentSize = true;
			addChild(uiList);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 250;
			opts.title = "最近打开项目列表"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.AppRecentOpenProjectPopwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppRecentOpenProjectPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppRecentOpenProjectPopwinMediator.NAME)
		}
		
	}
}