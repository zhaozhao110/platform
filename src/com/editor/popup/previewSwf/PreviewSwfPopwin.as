package com.editor.popup.previewSwf
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.air.utils.AIRUtils;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	public class PreviewSwfPopwin extends AppPopupWithEmptyWin
	{
		public function PreviewSwfPopwin()
		{
			super()
			create_init();
		}
		
		
		public var cont:UICanvas
		public var fileBtn:UIButton;
		public var pathLb:UILabel;
		public var ti:UITextInput;
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			form.verticalGap = 10;
			form.y = 10;
			form.padding = 5;
			form.width = 1200-30;
			form.height = 700-100
			this.addChild(form);
			
			var lb:UILabel = new UILabel();
			lb.color = ColorUtils.red;
			lb.text = "用于预览swf里的movieClip转换成序列图后的效果，请把swf里的导出类名输入下面的文本框里";
			form.addChild(lb);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			form.addChild(hb);
			
			lb = new UILabel();
			lb.text = "导出类名："
			hb.addChild(lb);
			
			ti = new UITextInput();
			ti.width = 120;
			hb.addChild(ti);
			
			fileBtn = new UIButton();
			fileBtn.label = "选择swf"
			hb.addChild(fileBtn);
			
			pathLb = new UILabel();
			hb.addChild(pathLb);
						
			cont = new UICanvas();
			cont.enabledPercentSize = true
			form.addChild(cont);
			
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 1200
			opts.minimizable = true;
			opts.maximizable = true
			opts.height = 700
			opts.title = "预览swf"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.PreviewSwfPopwin_sign
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new PreviewSwfPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(PreviewSwfPopwinMediator.NAME)
		}
		
	}
}