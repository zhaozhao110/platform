package com.editor.module_gdps.view.dataBase.component
{
	import com.editor.component.controls.UICheckBox;
	import com.editor.module_gdps.view.dataBase.mediator.GdpsDataBaseDataGridMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;

	public class GdpsDataBaseRenderer extends SandyBoxItemRenderer
	{
		public function GdpsDataBaseRenderer()
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
			width = 120;
			mouseChildren = true;
			
			checkBox = new UICheckBox();
			checkBox.color = 0x0000FF;
			checkBox.y = 8;
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
			
			dataBaseMedi().checkBoxDataChangeHandler(this);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(checkBox){
				checkBox.removeEventListener(ASEvent.CHANGE , onChangeHandler);
			}
		}
		
		private function dataBaseMedi():GdpsDataBaseDataGridMediator
		{
			return iManager.ifabrication.retrieveMediator(GdpsDataBaseDataGridMediator.NAME) 
				as GdpsDataBaseDataGridMediator;
		}
	}
}