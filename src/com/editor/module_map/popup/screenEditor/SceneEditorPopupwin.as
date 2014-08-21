package com.editor.module_map.popup.screenEditor
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.*;
	
	public class SceneEditorPopupwin extends AppPopupWithEmptyWin
	{
		public var input1:UITextInput;
		public var input2:UITextInput;
		public var input3:UITextInput;
		public var input4:UITextInput;
		public var input5:UITextArea;
		
		public var btn3:UIButton;
		public var img3:UIImage;
		
		public function SceneEditorPopupwin()
		{
			super();
			create_init();
		}
		
		private function create_init():void
		{
			var txt1:UIText = new UIText();
			txt1.x = 10; txt1.y = 20;
			txt1.htmlText = "<textformat leading='20'><b>ID：<br>X：<br>Y：<br>左右速度：<br>上下序列：</b></textformat>";
			addChild(txt1);
			
			input1 = new UITextInput();
			input1.x = 80; input1.y = 18;
			input1.width = 100; input1.height = 24;
			addChild(input1);
			
			input2 = new UITextInput();
			input2.x = 80; input2.y = 54;
			input2.width = 100; input2.height = 24;
			input2.restrict = "0-9";
			addChild(input2);
			
			input3 = new UITextInput();
			input3.x = 80; input3.y = 90;
			input3.width = 100; input3.height = 24;
			input3.restrict = "0-9";
			addChild(input3);
			
			input4 = new UITextInput();
			input4.x = 80; input4.y = 126;
			input4.width = 100; input4.height = 24;
			input4.restrict = "0-9";
			addChild(input4);

			input5 = new UITextArea();
			input5.x = 80; input5.y = 160;
			input5.width = 150; input5.height = 50;
			addChild(input5);
			
			btn3 = new UIButton();
			btn3.x = 190; btn3.y = 90;
			btn3.width = 40; btn3.height = 24;
			btn3.label = "选择";
			addChild(btn3);
			
			var container1:UICanvas = new UICanvas();
			container1.x = 240; container1.y = 20;
			container1.width = 340; container1.height = 300;
			container1.backgroundColor = 0x999999;
			container1.horizontalScrollPolicy = "auto";
			container1.verticalScrollPolicy = "off";
			addChild(container1);
			
			img3 = new UIImage();
			container1.addChild(img3);
			
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type 			= NativeWindowType.UTILITY;
			opts.resizable 		= true
			opts.width 			= 600
			opts.height 		= 400
			opts.title 			= "场景";
			return opts;
		}
		
		override protected function __init__():void
		{
			popupSign  		= PopupwinSign.MapScreenEditorPopupwin_sign;
			isModel    		= true;
			enabledDrag    	= true;
			useDefaultBotButton = true;
			
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new SceneEditorPopupwinMediator(this));
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(SceneEditorPopupwinMediator.NAME);
		}
		
		override public function forceActivate():void
		{
			super.forceActivate();
		}
		
	
		
		
	}
}