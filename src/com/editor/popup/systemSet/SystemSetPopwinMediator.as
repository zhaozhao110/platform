package com.editor.popup.systemSet
{
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	
	public class SystemSetPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SystemSetPopwinMediator"
		public function SystemSetPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get editWin():SystemSetPopwin
		{
			return viewComponent as SystemSetPopwin;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			SystemSetPopwinTab4.isChange = false;
		}
		
	}
}