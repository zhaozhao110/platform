package com.editor.project_pop.sharedobject
{
	import com.air.io.SelectFile;
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInputWidthLabel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;

	public class SharedObjectReaderPopWin extends AppPopupWithEmptyWin
	{
		public function SharedObjectReaderPopWin()
		{
			super()
			create_init()
		}
		
		public var selectBtn:UIButton;
		public var textInput:UITextInputWidthLabel;
		public var clientBtn:UIButton;
		public var config3Btn:UIButton;
		public var vbox:UIVBox;
		public var openPackBtn:UIButton;
		public var reZipBtn:UIButton;
		public var createBtn:UIButton;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.minimizable = true;
			opts.width = 500;
			opts.height = 500;
			opts.title = "sharedobject reader";
			return opts;
		}
		
		private function create_init():void
		{
			var gdpsvbox2:UIVBox = new UIVBox();
			gdpsvbox2.width = 470;
			gdpsvbox2.height = 450
			gdpsvbox2.styleName = "uicanvas";
			gdpsvbox2.padding = 5;
			gdpsvbox2.verticalGap = 5;
			gdpsvbox2.x = 5;
			gdpsvbox2.y = 5;
			addContentChild(gdpsvbox2);
			
			var hb1:UIHBox = new UIHBox();
			hb1.height = 30;
			hb1.percentWidth = 100;
			gdpsvbox2.addChild(hb1);
			
			textInput = new UITextInputWidthLabel();
			textInput.label = "sharedObject所在的目录:";
			textInput.width = 390
			hb1.addChild(textInput);
			
			selectBtn = new UIButton();
			selectBtn.label = "打开";
			//selectBtn.addEventListener(MouseEvent.CLICK , onSelectClick);
			hb1.addChild(selectBtn);
			
			var hb2:UIHBox = new UIHBox();
			hb2.height = 25;
			hb2.percentWidth = 100;
			gdpsvbox2.addChild(hb2);
			
			clientBtn = new UIButton();
			clientBtn.label = "sharedObject of engineEditor";
			hb2.addChild(clientBtn);
			
			/*openPackBtn = new UIButton();
			openPackBtn.label = "打开客户端资源目录";
			hb2.addChild(openPackBtn);
			
			config3Btn = new UIButton();
			config3Btn.label = "打包配置文件";
			hb2.addChild(config3Btn);
			
			reZipBtn = new UIButton();
			reZipBtn.label = "解压配置文件";
			hb2.addChild(reZipBtn);*/
						
			vbox = new UIVBox();
			vbox.styleName = "list"
			vbox.enabledPercentSize = true;
			vbox.enabeldSelect = true;
			vbox.itemRenderer = SharedObjectItemRenderer;
			vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			gdpsvbox2.addChild(vbox);
			
			
			initComplete();
		}
		
		override protected function __init__() : void
		{
			//useDefaultBotButton = true
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.SharedObjectReaderPopWin_sign
			isModel    		= false;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new SharedObjectReaderPopWinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(SharedObjectReaderPopWinMediator.NAME);
		}
		
		
	}
}