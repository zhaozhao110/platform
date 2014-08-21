package com.editor.view.popup.popHtml
{
	import com.air.component.SandyHtmlLoader;
	import com.editor.component.containers.UICanvas;
	import com.sandy.asComponent.effect.tween.ASTween;
	import com.sandy.utils.StringTWLUtil;
	
	public class AppPopHtmlContainer extends UICanvas
	{
		public function AppPopHtmlContainer()
		{
			super();
			create_init();
		}
		
		private var html:SandyHtmlLoader;
		
		private function create_init():void
		{
			
			html = new SandyHtmlLoader();
			addChild(html);
			
			visible = false;
		}
		
		public function setURL(url:String,_w:Number,_h:Number):void
		{
			if(StringTWLUtil.isWhitespace(url)) return ;
			html.width 	= _w;
			html.height = _h;
			html.loadURL(url); 
		}
		
		public function show():void
		{
			alpha = 0;
			x = 0;
			y = -300
			visible = true;
			
			ASTween.to(this,.5,{y:0,alpha:1});
		}
		
		public function hide():void
		{
			ASTween.to(this,.5,{y:-300,alpha:0,onComplete:hideComplete});
		}
		
		private function hideComplete():void
		{
			visible = false;
		}
		
	}
}