package com.editor.module_api.view
{
	import com.air.io.SelectFile;
	import com.editor.module_api.EditorApiFacade;
	import com.editor.module_api.event.ApiEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.containers.SandyHBox;
	import com.sandy.component.containers.SandyVBox;
	import com.sandy.component.controls.SandyButton;
	import com.sandy.component.controls.text.SandyLabel;
	import com.sandy.component.controls.text.SandyText;
	import com.sandy.component.controls.text.SandyTextArea;
	import com.sandy.component.controls.text.SandyTextInput;
	import com.sandy.manager.SharedObjectManager;
	import com.sandy.utils.TimerUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	public class ApiModuleManager extends SandyVBox
	{
		public function ApiModuleManager()
		{
			super();
			create_init();
		}
		
		public var text1:SandyTextInput;
		public var btn1:SandyButton;
		public var text2:SandyTextInput;
		public var btn2:SandyButton;
		public var startBtn:SandyButton;
		public var logTxt:SandyTextArea;
		public var timerTxt:SandyText;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas"
			padding = 10;
			visible = false;
			verticalGap =10;
			backgroundColor = 0xd4d0c8
				
			var hb:SandyHBox = new SandyHBox();
			hb.height = 30;
			hb.styleName = "uicanvas"
			hb.percentWidth = 100;
			hb.horizontalGap = 10;
			hb.paddingLeft= 20;
			hb.verticalAlignMiddle =true
			addChild(hb);
			
			var backBtn:SandyButton = new SandyButton();
			backBtn.label = "返回"
			backBtn.addEventListener(MouseEvent.CLICK,onBackClick);
			hb.addChild(backBtn);
			
			var lb:SandyLabel = new SandyLabel();
			lb.text = "选择要解析的包目录："
			hb.addChild(lb);
			
			text1 = new SandyTextInput();
			text1.width = 400;
			text1.editable = false;
			hb.addChild(text1);
			
			btn1 = new SandyButton();
			btn1.label = "选择"
			btn1.addEventListener(MouseEvent.CLICK,onBtn1Click);
			hb.addChild(btn1);
			
			hb = new SandyHBox();
			hb.height = 30;
			hb.styleName = "uicanvas"
			hb.percentWidth = 100;
			hb.horizontalGap = 10;
			hb.verticalAlignMiddle =true
			hb.paddingLeft= 20;
			addChild(hb);
			
			lb = new SandyLabel();
			lb.text = "选择要保存的db："
			hb.addChild(lb);
			
			text2 = new SandyTextInput();
			text2.width = 400;
			text2.editable = false;
			hb.addChild(text2);
			
			btn2 = new SandyButton();
			btn2.label = "选择"
			btn2.addEventListener(MouseEvent.CLICK,onBtn2Click);
			hb.addChild(btn2);
			
			text1.text = SharedObjectManager.getInstance().find("","api_dir");
			text2.text = SharedObjectManager.getInstance().find("","api_db");
			
			hb = new SandyHBox();
			hb.height = 30;
			hb.styleName = "uicanvas"
			hb.percentWidth = 100;
			hb.horizontalGap = 10;
			hb.verticalAlignMiddle =true
			hb.paddingLeft= 20;
			addChild(hb);
			
			startBtn = new SandyButton();
			startBtn.label = "开始"
			startBtn.addEventListener(MouseEvent.CLICK,onStartBtnClick);
			hb.addChild(startBtn);
			
			timerTxt = new SandyText();
			timerTxt.width = 800
			hb.addChild(timerTxt);
			
			logTxt = new SandyTextArea();
			logTxt.editable = false;
			logTxt.enabledPercentSize = true
			logTxt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(logTxt);
		}
		
		private function onBackClick(e:MouseEvent):void
		{
			visible=false;
		}
		
		private function onBtn1Click(e:MouseEvent):void
		{
			SelectFile.selectDirectory("选择要解析的包目录",result1)
		}
		
		private function result1(e:Event):void
		{
			var fl:File = e.target as File;
			text1.text = fl.nativePath;
			SharedObjectManager.getInstance().put("","api_dir",fl.nativePath);
		}
		
		private function onBtn2Click(e:MouseEvent):void
		{
			SelectFile.select("选择要保存的db",null,result2)
		}
		
		private function result2(e:Event):void
		{
			var fl:File = e.target as File;
			text2.text = fl.nativePath;
			SharedObjectManager.getInstance().put("","api_db",fl.nativePath);
		}
		
		private var exe_n:int;
		
		private function onStartBtnClick(e:MouseEvent):void
		{
			startTime = TimerUtils.getCurrentTime();
			exe_n = 0;
			startTimer();
			startBtn.visible = false;
			
			var s:String = "/0ip2YhUE1xIw6gCLara3Q=="
			
			var obj:Array = [text1.text,text2.text,s];
			EditorApiFacade.getInstance().sendAppNotification(ApiEvent.startParserApi_event,obj);
		}
		
		private var timer:Timer;
		private function startTimer():void
		{
			stopTimer()
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER , onTimer);
			timer.start();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			timerTxt.text = "开始时间: " + TimerUtils.getFromatTime(startTime/1000) + "     " + 
				"运行时间: " +TimerUtils.timerToStringForMore(int(TimerUtils.getCurrentTime()-startTime)/1000) + "      " + 
				"执行次数:  " + exe_n;
		}
		
		public function stopTimer():void
		{
			if(timer == null) return 
			timer.stop();
		}
		
		public function log_proxy(s:String):void
		{
			exe_n += 1;
			/*logTxt
			logTxt.appendHtmlText(s);
			logTxt.getTextField().getTextField().*/
		}
		
		public function parserApiEnd():void
		{
			startBtn.visible = true
			stopTimer();
			logTxt.htmlText += timerTxt.text+"<br>";
			timerTxt.text = "";
		}
		
		
	}
}