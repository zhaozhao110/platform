package com.editor.popup.debugWin
{
	import com.editor.view.popup.AppDestroyPopupwinMediator;

	public class DebugPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "DebugPopwinMediator"
		public function DebugPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
	}
}