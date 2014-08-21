package com.editor.module_html.mediator
{
	import com.editor.component.controls.UITabBarNav;
	import com.editor.mediator.AppMediator;
	import com.editor.module_html.html.HtmlModulePage;
	import com.editor.module_html.view.HtmlModuleContent;
	import com.editor.module_html.vo.OpenWebPageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	public class HtmlModuleContentMediator extends AppMediator
	{	
		public static const NAME:String = "HtmlModuleContentMediator";
		public function HtmlModuleContentMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get htmlCont():HtmlModuleContent
		{
			return viewComponent as HtmlModuleContent;
		}
		public function get nav():UITabBarNav
		{
			return htmlCont.nav;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToOpenWebsiteEvent(noti:Notification):void
		{
			var d:OpenWebPageData = noti.getBody() as OpenWebPageData;
			if(d.target == OpenWebPageData.OPENWEB_BLANK){
				addPage(d.webURL)
			}else if(d.target == OpenWebPageData.OPENWEB_SELF){
				reflashPage(d.webURL);
			}
		}
		
		public function addPage(url:String):void
		{
			if(StringTWLUtil.isWhitespace(url)) return ;
			var page:HtmlModulePage = new HtmlModulePage();
			page.label = "page1"
			nav.addChild(page);
			page.setURL(url);
		}
		
		public function getHTML_ls():Array
		{
			var out:Array = [];
			var total:int = nav.getTabLength();
			for(var i:int=0;i<total;i++){
				var page:HtmlModulePage = nav.getChildAt(i) as HtmlModulePage;
				out[i.toString()] = page.webURL;
			}
			return out;
		}
				
		public function reflashPage(url:String=""):void
		{
			var selectPage:HtmlModulePage = nav.getSelectedContent() as HtmlModulePage;
			if(selectPage!=null){
				selectPage.reflashPage(url);
			}
		}
	}
}