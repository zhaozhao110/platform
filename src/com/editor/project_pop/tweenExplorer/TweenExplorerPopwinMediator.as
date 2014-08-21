package com.editor.project_pop.tweenExplorer
{
	import com.editor.view.popup.AppDestroyPopupwinMediator;

	public class TweenExplorerPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "TweenExplorerPopwinMediator"
		public function TweenExplorerPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get win():TweenExplorerPopwin
		{
			return viewComponent as TweenExplorerPopwin
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
	}
}