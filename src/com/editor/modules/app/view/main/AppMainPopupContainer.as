package com.editor.modules.app.view.main
{
	import com.editor.component.containers.UICanvas;
	import com.editor.modules.app.view.ui.popup.AppPopupContainer;
	import com.editor.modules.app.view.ui.topPopup.AppTopPopContainer;
	import com.sandy.asComponent.controls.ASAdaptaTextArea;
	

	public class AppMainPopupContainer extends UICanvas
	{
		public function AppMainPopupContainer()
		{
			super();
			create_init();
		}
		
		public var popup:AppPopupContainer;
		public var topPopup:AppTopPopContainer;
		
		private function create_init():void
		{
			enabledPercentSize = true
						
			popup = new AppPopupContainer();
			addChild(popup);
			
			topPopup = new AppTopPopContainer();
			addChild(topPopup);
			
			/*var txt:ASAdaptaTextArea = new ASAdaptaTextArea();
			txt.heightAdapta = true;
			txt.htmlText = "1231123123123123123"
			txt.width = 180;
			txt.paddingLeft = 10;
			txt.paddingRight = 10;
			txt.paddingBottom =30;
			txt.paddingTop = 10;
			txt.color = 0x003903;
			txt.editable = false;
			txt.leading = 3;
		
			addChild(txt);*/
			
			initComplete();
		}
		
		
		
	}
}