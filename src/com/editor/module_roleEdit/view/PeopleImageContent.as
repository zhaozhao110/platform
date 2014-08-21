package com.editor.module_roleEdit.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_roleEdit.facade.PeopleImageBindingData;
	import com.sandy.popupwin.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class PeopleImageContent extends UIVBox
	{
		public function PeopleImageContent()
		{
			super()
			create_init()
		}


		public var toolBar:PeopleImageToolBar;
		public var infoText:UILabel;
		public var dataGridContainer:PeopleImageDataGrid;
		
		//程序生成
		private function create_init():void
		{
			enabledPercentSize = true;
			padding = 10;
			
			toolBar = new PeopleImageToolBar();
			toolBar.id="toolBar"
			addChild(toolBar);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.percentWidth = 100;
			hb.styleName = "uicanvas"
			addChild(hb);
			
			infoText = new UILabel();
			infoText.id="infoText"
			infoText.percentWidth=100;
			infoText.height = 30;
			infoText.text = PeopleImageBindingData.getInstance().topInfoTxt.toString()
			hb.addChild(infoText);
			
			dataGridContainer = new PeopleImageDataGrid();
			addChild(dataGridContainer);
			
			//dispatchEvent creationComplete
			initComplete();
		}

	}
}