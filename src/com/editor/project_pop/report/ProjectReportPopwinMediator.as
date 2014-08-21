package com.editor.project_pop.report
{
	import com.editor.view.popup.AppDestroyPopupwinMediator;

	public class ProjectReportPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectReportPopwinMediator"
		public function ProjectReportPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():ProjectReportPopwin
		{
			return viewComponent as ProjectReportPopwin
		}
		public function get tab1():ProjectReportTab1
		{
			return resWin.tab1;
		}
		public function get tab2():ProjectReportTab2
		{
			return resWin.tab2;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			//showMessage("打开检测报告之前，"
		}
		
		
	}
}