package com.editor.module_gdps.pop.packageDetail
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.module_gdps.view.dataBase.mediator.GdpsDataBaseDataGridMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;

	public class GdpsDetailItemRenderer extends SandyBoxItemRenderer
	{
		public function GdpsDetailItemRenderer()
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
			checkBox.color = 0x0000FF;
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
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			checkBoxDataChangeHandler();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(checkBox){
				checkBox.removeEventListener(ASEvent.CHANGE , onChangeHandler);
			}
		}
		
		private function checkBoxDataChangeHandler():void
		{
			if (this.data != null && this.data.hasOwnProperty("cbSelect"))
			{
				this.checkBox.selected = this.data.cbSelect;
			}
			if (this.data != null && this.data.hasOwnProperty("SStateId"))
			{
				this.checkBox.enabled = this.data.SStateId == '1';
			}
		}
		
		private function dataBaseMedi():GdpsPackageDetailPopupwinMediator
		{
			return iManager.ifabrication.retrieveMediator(GdpsPackageDetailPopupwinMediator.NAME) 
				as GdpsPackageDetailPopupwinMediator;
		}
	}
}