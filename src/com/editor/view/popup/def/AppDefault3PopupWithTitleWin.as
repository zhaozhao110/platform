package com.editor.view.popup.def
{
	
	
	import com.editor.view.popup.AppPopupWithTitleWin;
	import com.sandy.popupwin.pop.PopupWithTitleWin;

	public class AppDefault3PopupWithTitleWin extends AppPopupWithTitleWin
	{
		public function AppDefault3PopupWithTitleWin()
		{
			super();
		}
		
		override public function get enabledEffect():Boolean
		{
			return false;
		}
		
		override protected function getContentStyleName():String
		{
			return "default3Popupwin"
		}
		
		override protected function getTiltleBackStyleName():String
		{
			return  ""
		}
		
		override protected function getTitleHBoxWidth():int
		{
			return 193
		}
		override protected function getTitleHBoxHeight():int
		{
			return 22
		}
		
		override protected function getBotButtonBottom():int
		{
			return 8
		}
		
		override protected function getCloseBtnRight():int
		{
			return 5
		}
		
		override protected function getCloseBtnTop():int
		{
			return 2
		}
		
		override protected function getBotButtonColor():*
		{
			return 0xe4ca85;
		}
		
		override protected function getTitleHBoxY():int
		{
			return 2;
		}
		
		override protected function getBotButtonThemeName():String
		{
			return "default2Button"
		}
		
		
	}
}