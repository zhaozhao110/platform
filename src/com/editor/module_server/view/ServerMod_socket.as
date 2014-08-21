package com.editor.module_server.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;

	public class ServerMod_socket extends UIVBox
	{
		public function ServerMod_socket()
		{
			super();
			create_init();
		}
		
		public var startBtn:UIButton;
		public var stopBtn:UIButton;
		public var restartBtn:UIButton;
		public var logTxt:UITextArea;
		public var infoTxt:UIText;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas";
			padding = 5;
			
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100;
			hb.horizontalGap = 10;
			hb.height = 30;
			addChild(hb);
			
			startBtn = new UIButton();
			startBtn.label = "启动"
			hb.addChild(startBtn);
			
			stopBtn = new UIButton();
			stopBtn.label = "停止"
			hb.addChild(stopBtn);
			
			restartBtn = new UIButton();
			restartBtn.label = "重启"
			hb.addChild(restartBtn);
			
						
			infoTxt = new UIText();
			infoTxt.text = "";
			hb.addChild(infoTxt);
			
			logTxt = new UITextArea();
			logTxt.editable = false;
			logTxt.enabledPercentSize = true;
			addChild(logTxt);
		}
		
	}
}