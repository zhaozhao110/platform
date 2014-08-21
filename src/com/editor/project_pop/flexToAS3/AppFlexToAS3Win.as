package com.editor.project_pop.flexToAS3
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class AppFlexToAS3Win extends AppPopupWithEmptyWin
	{
		public function AppFlexToAS3Win()
		{
			super()
			create_init()
		}
		
		public var fileTI3:UITextInput;
		public var fileTI1:UITextInput;
		public var fileTI2:UITextInput;
		public var txt:UITextArea;
		public var button9:UIButton;
		public var button13:UIButton;
		public var button16:UIButton;
		public var button18:UIButton;
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 800;
			opts.height = 400;
			opts.title = "flex项目转成as3项目"	
			return opts;
		}
		
		private function create_init():void
		{
			var vbox6:UIVBox = new UIVBox();
			vbox6.percentWidth=100
			vbox6.percentHeight=100
			vbox6.verticalGap=10
			addMiddleContainerChild(vbox6);
			
			var hbox7:UIHBox = new UIHBox();
			hbox7.percentWidth=100
			hbox7.borderColor=13421772
			hbox7.borderStyle="solid"
			hbox7.borderThickness=2
			vbox6.addChild(hbox7);
			
			var label8:UILabel = new UILabel();
			label8.text="导入mxml"
			hbox7.addChild(label8);
			
			fileTI3 = new UITextInput();
			fileTI3.id="fileTI3"
			fileTI3.width=300
			fileTI3.editable=false
			hbox7.addChild(fileTI3);
			
			button9 = new UIButton();
			button9.label="转换成AS"
			hbox7.addChild(button9);
			
			var vbox10:UIVBox = new UIVBox();
			vbox10.percentWidth=100
			vbox10.borderColor=13421772
			vbox10.borderStyle="solid"
			vbox10.borderThickness=2
			vbox6.addChild(vbox10);
			
			var hbox11:UIHBox = new UIHBox();
			hbox11.percentWidth=100
			vbox10.addChild(hbox11);
			
			var label12:UILabel = new UILabel();
			label12.text="源目录："
			hbox11.addChild(label12);
			
			fileTI1 = new UITextInput();
			fileTI1.id="fileTI1"
			fileTI1.width=300
			fileTI1.editable=false
			fileTI1.text=""
			hbox11.addChild(fileTI1);
			
			button13 = new UIButton();
			button13.label="选择原始目录"
			hbox11.addChild(button13);
			
			var hbox14:UIHBox = new UIHBox();
			hbox14.percentWidth=100
			vbox10.addChild(hbox14);
			
			var label15:UILabel = new UILabel();
			label15.text="目标目录："
			hbox14.addChild(label15);
			
			fileTI2 = new UITextInput();
			fileTI2.id="fileTI2"
			fileTI2.width=300
			fileTI2.editable=false
			fileTI2.text=""
			hbox14.addChild(fileTI2);
			
			button16 = new UIButton();
			button16.label="选择目标目录"
			hbox14.addChild(button16);
			
			var hbox17:UIHBox = new UIHBox();
			hbox17.percentWidth=100
			vbox10.addChild(hbox17);
			
			button18 = new UIButton();
			button18.label="复制AS文件,转换mxml文件"
			hbox17.addChild(button18);
			
			txt = new UITextArea();
			txt.id="txt"
			txt.editable=false
			txt.percentWidth=100
			txt.height = 200
			txt.borderColor=13421772
			txt.borderStyle="solid"
			txt.borderThickness=2
			vbox6.addChild(txt);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		override protected function __init__() : void
		{
			useDefaultBotButton = true
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.AppFlexToAS3Win_sign
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new AppFlexToAS3WinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppFlexToAS3WinMediator.NAME);
		}
		
		
	}
}