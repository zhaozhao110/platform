package com.editor.project_pop.getLocale
{
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.project_pop.getLocale.locale.GetLocaleProcessor;
	import com.editor.project_pop.getLocale.tab2.AppGetLocaleTab2Cache;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class AppGetLocaleTab3 extends UIVBox
	{
		public function AppGetLocaleTab3()
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
			hbox22.verticalAlignMiddle = true;
			hbox22.paddingLeft = 20;
			addChild(hbox22);
			
			var label23:UIButton = new UIButton();
			label23.label="刷新"
			label23.addEventListener(MouseEvent.CLICK , onReflash);
			hbox22.addChild(label23);
			
			
			txt = new UITextArea();
			txt.id="txt"
			txt.editable=false
			txt.enabledPercentSize = true
			txt.borderColor=13421772
			txt.borderStyle="solid"
			txt.borderThickness=2
			addChild(txt);
		}
		
		private function onReflash(e:MouseEvent):void
		{
			var read:ReadFile = new ReadFile();
			txt.text = read.readCompressByteArray(AppGetLocaleTab2Cache.getInstance().getSaveFile().nativePath);
		}
		
		
		
	}
}