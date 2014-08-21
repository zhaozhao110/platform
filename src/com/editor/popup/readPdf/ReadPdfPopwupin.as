package com.editor.popup.readPdf
{
	import com.air.component.SandyHtmlLoader;
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIVBox;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import feathers.controls.Screen;
	
	import flash.display.NativeWindowType;

	public class ReadPdfPopwupin extends AppPopupWithEmptyWin
	{
		public function ReadPdfPopwupin()
		{
			super()
			create_init();
		}
		
		private function create_init():void
		{
			form = new UIVBox();
			form.padding = 5;
			form.width = 1050
			form.height = 670
			this.addChild(form);
			
			html = new SandyHtmlLoader();
			html.styleName = "uicanvas"
			html.width = 1050;
			html.height = 630
			form.addChild(html);
			
			toolBar = new ReadPdfPopToolBar();
			form.addChild(toolBar);
			
			initComplete();
		}
		
		override public function sizeChange(_force:Boolean=false):void
		{
			super.sizeChange(_force);
			if(form == null) return ;
			form.width = width;
			form.height = height-30
		}
		
		private var form:UIVBox;
		public var html:SandyHtmlLoader;
		public var toolBar:ReadPdfPopToolBar;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.transparent = false;
			opts.width = 1050
			opts.minimizable = true;
			opts.maximizable = true
			opts.height = 700
			opts.title = "readPdf"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.ReadPdfPopwupin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ReadPdfPopwupinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ReadPdfPopwupinMediator.NAME)
		}
		
	}
}