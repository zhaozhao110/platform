package com.editor.module_html
{
	import com.editor.mediator.UIModule2Mediator;
	import com.editor.module_html.mediator.HtmlModuleContentMediator;
	import com.editor.module_html.mediator.HtmlModuleToolBarMediator;
	import com.editor.module_html.view.HtmlModuleContent;
	import com.editor.module_html.view.HtmlModuleToolBar;
	import com.editor.vo.global.AppGlobalConfig;
	
	import flash.utils.setTimeout;
	
	public class HtmlModuleMediator extends UIModule2Mediator
	{
		public static const NAME:String = "HtmlModuleMediator"
		public function HtmlModuleMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get html():HtmlModule
		{
			return viewComponent as HtmlModule;
		}
		public function get toolBar():HtmlModuleToolBar
		{
			return html.toolBar;
		}
		public function get htmlCont():HtmlModuleContent
		{
			return html.cont;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new HtmlModuleToolBarMediator(toolBar));
			registerMediator(new HtmlModuleContentMediator(htmlCont));
			
			setTimeout(checkFirstOpenURL,1000)
		}
		
		private function checkFirstOpenURL():void
		{
			if(get_HtmlModuleContentMediator().nav.getTabLength()==0){
				get_HtmlModuleToolBarMediator().text.text = AppGlobalConfig.instance.help_website;
				get_HtmlModuleContentMediator().addPage(AppGlobalConfig.instance.help_website);
			}
		}
		
		private function get_HtmlModuleToolBarMediator():HtmlModuleToolBarMediator
		{
			return retrieveMediator(HtmlModuleToolBarMediator.NAME) as HtmlModuleToolBarMediator;
		}
		
		private function get_HtmlModuleContentMediator():HtmlModuleContentMediator
		{
			return retrieveMediator(HtmlModuleContentMediator.NAME) as HtmlModuleContentMediator;
		}
		
	}
}