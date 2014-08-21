package com.editor.module_html.html
{
	import com.air.component.SandyHtmlLoader;
	import com.editor.component.containers.UICanvas;
	import com.sandy.event.SandyEvent;
	import com.sandy.utils.StringTWLUtil;

	public class HtmlModulePage extends UICanvas
	{
		public function HtmlModulePage()
		{
			super();
			create_init();
		}
		
		private var html:SandyHtmlLoader;
		public var webURL:String;
		
		public function getTitle():String
		{
			if(html!=null){
				return html.webTitle;
			}
			return "";
		}
		
		private function create_init():void
		{
			enabledPercentSize = true;
			
			html = new SandyHtmlLoader();
			html.addEventListener(SandyHtmlLoader.TITLECHANGE , onTitleChangeHandle) 
			html.enabledPercentSize = true;
			addChild(html);
		}
				
		public function setURL(url:String):void
		{
			webURL = url;
			html.loadURL(url);
		}
		
		public function reflashPage(url:String=""):void
		{
			if(StringTWLUtil.isWhitespace(url)){
				setURL(webURL);
			}else{
				setURL(url);
			}
		}
		
		private function onTitleChangeHandle(e:SandyEvent):void
		{
			label = String(e.data);
		}
		
		
	}
}