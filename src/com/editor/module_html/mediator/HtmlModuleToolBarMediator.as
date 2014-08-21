package com.editor.module_html.mediator
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.event.AppEvent;
	import com.editor.mediator.AppMediator;
	import com.editor.module_html.view.HtmlModuleToolBar;
	import com.editor.module_html.vo.OpenWebPageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class HtmlModuleToolBarMediator extends AppMediator
	{	
		public static const NAME:String = "HtmlModuleToolBarMediator";
		public function HtmlModuleToolBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get toolbar():HtmlModuleToolBar
		{
			return viewComponent as HtmlModuleToolBar;
		}
		public function get reflashBtn():UIAssetsSymbol
		{
			return toolbar.reflashBtn;
		}
		public function get gotoBtn():UIAssetsSymbol
		{
			return toolbar.gotoBtn;
		}
		public function get text():UITextInputWidthLabel
		{
			return toolbar.text;
		}
		public function get addBtn():UIAssetsSymbol
		{
			return toolbar.addBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			text.enterKeyDown_proxy = reactToGotoBtnClick
		}
		
		public function reactToReflashBtnClick(e:MouseEvent):void
		{
			get_HtmlModuleContentMediator().reflashPage();
		}
		
		public function reactToGotoBtnClick(e:MouseEvent=null):void
		{
			get_HtmlModuleContentMediator().reflashPage(text.text);
		}
		
		public function reactToAddBtnClick(e:MouseEvent=null):void
		{
			get_HtmlModuleContentMediator().addPage(text.text);
		}
			
		public function respondToOpenWebsiteEvent(noti:Notification):void
		{
			text.text = OpenWebPageData(noti.getBody()).webURL;
		}
		
		private function get_HtmlModuleContentMediator():HtmlModuleContentMediator
		{
			return retrieveMediator(HtmlModuleContentMediator.NAME) as HtmlModuleContentMediator;
		}
	}
}