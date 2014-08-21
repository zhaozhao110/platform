package com.editor.popup.editXML
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.system.System;

	public class EditXMLPopwin extends AppPopupWithEmptyWin
	{
		public function EditXMLPopwin()
		{
			super()
			create_init();
		}
		
		
		public var form:UIVBox;
		public var upTxt:UITextArea;
		public var downTxt:UITextArea;
		public var btn1:UIButton;
		public var btn2:UIButton;
		
		private function create_init():void
		{
			form = new UIVBox();
			form.y = 10;
			form.x = 10
			form.width = 570;
			form.height = 600;
			form.styleName = "uicanvas"
			this.addChild(form);
			
			upTxt = new UITextArea();
			upTxt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			upTxt.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			upTxt.height = 280;
			upTxt.percentWidth = 100;
			form.addChild(upTxt);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			form.addChild(hb);
			
			btn1 = new UIButton();
			btn1.label = "添加空格,换行";
			hb.addChild(btn1);
			
			btn2 = new UIButton();
			btn2.label = "删除空格，换行"
			hb.addChild(btn2);
			
			var btn3:UIButton = new UIButton();
			btn3.label = "复制下面文本"
			hb.addChild(btn3);
			btn3.addEventListener(MouseEvent.CLICK , function(e:MouseEvent):void{System.setClipboard(downTxt.text);});
			
			downTxt = new UITextArea();
			downTxt.height = 280;
			downTxt.percentWidth = 100;
			downTxt.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			downTxt.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(downTxt);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 600;
			opts.height = 650;
			opts.title = "编辑xml"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= PopupwinSign.EditXMLPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new EditXMLPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(EditXMLPopwinMediator.NAME);
		}
		
	}
}