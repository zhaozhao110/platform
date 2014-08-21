package com.editor.module_api.log
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.containers.SandyHBox;
	import com.sandy.component.containers.SandyVBox;
	import com.sandy.component.controls.text.SandyTextArea;
	import com.sandy.popupwin.pop.PopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	
	
	public class ApiLogPopwin extends PopupWithEmptyWin
	{
		public function ApiLogPopwin()
		{
			super()
			create_init();
		}
		
		
		public var textInput:SandyTextArea;
		
		
		private function create_init():void
		{
			var form:SandyVBox = new SandyVBox();
			form.verticalGap = 10;
			form.y = 10;
			form.padding = 5;
			form.width = 400
			form.height = 400
			this.addChild(form);
			
			var hb:SandyHBox = new SandyHBox();
			hb.height = 30;
			form.addChild(hb);
			
			textInput = new SandyTextArea();
			textInput.alwaysShowSelection = true;
			textInput.enabledPercentSize = true;
			textInput.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			textInput.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(textInput);
						
			initComplete();
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.NORMAL;
			opts.width = 500
			opts.height = 500
			opts.title = "api log"
			opts.resizable = true;
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = false
			popupSign  		= PopupwinSign.ApiLogPopwin_sign
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new ApiLogPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(ApiLogPopwinMediator.NAME)
		}
		
	}
}