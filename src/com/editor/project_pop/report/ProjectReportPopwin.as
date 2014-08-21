package com.editor.project_pop.report
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UITabBarNav;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class ProjectReportPopwin extends AppPopupWithEmptyWin
	{
		public function ProjectReportPopwin()
		{
			super()
			create_init();
		}
		
		public var form:UITabBarNav;
		public var tab1:ProjectReportTab1;
		public var tab2:ProjectReportTab2;
		
		
		private function create_init():void
		{
			form = new UITabBarNav();
			form.y = 10;
			form.x = 10;
			form.width = 980;
			form.height = 650;
			this.addChild(form);
			
			tab1 = new ProjectReportTab1();
			tab1.label = "检测报告1"
			tab1.enabledPercentSize = true;
			form.addChild(tab1);
			
			tab2 = new ProjectReportTab2();
			tab2.label = "检测报告2"
			tab2.enabledPercentSize = true;
			form.addChild(tab2);
			
			form.selectedIndex = 0;
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 1000;
			opts.height = 700;
			opts.title = "项目检测报告"
			opts.minimizable = true
			opts.resizable = true;
			opts.maximizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= PopupwinSign.ProjectReportPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ProjectReportPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ProjectReportPopwinMediator.NAME);
		}
		
		
	}
}