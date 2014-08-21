package com.editor.popup.readPdf
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	
	import flash.events.MouseEvent;

	public class ReadPdfPopToolBar extends UIHBox
	{
		public function ReadPdfPopToolBar()
		{
			super();
			create_init();
		}
		
		public var openBtn:UIButton;
		
		private function create_init():void
		{
			percentWidth = 100;
			height = 30;
			styleName = "uicanvas"
			verticalAlignMiddle = true;
			paddingLeft = 10;
				
			openBtn = new UIButton();
			openBtn.label = "打开"
			openBtn.addEventListener(MouseEvent.CLICK , onOpenClick);
			addChild(openBtn);
			
		}
		
		private function onOpenClick(e:MouseEvent):void
		{
			get_ReadPdfPopwupinMediator().openFile();
		}
		
		private function get_ReadPdfPopwupinMediator():ReadPdfPopwupinMediator
		{
			return iManager.retrieveMediator(ReadPdfPopwupinMediator.NAME) as ReadPdfPopwupinMediator;
		}
		
	}
}