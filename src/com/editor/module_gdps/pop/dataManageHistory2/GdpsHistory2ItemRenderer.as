package com.editor.module_gdps.pop.dataManageHistory2
{
	import com.editor.component.controls.UICheckBox;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	
	import flash.events.MouseEvent;

	public class GdpsHistory2ItemRenderer extends SandyBoxItemRenderer
	{
		public function GdpsHistory2ItemRenderer()
		{
			super();
			
			create_init();
		}
		private var checkBox:UICheckBox;
		
		private function create_init():void
		{
			verticalAlign = "middle";
			horizontalAlign = "center";
			height = 30;
			width = 120;
			mouseChildren = true;
			
			checkBox = new UICheckBox();
			checkBox.color = 0x0000FF;
			checkBox.y = 8;
			checkBox.selected = false;
			checkBox.verticalAlign = "middle";
			checkBox.addEventListener(MouseEvent.CLICK , onClickHandler);
			addChild(checkBox);
			
			initComplete();
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			var _selected:Boolean = checkBox.selected;
			if (!_selected)
			{
				historyMedi().removeCurrentSelectedCbox(data.SVid);
			}
			else
			{
				historyMedi().setCurrentSelectedCbox(data.SVid, checkBox);
			}
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			checkBox.label = data.SVid;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(checkBox){
				checkBox.label = "";
				checkBox.removeEventListener(MouseEvent.CLICK , onClickHandler);
			}
		}
		
		private function historyMedi():GdpsDataManageHistory2PopupwinMediator
		{
			return iManager.ifabrication.retrieveMediator(GdpsDataManageHistory2PopupwinMediator.NAME) 
				as GdpsDataManageHistory2PopupwinMediator;
		}
	}
}