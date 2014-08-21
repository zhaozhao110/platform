package com.editor.modules.pop.projectHelp
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.model.PopupwinSign;
	import com.editor.modules.pop.projectHelp.view.ProjectHelpTreeTab;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	import flash.display.Screen;

	public class ProjectHelpPopWin extends AppPopupWithEmptyWin
	{
		public function ProjectHelpPopWin()
		{
			super()
			create_init();
		}
		
		public var tabNav:UITabBarNav;
		public var treeTab:ProjectHelpTreeTab;
		
		private function create_init():void
		{
			var can:UIVBox = new UIVBox();
			can.width = Screen.mainScreen.visibleBounds.width-100;
			can.height = Screen.mainScreen.visibleBounds.height-100;
			can.x = 10;
			can.y = 10;
			can.paddingBottom = 2;
			addChild(can);
			
			tabNav = new UITabBarNav();
			tabNav.enabledPercentSize =true;
			can.addChild(tabNav);
			
			treeTab = new ProjectHelpTreeTab();
			treeTab.label = "结构图"
			tabNav.addChild(treeTab);
			
			tabNav.selectedIndex = 0;
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 1050;
			opts.height = 680;
			opts.maximizable = true
			opts.resizable = false;
			opts.title = "项目结构帮助"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.ProjectHelpPopWin_sign;;
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ProjectHelpPopWinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ProjectHelpPopWinMediator.NAME)
		}
		
	}
}