package com.editor.project_pop.projectSet
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class ProjectSetPopwin extends AppPopupWithEmptyWin
	{
		public function ProjectSetPopwin()
		{
			super()
			create_init();
		}
		
		public var form:UITabBarNav;
		public var tab1:ProjectSetPopwinTab1;
				
		private function create_init():void
		{
			form = new UITabBarNav();
			form.y = 10;
			form.x = 10;
			form.width = 570;
			form.height = 510;
			this.addChild(form);
			
			tab1 = new ProjectSetPopwinTab1();
			tab1.label = "设置1"
			tab1.enabledPercentSize = true;
			form.addChild(tab1);
			tab1.win = this;
						
			initComplete();
			
			form.selectedIndex = 0;
			tab1.reflash();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 600;
			opts.height = 550;
			opts.title = "项目设置"
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= PopupwinSign.ProjectSetPopwin_sign
			isModel    		= true
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ProjectSetPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ProjectSetPopwinMediator.NAME);
		}
		
		
	}
}