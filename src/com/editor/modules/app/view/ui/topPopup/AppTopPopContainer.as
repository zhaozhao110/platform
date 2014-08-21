package com.editor.modules.app.view.ui.topPopup
{
	
	import com.sandy.asComponent.controls.*;
	import com.sandy.component.containers.*;
	import com.sandy.component.controls.*;
	import com.sandy.component.controls.text.*;
	import com.sandy.component.core.*;
	import com.sandy.component.expand.*;
	import com.sandy.locale.LocaleManager;
	import com.sandy.popupwin.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class AppTopPopContainer extends TopPopConfirmContainer
	{
		public function AppTopPopContainer()
		{
			super()
			create_init()
		}


		//程序生成
		private function create_init():void
		{
			
			//主文件的属性
			this.enabledPercentSize=true;
			
			
			
			//dispatchEvent creationComplete
			initComplete();
		}

		
	}
}