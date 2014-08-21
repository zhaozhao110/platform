package com.editor.popup.preImage
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;

	public class PreImagePopWin extends AppPopupWithEmptyWin
	{
		public function PreImagePopWin()
		{
			super()
			create_init()
		}
		
		public var mediator:PreImagePopWinMediator;
		public var img:UICanvas;
		public var txt:UILabel;
		public var leftTopBtn:UIButton;	
		public var rightBotBtn:UIButton;
		public var clearBtn:UIButton;
		public var copyBtn:UIButton;
		public var colorBtn:UIButton;
		public var restoreBtn:UIButton;
		public var txt9:UILabel;
		public static const img_y:int = 90;
		public static const win_w:int = 650;
		public static const win_h:int = 500;
		public var hb2:UIHBox;
		public var hb3:UIHBox;
		public var colTxt:UILabel;
		public var openBtn:UIButton;
		public var openBtn2:UIButton;
		public var saveBtn:UIButton;
				
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = win_w;
			opts.height = win_h;
			opts.maximizable = true;
			opts.minimizable = true;
			opts.resizable = true
			opts.title = "预览图片"	
			return opts;
		}
		
		private function create_init():void
		{
			var hb:UIHBox = new UIHBox();
			hb.percentWidth = 100 ;
			hb.height = 30
			hb.paddingLeft = 10;
			hb.horizontalGap = 10;
			hb.verticalAlignMiddle = true;
			hb.styleName = "uicanvas"
			addChild(hb);
			
			txt = new UILabel();
			txt.width = win_w;
			hb.addChild(txt);
						
			hb2 = new UIHBox();
			hb2.percentWidth = 100 ;
			hb2.height = 30
			hb2.y = 30;
			hb2.paddingLeft = 10;
			hb2.horizontalGap = 10;
			hb2.verticalAlignMiddle = true;
			hb2.styleName = "uicanvas"
			addChild(hb2);
						
			var lb:UILabel = new UILabel();
			lb.text = "九宫格操作：";
			hb2.addChild(lb);
			
			leftTopBtn = new UIButton();
			leftTopBtn.label = "定位左上角"
			hb2.addChild(leftTopBtn);
			
			rightBotBtn = new UIButton();
			rightBotBtn.label = "定位右下角"
			hb2.addChild(rightBotBtn);
			
			copyBtn = new UIButton();
			copyBtn.label = "发送九宫格数据"
			hb2.addChild(copyBtn);
			
			txt9 = new UILabel();
			txt9.text = "left:";
			hb2.addChild(txt9);
			
			hb3 = new UIHBox();
			hb3.percentWidth = 100 ;
			hb3.height = 30
			hb3.y = 60;
			hb3.paddingLeft = 10;
			hb3.horizontalGap = 10;
			hb3.verticalAlignMiddle = true;
			hb3.styleName = "uicanvas"
			addChild(hb3);
			
			openBtn = new UIButton();
			openBtn.label = "打开图片"
			hb3.addChild(openBtn);
			
			openBtn2 = new UIButton();
			openBtn2.label = "打开系统剪贴板里的图片"
			hb3.addChild(openBtn2);
			
			saveBtn = new UIButton();
			saveBtn.label = "保存图片"
			hb3.addChild(saveBtn);
			
			clearBtn = new UIButton();
			clearBtn.label = "清除绘画"
			hb3.addChild(clearBtn);
			
			restoreBtn = new UIButton();
			restoreBtn.label = "还原原始大小"
			restoreBtn.toolTip = "双击图片也可以还原原始大小"
			hb3.addChild(restoreBtn);
			
			colorBtn = new UIButton();
			colorBtn.label = "取颜色"
			hb3.addChild(colorBtn);
			
			colTxt = new UILabel();
			colTxt.selectable = true
			hb3.addChild(colTxt);
			
			img = new UICanvas();
			img.styleName = "uicanvas"
			img.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto
			img.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			img.y = img_y
			addChild(img);
			img.mouseEnabled = true;
			
			initComplete();
		}
		
		
		
		override protected function nativeWinResizeHandle(w:Number=NaN,h:Number=NaN):void
		{
			super.nativeWinResizeHandle(w,h);
			if(img == null) return ;
			if(isNaN(w)){
				w = nativeWinWidth;
			}
			if(isNaN(h)){
				h = nativeWinHeight;
			}
			img.width = w-10;
			img.height = h-img.y-30;
			//trace(img.width,img.height)
		}
		
		override protected function __init__() : void
		{
			useDefaultBotButton = false
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.PreImagePopWin_sign;
			isModel    		= false;
			
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new PreImagePopWinMediator(this))
		}
		
		override public function delPopwin() : void
		{
			super.delPopwin()
			removeMediator(PreImagePopWinMediator.NAME);
		}
		
		
	}
}