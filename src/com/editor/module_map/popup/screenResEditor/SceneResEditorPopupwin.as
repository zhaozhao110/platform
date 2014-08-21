package com.editor.module_map.popup.screenResEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.NativeWindowType;

	public class SceneResEditorPopupwin extends AppPopupWithEmptyWin
	{
		public var input1:UITextInput;
		public var input2:UITextInput;
		public var input3:UITextInput;
		public var input4:UITextInput;
		public var input5:UITextInput;
		public var input6:UITextInput;
		
		public var btn4:UIButton;
		
		public var mcContainer:UICanvas;
		
		public function SceneResEditorPopupwin()
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			var txt1:UIText = new UIText();
			txt1.x = 10; txt1.y = 20;
			txt1.htmlText = "<textformat leading='20'><b>ID：<br>场景ID：<br>索引：<br>文件：<br>X：<br>Y：</b></textformat>";
			addChild(txt1);
			
			input1 = new UITextInput();
			input1.x = 80; input1.y = 18;
			input1.width = 100; input1.height = 24;
			addChild(input1);
			
			input2 = new UITextInput();
			input2.x = 80; input2.y = 54;
			input2.width = 100; input2.height = 24;
			addChild(input2);
			
			input3 = new UITextInput();
			input3.x = 80; input3.y = 90;
			input3.width = 100; input3.height = 24;
			input3.restrict = "1-9";
			addChild(input3);
			
			input4 = new UITextInput();
			input4.x = 80; input4.y = 126;
			input4.width = 100; input4.height = 24;
			input4.editable = false;
			addChild(input4);
			
			input5 = new UITextInput();
			input5.x = 80; input5.y = 160;
			input5.width = 100; input5.height = 24;
			input5.restrict = "1-9";
			addChild(input5);
			
			input6 = new UITextInput();
			input6.x = 80; input6.y = 195;
			input6.width = 100; input6.height = 24;
			input6.restrict = "1-9";
			addChild(input6);
			
			btn4 = new UIButton();
			btn4.x = 190; btn4.y = 126;
			btn4.width = 40; btn4.height = 24;
			btn4.label = "选择";
			addChild(btn4);
			
			mcContainer = new UICanvas();
			mcContainer.x = 240; mcContainer.y = 20;
			mcContainer.width = 340; mcContainer.height = 300;
			mcContainer.backgroundColor = 0x999999;
			mcContainer.horizontalScrollPolicy = "auto";
			mcContainer.verticalScrollPolicy = "off";
			addChild(mcContainer);
			
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type 			= NativeWindowType.UTILITY;
			opts.resizable 		= true
			opts.width 			= 600
			opts.height 		= 400
			opts.title 			= "场景特效";
			return opts;
		}
		
		override protected function __init__():void
		{
			popupSign  		= PopupwinSign.MapScreenResEditorPopupwin_sign;
			isModel    		= true;
			enabledDrag    	= true;
			useDefaultBotButton = true;
			
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new SceneResEditorPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(SceneResEditorPopupwinMediator.NAME);
		}
		
		override public function forceActivate():void
		{
			super.forceActivate();
		}
		
		
	}
}