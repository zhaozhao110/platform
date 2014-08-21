package com.editor.popup.editImage
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.display.Screen;

	public class EditImagePopwin extends AppPopupWithEmptyWin
	{
		public function EditImagePopwin()
		{
			super()
			create_init();
		}
		
		public var tabNav:UITabBarNav;
		public var tab1:EditImagePopwinTab1;
		public var tab2:EditImagePopwinTab2;
		public var tab3:EditImagePopwinTab3;
		
		private function create_init():void
		{
			tabNav = new UITabBarNav();
			tabNav.y = 10;
			tabNav.x = 10;
			tabNav.width = Screen.mainScreen.visibleBounds.width-30;
			tabNav.height = Screen.mainScreen.visibleBounds.height-100
			this.addChild(tabNav);
			tabNav.creationPolicy = ASComponentConst.creationPolicy_none;
			
			tab1 = new EditImagePopwinTab1();
			tab1.label = "图片拼接"
			tab1.enabledPercentSize = true;
			tabNav.addChild(tab1);
			
			tab2 = new EditImagePopwinTab2();
			tab2.label = "图片切割"
			tab2.enabledPercentSize = true;
			tabNav.addChild(tab2);
			
			tab3 = new EditImagePopwinTab3();
			tab3.label = "转atf"
			tab3.enabledPercentSize = true;
			tabNav.addChild(tab3);
						
			tabNav.selectedIndex = 0;
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = Screen.mainScreen.visibleBounds.width;
			opts.minimizable = true;
			opts.maximizable = true
			opts.height = Screen.mainScreen.visibleBounds.height;
			opts.title = "编辑图片"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.EditImagePopwin_sign
			isModel    		= false
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new EditImagePopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			tab3.delPopwin();
			super.delPopwin()
			removeMediator(EditImagePopwinMediator.NAME);
		}
		
		
	}
}