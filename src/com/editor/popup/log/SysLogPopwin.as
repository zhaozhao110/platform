package com.editor.popup.log
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.air.utils.AIRUtils;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	public class SysLogPopwin extends AppPopupWithEmptyWin
	{
		public function SysLogPopwin()
		{
			super()
			create_init();
		}
		
		
		public var textInput:UITextArea;
		
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			form.verticalGap = 10;
			form.y = 10;
			form.padding = 5;
			form.width = Screen.mainScreen.visibleBounds.width-30;
			form.height = Screen.mainScreen.visibleBounds.height-100
			this.addChild(form);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			form.addChild(hb);
			
			textInput = new UITextArea();
			textInput.alwaysShowSelection = true;
			textInput.enabledPercentSize = true;
			textInput.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			textInput.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(textInput);
						
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = Screen.mainScreen.visibleBounds.width;
			opts.minimizable = true;
			opts.maximizable = true
			opts.height = Screen.mainScreen.visibleBounds.height;
			opts.title = "system log"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.AppLogPopupwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new SysLogPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(SysLogPopwinMediator.NAME)
		}
		
	}
}