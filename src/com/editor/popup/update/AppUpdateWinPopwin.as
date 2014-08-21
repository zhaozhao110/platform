package com.editor.popup.update
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;

	public class AppUpdateWinPopwin extends AppPopupWithEmptyWin
	{
		public function AppUpdateWinPopwin()
		{
			super()
			create_init();
		}
				
		public var textInput:UITextArea;
		public var infoTxt:UIButton;
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			form.horizontalAlign = ASComponentConst.horizontalAlign_center;
			form.verticalGap = 10;
			form.y = 0;
			form.padding = 5;
			form.width = 320;
			form.height = 150
			this.addChild(form);
			
			var lb:UILabel = new UILabel();
			lb.text = "更新公告";
			form.addChild(lb);
			
			textInput = new UITextArea();
			textInput.editable = false;
			textInput.leading = 3;
			textInput.width = 290;
			textInput.height = 220;
			form.addChild(textInput);
			
			infoTxt = new UIButton();
			infoTxt.label = "下载"
			form.addChild(infoTxt);
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 320;
			opts.minimizable = true;
			opts.height = 350;
			opts.title = "新版本更新公告"
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false;
			popupSign  		= PopupwinSign.AppUpdateWinPopwin_sign;
			isModel    		= false;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppUpdateWinPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppUpdateWinPopwinMediator.NAME);
		}
		
	}
}