package com.editor.view.popup
{
	import com.editor.manager.DataManager;
	import com.sandy.popupwin.pop.AlonePopWithEmptyWin;
	
	public class AppAlonePopWithEmptyWin extends AlonePopWithEmptyWin
	{
		public function AppAlonePopWithEmptyWin()
		{
			super();
			backgroundColor = DataManager.def_col;
		}
		
		override protected function getBotButtonBottom():int
		{
			return 10;
		}
	}
}