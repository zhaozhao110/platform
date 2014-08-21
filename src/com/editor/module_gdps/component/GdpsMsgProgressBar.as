package com.editor.module_gdps.component
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UIText;
	
	import flash.events.MouseEvent;

	public class GdpsMsgProgressBar extends UICanvas
	{
		public function GdpsMsgProgressBar()
		{
			super();
			create_init();
		}
		
		public var progressMsg:UIText;
		public var progressUI:UICanvas;
		public var progressTxt:UILabel;
		public var progressBtn:UILinkButton;
		public var progressBack:UICanvas;
		private var canShow:Boolean = false;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			mouseChildren = true;
			mouseEnabled = true;
			
			var back:UICanvas = new UICanvas();
			back.enabledPercentSize = true;
			back.backgroundColor = 0x000000;
			back.backgroundAlpha = 0.3;
			addChild(back);
			
			var vbox:UIVBox = new UIVBox();
			vbox.name = "hbox123"
			vbox.height = 250;
			vbox.width = 450;
			vbox.verticalAlign = "middle";
			vbox.horizontalAlign = "center";
			vbox.verticalCenter = 0;
			vbox.horizontalCenter = 0;
			vbox.backgroundColor = 0x406c99;
			vbox.paddingLeft = 10;
			vbox.paddingRight = 10;
			vbox.paddingTop = 5;
			vbox.paddingBottom = 5;
			vbox.backgroundAlpha = 0.7;
			vbox.verticalGap = 5;
			vbox.verticalScrollPolicy = "auto";
			vbox.horizontalScrollPolicy = "off";
			addChild(vbox);
			
			var hbox:UIHBox = new UIHBox();
			hbox.percentWidth = 100;
			hbox.height = 150;
			hbox.horizontalAlign = "left";
			vbox.addChild(hbox);
			
			progressMsg = new UIText();
			progressMsg.textAlign = "left";
			progressMsg.color = 0xFFFFFF;
			progressMsg.width = 430;
			progressMsg.wordWrap = true;
			progressMsg.height = 150;
			progressMsg.fontSize = 12;
			progressMsg.leading = 5;
			hbox.addChild(progressMsg);
			
			progressBack = new UICanvas();
			progressBack.percentWidth = 100;
			progressBack.height = 24;
			progressBack.backgroundColor = 0xEDFFFF;
			progressBack.visible = false;
			vbox.addChild(progressBack);
			
			progressUI = new UICanvas();
			progressUI.width = 0;
			progressUI.height = 24;
			progressUI.backgroundColor = 0x0099cc;
			progressBack.addChild(progressUI);
			
			progressTxt = new UILabel();
			progressTxt.width = 430;
			progressTxt.textAlign = "center";
			progressTxt.color = 0x0000FF;
			progressTxt.bold = true;
			progressTxt.y = 4;
			progressBack.addChild(progressTxt);
			
			progressBtn = new UILinkButton();
			progressBtn.label = "关闭";
			progressBtn.color = 0x000000;
			progressBtn.enabled = true;
			progressBtn.bold = true;
			progressBtn.paddingBottom = 2;
			progressBtn.addEventListener(MouseEvent.CLICK , onCloseHandler);
			vbox.addChild(progressBtn);
			
			initComplete();
		}
		
		private function onCloseHandler(e:MouseEvent):void
		{
			hidePopwin();
		}
		
		public function hidePopwin():void
		{
			clearProgressMsg();
			this.visible = false;
			progressUI.width = 0;
			progressTxt.text = "";
			progressBtn.enabled = false;
			progressBack.visible = false;
		}
		
		public function showPopwin():void
		{
			this.visible = true;
		}
		
		public function setProgressMsg(msg:String):void
		{
			progressMsg.htmlText = msg;
		}
		
		public function appendProgressMsg(msg:String):void
		{
			var msgs:Array = msg.split(";");
			var pro:int = int(msgs[0]);
			if(msgs.length >= 2)
			{
				progressBack.visible = true;
				pro = pro > 100 ? 100 : (pro < 0 ? 0 : pro);
				
				if(msgs[1] != "")
				{
					progressTxt.text = pro + "%|" + msgs[1];
				}
				
				progressUI.width = pro / 100 * 450;
				
				if(pro < 100)
				{
					progressUI.backgroundColor = 0x0099cc;
				}
				else
				{
					progressUI.backgroundColor = 0x33cc00;
				}
			}else{
				progressMsg.htmlText = progressMsg.htmlText + msg;
			}
		}
		
		public function clearProgressMsg():void
		{
			progressMsg.htmlText = "";
		}
	}
}