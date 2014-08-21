package com.editor.module_gdps.login
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.pop.project.LoginProjectPopwin;
	import com.editor.module_gdps.pop.project.LoginProjectPopwinMediator;

	public class GDPSLoginPopwinMediator extends AppMediator
	{
		public static const NAME:String = "GDPSLoginPopwinMediator";
		
		public function GDPSLoginPopwinMediator(viewComponent:*=null)
		{
			super(NAME,viewComponent);
		}
		public function get content():GDPSLoginPopwin
		{
			return viewComponent as GDPSLoginPopwin;
		}
		public function get loginCell():GdpsLoginCell
		{
			return content.loginCell;
		}
		public function get projectCell():LoginProjectPopwin
		{
			return content.projectCell;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new GdpsLoginCellMediator(loginCell));
			registerMediator(new LoginProjectPopwinMediator(projectCell));
		}
	}
}