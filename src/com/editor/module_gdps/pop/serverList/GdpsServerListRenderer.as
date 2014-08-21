package com.editor.module_gdps.pop.serverList
{
	import com.editor.component.controls.UICheckBox;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;

	public class GdpsServerListRenderer extends SandyBoxItemRenderer
	{
		public function GdpsServerListRenderer()
		{
			super();
			
			create_init();
		}
		public var checkBox:UICheckBox;
		
		private function create_init():void
		{
			verticalAlign = "middle";
			horizontalAlign = "center";
			height = 30;
			width = 35;
			mouseChildren = true;
			
			checkBox = new UICheckBox();
			checkBox.y = 8;
			checkBox.x = 6;
			checkBox.selected = false;
			checkBox.verticalAlign = "middle";
			checkBox.addEventListener(ASEvent.CHANGE , onChangeHandler);
			addChild(checkBox);
			
			initComplete();
		}
		
		private function onChangeHandler(e:ASEvent = null):void
		{
			this.data.cbSelect = checkBox.selected;
			
			serverListMedi().updateView(checkBox.selected);
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			if (this.data != null && this.data.hasOwnProperty("cbSelect"))
			{
				checkBox.selected = this.data.cbSelect;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(checkBox){
				checkBox.removeEventListener(ASEvent.CHANGE , onChangeHandler);
			}
		}
		
		private function serverListMedi():GdpsServerListPopupwinMediator
		{
			return iManager.ifabrication.retrieveMediator(GdpsServerListPopupwinMediator.NAME) 
				as GdpsServerListPopupwinMediator;
		}
	}
}