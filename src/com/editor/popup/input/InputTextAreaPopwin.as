package com.editor.popup.input
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.expand.UIEditTextToolBar;
	import com.editor.manager.DataManager;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.system.System;

	public class InputTextAreaPopwin extends AppPopupWithEmptyWin
	{
		public function InputTextAreaPopwin()
		{
			super()
			create_init();
		}
		
		
		public var textInput:UITextArea;
		public var textInput2:UITextArea;
		public var infoTxt:UIText;
		public var toolBar:UIEditTextToolBar;
		public var backBtn:UIButton;
		public var copyBtn:UIButton;
		public var form2:UIVBox
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			form.verticalGap = 10;
			form.y = 10;
			form.padding = 5;
			form.width = 800;
			form.height = 450
			this.addChild(form);
			
			toolBar = new UIEditTextToolBar();
			form.addChild(toolBar);
			
			textInput = new UITextArea();
			textInput.alwaysShowSelection = true;
			textInput.enabledPercentSize = true;
			textInput.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			textInput.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(textInput);
			
			infoTxt = new UIText();
			infoTxt.width = 350;
			infoTxt.height = 60;
			infoTxt.multiline = true;
			form.addChild(infoTxt);
			
			//////////////////////////////////////////////////////////
			
			form2 = new UIVBox();
			form2.verticalGap = 10;
			form2.y = 10;
			form2.padding = 5;
			form2.width = 800;
			form2.height = 450
			form2.backgroundColor = DataManager.def_col
			form2.styleName = "uicanvas"
			form2.visible = false;
			this.addChild(form2);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			form2.addChild(hb);
			
			backBtn = new UIButton();
			backBtn.label = "返回"
			backBtn.addEventListener(MouseEvent.CLICK , onBack);
			hb.addChild(backBtn);
			
			copyBtn = new UIButton();
			copyBtn.label = "复制"
			copyBtn.addEventListener(MouseEvent.CLICK , onCopy);
			hb.addChild(copyBtn);
			
			textInput2 = new UITextArea();
			textInput2.enabledPercentSize = true;
			textInput2.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			textInput2.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form2.addChild(textInput2);
			
			initComplete();
		}
		
		private function onBack(e:MouseEvent):void
		{
			form2.visible = false;
		}
		
		private function onCopy(e:MouseEvent):void
		{
			System.setClipboard(textInput2.text);
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 820;
			opts.minimizable = true;
			opts.height = 500;
			opts.title = "输入文本"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.InputTextAreaPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new InputTextAreaPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(InputTextAreaPopwinMediator.NAME)
		}
		
	}
}