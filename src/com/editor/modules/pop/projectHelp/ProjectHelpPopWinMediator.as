package com.editor.modules.pop.projectHelp
{
	import com.editor.view.popup.AppDestroyPopupwinMediator;

	public class ProjectHelpPopWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectHelpPopWinMediator"
		public function ProjectHelpPopWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		public function get win():ProjectHelpPopWin
		{
			return viewComponent as ProjectHelpPopWin;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			win.maximize();
		}
	}
}