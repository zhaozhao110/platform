package com.editor.project_pop.projectSearch
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	
	public class ProjectSearchPopwin extends AppPopupWithEmptyWin
	{
		public function ProjectSearchPopwin()
		{
			super()
			create_init();
		}
		
		public var tabNav:UITabBarNav;
		public var tab1:ProjectSearchPopwinTab1;
		public var tab2:ProjectSearchPopwinTab2;
		public var tab3:ProjectSearchPopwinTab3;
				
		private function create_init():void
		{
			tabNav = new UITabBarNav();
			tabNav.y = 10;
			tabNav.x = 10;
			tabNav.width = 360;
			tabNav.height = 440
			this.addChild(tabNav);
						
			tab2 = new ProjectSearchPopwinTab2();
			tab2.label = "本地搜索"
			tabNav.addChild(tab2);
			tab2.win = this;
			
			tab1 = new ProjectSearchPopwinTab1();
			tab1.label = "全局搜索"
			tabNav.addChild(tab1);
			tab1.win = this;
			
			tab3 = new ProjectSearchPopwinTab3();
			tab3.label = "文件搜索"
			tabNav.addChild(tab3);
			tab3.win = this;
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL
			opts.width = 400;
			opts.height = 500;
			opts.title = "搜索"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			//useDefaultBotButton = true
			popupSign  		= PopupwinSign.ProjectSearchPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ProjectSearchMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ProjectSearchMediator.NAME)
		}
	}
}