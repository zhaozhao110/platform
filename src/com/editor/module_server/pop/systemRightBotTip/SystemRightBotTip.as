package com.editor.module_server.pop.systemRightBotTip
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.MouseEvent;

	public class SystemRightBotTip extends UICanvas
	{
		public function SystemRightBotTip()
		{
			super();
			create_init();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 255;
			opts.height = 180;	
			opts.title = "engine平台消息"
			opts.x = Screen.mainScreen.visibleBounds.width-opts.width;
			opts.y = Screen.mainScreen.visibleBounds.height-opts.height-20;
			return opts;
		}
		
		private var txt:UITextArea;
		private var btn:UIButton;
		
		private function create_init():void
		{
			txt = new UITextArea();
			txt.editable = false;
			txt.width = 235;
			txt.height = 110;
			txt.x = 5;
			txt.y = 5;
			addChild(txt);
			txt.styleName = null;
			
			btn = new UIButton();
			btn.label = "查看"
			btn.x = 200;
			btn.y = 120;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK , onBtnClick)
			btn.visible = false;
		}
		
		public function setItem(item:SystemRightTipVO):void
		{
			data = item;
			txt.htmlText = item.info;
			if(!StringTWLUtil.isWhitespace(item.btn_label)){
				btn.visible = true;
				btn.label = item.btn_label;
			}
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			SystemRightTipVO(data).btn_fun();
			nativeWindow.close();
		}
		
	}
}