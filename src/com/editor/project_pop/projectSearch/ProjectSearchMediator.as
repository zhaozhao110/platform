package com.editor.project_pop.projectSearch
{
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class ProjectSearchMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectSearchMediator"
		public function ProjectSearchMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():ProjectSearchPopwin
		{
			return viewComponent as ProjectSearchPopwin
		}
				
		override public function onRegister():void
		{
			super.onRegister();
			
			
		}
		
	}
}