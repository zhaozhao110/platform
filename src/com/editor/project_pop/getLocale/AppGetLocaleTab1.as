package com.editor.project_pop.getLocale
{
	import com.air.io.SelectFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.project_pop.getLocale.locale.GetLocaleProcessor;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class AppGetLocaleTab1 extends UIVBox
	{
		public function AppGetLocaleTab1()
		{
			create_init()
		}
		
		public var fileTI1:UITextInput;
		public var txt:UITextArea;
		public var button24:UIButton;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			padding = 5;
			verticalGap = 10;
				
			var hbox22:UIHBox = new UIHBox();
			hbox22.percentWidth=100
			hbox22.height = 30;
			hbox22.styleName = "uicanvas"
			addChild(hbox22);
			
			var label23:UILabel = new UILabel();
			label23.text="选择目录："
			hbox22.addChild(label23);
			
			fileTI1 = new UITextInput();
			fileTI1.id="fileTI1"
			fileTI1.width=300;
			fileTI1.editable=false
			fileTI1.text=""
			hbox22.addChild(fileTI1);
			
			button24 = new UIButton();
			button24.label="选择目录"
			hbox22.addChild(button24);
			button24.addEventListener('click',function(e:*):void{getDir();});
			
			var lb:UILabel = new UILabel();
			lb.color = ColorUtils.red;
			lb.text = "最终的文件将生成在桌面,解析将会花费一定的时间，请等待"
			addChild(lb);
			
			txt = new UITextArea();
			txt.id="txt"
			txt.editable=false
			txt.enabledPercentSize = true
			txt.borderColor=13421772
			txt.borderStyle="solid"
			txt.borderThickness=2
			addChild(txt);
		}
		
		
		private var originalFile:File;
		private var getLocale2:GetLocaleProcessor = new GetLocaleProcessor();
		
		private function getDir():void
		{
			SelectFile.selectDirectory("选择原始目录" ,selectOriginalDirectory_result)
		}
		
		private function selectOriginalDirectory_result(e:Event):void
		{
			originalFile = e.currentTarget as File
			fileTI1.text = originalFile.nativePath;
			getLocale2.log = log2;
			getLocale2.getLocale(originalFile);
		}
		
		private function log2(s:String):void
		{
			txt.htmlText += s + "<br>"
		}
		
		
	}
}