package com.editor.modules.app.view.ui.popup
{
	import	com.sandy.popupwin.*;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;

	public class AppPopupContainer extends PopupwinContainer
	{
		public function AppPopupContainer()
		{
			super()
			create_init()
		}
		
		//程序生成
		private function create_init():void
		{
			//主文件的属性
			this.enabledPercentSize=true

			//dispatchEvent creationComplete
			initComplete();
		}

	}
}