package com.editor.d3Popup.previewATF
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;

	public class D3PreviewATFPopup extends AppPopupWithEmptyWin
	{
		public function D3PreviewATFPopup()
		{
			super()
			create_init()
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 800;
			opts.height = 600;
			//opts.gpu = true
			opts.minimizable = true;
			opts.title = "预览ATF"	
			return opts;
		}
		
		private function create_init():void
		{
			var hb:UIVBox = new UIVBox();
			hb.percentWidth = 100 ;
			hb.height = 30
			hb.paddingLeft = 10;
			hb.verticalGap = 10;
			hb.styleName = "uicanvas"
			addChild(hb);
			
			var h:UIHBox = new UIHBox();
			h.percentWidth =100;
			h.height = 25;
			h.verticalAlignMiddle = true;
			hb.addChild(h);
			
			var btn:UIButton = new UIButton();
			btn.label = "清空列表"
			btn.addEventListener(MouseEvent.CLICK , onClearHandle);
			h.addChild(btn);
			
			openFileBtn = new UIButton();
			openFileBtn.label = "打开图片"
			h.addChild(openFileBtn);
			
			openFoldBtn = new UIButton();
			openFoldBtn.label = "打开目录"
			h.addChild(openFoldBtn);
			
			pathTi = new UILabel();
			h.addChild(pathTi);
			
			h = new UIHBox();
			h.horizontalGap = 10;
			h.enabledPercentSize = true;
			hb.addChild(h);
			
			fileList = new UIVlist();
			fileList.width = 200;
			fileList.height = 500;
			fileList.styleName = "list"
			fileList.enabeldSelect = true;
			fileList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			h.addChild(fileList);
			
			imgCont = new UICanvas();
			imgCont.styleName = "uicanvas"
			imgCont.enabledPercentSize = true;
			h.addChild(imgCont);
			
			img = new UIImage();
			imgCont.addChild(img);
		}
		
		public var pathTi:UILabel;
		public var imgCont:UICanvas;
		public var img:UIImage;
		public var fileList:UIVlist;
		public var openFileBtn:UIButton;
		public var openFoldBtn:UIButton;
		
		private function onClearHandle(e:MouseEvent):void
		{
			fileList.dataProvider = null;
		}
		
		override protected function __init__() : void
		{
			useDefaultBotButton = false
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.D3PreviewATFPopup_sign
			isModel    		= false;
			
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new D3PreviewATFPopupMediator(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeMediator(D3PreviewATFPopupMediator.NAME);
		}
		
		
	}
}