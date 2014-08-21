package com.editor.popup.diary
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;

	public class DiaryPopwin extends AppPopupWithEmptyWin
	{
		public function DiaryPopwin()
		{
			super()
			create_init()
		}
		
		public var txt:UITextArea;
		
		private function create_init():void
		{
			var cont:UICanvas = new UICanvas();
			cont.width = 650;
			cont.height = 300;
			addChild(cont);
			
			var img:UIImage = new UIImage();
			img.source = "assets/img/help.jpg";
			cont.addChild(img);
			
			txt = new UITextArea();
			txt.width = 540 
			txt.height = 120;
			txt.y = 140;
			txt.x = 50;
			txt.editable = false;
			txt.fontSize = 14;
			txt.leading = 6;
			txt.color = ColorUtils.white;
			txt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			cont.addChild(txt);
			txt.styleName = null
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.systemChrome = NativeWindowSystemChrome.NONE;
			opts.transparent = true;
			opts.type = NativeWindowType.UTILITY;
			opts.width = 650;
			opts.height = 300;
			opts.title = "dialog"	
			return opts;
		}
		
		override protected function __init__() : void
		{
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.AboutPopwin_sign;
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new AboutPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AboutPopwinMediator.NAME);
		}
	}
}