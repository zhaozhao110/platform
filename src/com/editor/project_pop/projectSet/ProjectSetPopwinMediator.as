package com.editor.project_pop.projectSet
{
	import com.editor.model.AppMainModel;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class ProjectSetPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectSetPopwinMediator"
		public function ProjectSetPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get setWin():ProjectSetPopwin
		{
			return viewComponent as ProjectSetPopwin;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToParserProjectCompleteEvent(noti:Notification):void
		{
			setWin.tab1.reflash_btn.visible = true
			if(AppMainModel.getInstance().projectSet_parseing){
				showMessage("刷新项目缓存已经完成");
			}
			AppMainModel.getInstance().projectSet_parseing = false
		}
	}
}