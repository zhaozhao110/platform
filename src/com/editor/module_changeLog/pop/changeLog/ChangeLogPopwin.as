package com.editor.module_changeLog.pop.changeLog
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.PopupwinSign;
	import com.editor.module_changeLog.component.ChangeLogLeftViewItemRenderer;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.NativeWindowType;

	public class ChangeLogPopwin extends AppPopupWithEmptyWin
	{
		public function ChangeLogPopwin()
		{
			super()
			create_init();
		}
		
		public var vbox:UIVBox;
		public var txtArea:UITextArea;
		
		private function create_init():void
		{
			var lb:UIText = new UIText();
			lb.width = 500;
			lb.x = 8
			lb.color = ColorUtils.red;
			lb.text = "最近引擎(平台)更改或者增加的内容记录，大家尽量了解下(关闭后可以通过帮助菜单里的changeLog打开)"
			addChild(lb);
			
			var form:UIHBox = new UIHBox();
			form.horizontalGap = 5;
			form.y = 30;
			form.x = 8;
			form.padding = 5;
			form.width = 530;
			form.height = 330;
			form.styleName = "uicanvas"
			this.addChild(form);
			
			vbox = new UIVBox();
			vbox.width = 150;
			vbox.percentHeight = 100;
			vbox.styleName = "list"
			vbox.enabeldSelect = true;
			vbox.rightClickEnabled = true;
			vbox.itemRenderer = ChangeLogLeftViewItemRenderer;
			//vbox.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(vbox);
			
			txtArea = new UITextArea();
			txtArea.wordWrap = false;
			txtArea.fontSize = 14;
			txtArea.verticalScrollPolicy=ASComponentConst.scrollPolicy_auto;
			txtArea.horizontalScrollPolicy=ASComponentConst.scrollPolicy_auto;
			txtArea.selected = true;
			txtArea.editable = false;
			txtArea.enabledPercentSize = true
			form.addChild(txtArea);
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 550;
			opts.height = 400;
			opts.title = "最新更新日志"
			//opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.ChangeLogPopwin_sign
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ChangeLogPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ChangeLogPopwinMediator.NAME)
		}
	}
}