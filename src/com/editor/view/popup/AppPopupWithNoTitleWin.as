package com.editor.view.popup
{
	import com.editor.manager.DataManager;
	import com.sandy.popupwin.pop.PopupWithNoTitleWin;
	
	public class AppPopupWithNoTitleWin extends PopupWithNoTitleWin
	{
		public function AppPopupWithNoTitleWin()
		{
			super();
			backgroundColor = DataManager.def_col;
		}
	}
}