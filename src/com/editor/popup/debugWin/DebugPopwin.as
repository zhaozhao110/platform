package com.editor.popup.debugWin
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.profiler.SandyLogPopupwin;
	
	import flash.display.NativeWindowType;

	public class DebugPopwin extends AppPopupWithEmptyWin
	{
		public function DebugPopwin()
		{
			super()
			create_init();
		}
		
		private function create_init():void
		{
			var win:SandyLogPopupwin = new SandyLogPopupwin();
			addChild(win);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 820;
			opts.height = 450;
			opts.title = "debug - log"
			//opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= PopupwinSign.DebugPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new DebugPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(DebugPopwinMediator.NAME);
		}
		
	}
}