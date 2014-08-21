package com.editor.module_gdps.pop.dataBaseHistory
{
	import com.editor.component.controls.UILinkButton;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	
	import flash.events.MouseEvent;

	public class GdpsDataBaseHistoryItemRenderer extends SandyBoxItemRenderer
	{
		public function GdpsDataBaseHistoryItemRenderer()
		{
			super();
			
			create_init();
		}
		private var linkBtn:UILinkButton;
		
		private function create_init():void
		{
			verticalAlign = "middle";
			horizontalAlign = "center";
			height = 30;
			width = 120;
			mouseChildren = true;
			
			linkBtn = new UILinkButton();
			linkBtn.color = 0x0000FF;
			linkBtn.addEventListener(MouseEvent.CLICK , onClickHandler);
			addChild(linkBtn);
			
			initComplete();
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			historyMedi().publish_link_evt_handler(data.SVid);
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			linkBtn.text = data.SVid;
		}
		
		override public function poolDispose():void
		{
			super.poolDispose();
			
			if(linkBtn){
				linkBtn.text = "";
				linkBtn.removeEventListener(MouseEvent.CLICK , onClickHandler);
			}
		}
		
		private function historyMedi():GdpsDataBaseHistoryPopupwinMediator
		{
			return iManager.ifabrication.retrieveMediator(GdpsDataBaseHistoryPopupwinMediator.NAME) 
				as GdpsDataBaseHistoryPopupwinMediator;
		}
	}
}