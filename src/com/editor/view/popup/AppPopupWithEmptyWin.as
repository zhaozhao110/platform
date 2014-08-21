package com.editor.view.popup
{
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_html.vo.OpenWebPageData;
	import com.editor.view.popup.popHtml.AppPopHtmlContainer;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.popupwin.pop.PopupWithEmptyWin;
	import com.sandy.popupwin.pop.PopupWithNoTitleWin;
	import com.sandy.utils.StringTWLUtil;
	
	public class AppPopupWithEmptyWin extends PopupWithNoTitleWin
	{
		public function AppPopupWithEmptyWin()
		{
			super();
			backgroundColor = DataManager.def_col;
		}
		
		override protected function getBotButtonBottom():int
		{
			return 10;
		}
		
		/*override protected function getBottomButtonToolContainerClass():Class
		{
			//return AppyPopupBottomButtonToolContainer;
		}*/
		
		public var htmlContainer:AppPopHtmlContainer
		
		override protected function __init__():void
		{
			super.__init__();
		
			topContainer.clipContent = true;
						
			htmlContainer = new AppPopHtmlContainer();
			addTopContainerChild(htmlContainer);
		}
		
		override protected function createDefaultBotButtonContainer():void
		{
			super.createDefaultBotButtonContainer();
			if(botButtonContainer is AppyPopupBottomButtonToolContainer){
				AppyPopupBottomButtonToolContainer(botButtonContainer).openHelp_f = openHelp;
				AppyPopupBottomButtonToolContainer(botButtonContainer).openFullHelp_f = openFullHelp;
			}
		}
		
		private function openHelp():void
		{
			if(StringTWLUtil.isWhitespace(getHelpURL())) return ;
			if(htmlContainer.visible){
				htmlContainer.hide();
				return ;
			}
			htmlContainer.show();
			htmlContainer.setURL(getHelpURL(),this.width,botButtonContainer.y);
		}
		
		protected function getHelpURL():String
		{
			if(StringTWLUtil.isWhitespace(OpenPopwinData(item).addData)) return "";
			return AppGlobalConfig.instance.help_website+"?id=" + OpenPopwinData(item).addData;
		}
		
		protected function openFullHelp():void
		{
			if(StringTWLUtil.isWhitespace(OpenPopwinData(item).addData)) return;
			var d:OpenWebPageData = new OpenWebPageData();
			d.webURL = getHelpURL();
			sendAppNotification(AppEvent.openWebsite_event,d);
			closeWin();
		}
		
	}
}