package com.editor.project_pop.getLocale
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class AppGetLocaleWin extends AppPopupWithEmptyWin
	{
		public function AppGetLocaleWin()
		{
			super()
			create_init()
		}
		
		public var tab1:AppGetLocaleTab1;
		public var tab2:AppGetLocaleTab2;
		public var tab3:AppGetLocaleTab3;
		
		private function create_init():void
		{			
			var tabNav:UITabBarNav = new UITabBarNav();
			tabNav.y = 10;
			tabNav.x = 10;
			tabNav.width = 980;
			tabNav.height = 650;
			addChild(tabNav);
			
			tab1 = new AppGetLocaleTab1();
			tab1.label = "提取汉字"
			tab1.enabledPercentSize = true;
			tabNav.addChild(tab1);
			
			tab2 = new AppGetLocaleTab2();
			tab2.label = "打勾需要翻译的资源"
			tab2.enabledPercentSize = true;
			tabNav.addChild(tab2);
			
			tab3 = new AppGetLocaleTab3();
			tab3.label = "log"
			tab3.enabledPercentSize = true;
			tabNav.addChild(tab3);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 1000;
			opts.height = 700;
			opts.title = "多国语言翻译工具"	
			opts.minimizable = true
			return opts;
		}
		
		override protected function __init__() : void
		{
			useDefaultBotButton = false
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.AppGetLocaleWin_sign
			isModel    		= false;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new AppGetLocaleWinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppGetLocaleWinMediator.NAME);
		}
		
	}
}