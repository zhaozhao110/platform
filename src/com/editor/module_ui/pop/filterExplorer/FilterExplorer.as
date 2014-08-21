package com.editor.module_ui.pop.filterExplorer
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.containers.UIViewStack;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.controls.ASColorPicker;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.NativeWindowType;
	import flash.events.MouseEvent;
	import flash.system.System;

	public class FilterExplorer extends AppPopupWithEmptyWin
	{
		public function FilterExplorer()
		{
			super()
			create_init();
		}
		
		public var box:UIVBox;
		public var attriBox:UIVBox;
		public var showCan:UICanvas;
		public var txt:UITextArea;
		public var vs:UIViewStack;
				
		private function create_init():void
		{
			var vb:UIHBox = new UIHBox();
			vb.width = 850;
			vb.height = 450;
			addChild(vb);
			
			box = new UIVBox();
			box.styleName = "list";
			box.enabeldSelect = true;
			box.itemRenderer = ASHListItemRenderer;
			box.width = 150;
			box.percentHeight = 100;
			vb.addChild(box);
			
			var hb:UIVBox = new UIVBox();
			hb.width = 400;
			hb.percentHeight = 100;
			vb.addChild(hb);
			
			var can:UICanvas = new UICanvas();
			can.width = 400;
			can.styleName = "uicanvas";
			can.height = 300;
			hb.addChild(can);
			
			showCan = new UICanvas();
			showCan.width = 100;
			showCan.height = 100;
			showCan.verticalCenter = 0;
			showCan.horizontalCenter = 0;
			showCan.backgroundColor = ColorUtils.black;
			can.addChild(showCan);
			
			var hb2:UIHBox = new UIHBox();
			hb2.percentWidth = 100;
			hb2.paddingLeft = 10;
			hb2.height = 30;
			hb2.bottom = 0;
			can.addChild(hb2);
			
			var copyBtn:UIButton = new UIButton();
			copyBtn.label = "复制代码"
			copyBtn.addEventListener(MouseEvent.CLICK , onCopy);
			hb2.addChild(copyBtn);
			
			var lb:UILabel = new UILabel();
			lb.text = "更换背景色："
			hb2.addChild(lb);
			
			var col:ASColorPicker = new ASColorPicker();
			col.addEventListener(ASEvent.CHANGE,onColChange);
			hb2.addChild(col);
			
			var vb2:UIVBox = new UIVBox();
			vb2.width = 400;
			vb2.padding = 5;
			vb2.styleName = "uicanvas";
			vb2.height = 150;
			hb.addChild(vb2);
			
			txt = new UITextArea();
			txt.percentWidth = 100;
			txt.height = 75;
			vb2.addChild(txt);
						
			var rightVB:UICanvas = new UICanvas();
			rightVB.width = 300;
			rightVB.styleName = "uicanvas";
			rightVB.percentHeight = 100;
			vb.addChild(rightVB);
			
			vs = new UIViewStack();
			vs.width = 300;
			vs.percentHeight = 100;
			rightVB.addChild(vs);
			
			initComplete();
			
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 850;
			opts.height = 450;
			opts.title = "FilterExplorer"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.FilterExplorer_sign;
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new FilterExplorerMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(FilterExplorerMediator.NAME)
		}
		
		private function onCopy(e:MouseEvent):void
		{
			System.setClipboard(txt.text);
		}
		
		private function onColChange(e:ASEvent):void{
			showCan.backgroundColor = e.data;
		}
	}
}