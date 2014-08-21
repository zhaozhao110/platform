package com.editor.project_pop.addScout
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class AddScoutPopwin extends AppPopupWithEmptyWin
	{
		public function AddScoutPopwin()
		{
			super()
			create_init()
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 400;
			opts.height = 280;
			opts.title = "swf add scout"	
			return opts;
		}
		
		public var selectBtn:UIButton;
		public var fileTi:UILabel;
		public var logTxt:UITextArea;
		
		private function create_init():void
		{
			var vb:UIVBox = new UIVBox();
			vb.enabledPercentSize = true;
			addChild(vb);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			vb.addChild(hb);
			
			selectBtn = new UIButton();
			selectBtn.label = "选择swf文件"
			hb.addChild(selectBtn);
			
			fileTi = new UILabel();
			hb.addChild(fileTi);
			
			var lb:UILabel = new UILabel();
			lb.text = "会在老的ASC 1.0加入-advanced-telemetry，使其也能启用高级遥测功能"
			vb.addChild(lb);
				
			logTxt = new UITextArea();
			logTxt.editable = false;
			logTxt.percentWidth = 100;
			logTxt.height = 180;
			vb.addChild(logTxt);
		}
		
		override protected function __init__() : void
		{
			useDefaultBotButton = false
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.AddScoutPopwin_sign
			isModel    		= false;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new AddScoutPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AddScoutPopwinMediator.NAME);
		}
		
	}
}