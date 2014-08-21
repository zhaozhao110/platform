package com.editor.module_sql.pop.createTable
{
	
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.air.sql.SQLType;
	import com.editor.module_sql.model.presentation.MainPM;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;

	public class CreateTablePopWin extends AppPopupWithEmptyWin
	{
		public function CreateTablePopWin()
		{
			super()
			create_init()
		}


		public var tableNameTi:UITextInput;
		public var colNameTi:UITextInput;
		public var dataTypeTi:UICombobox;
		public var primaryCb:UICheckBox;
		public var incrementCb:UICheckBox;
		public var createBt:UIButton;

		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 310;
			opts.height = 300;
			opts.title = "create table"	
			return opts;
		}
		
		//程序生成
		private function create_init():void
		{
			var form27:UIForm = new UIForm();
			form27.styleName = "uicanvas"
			form27.paddingLeft = 10;
			form27.paddingTop =10;
			form27.verticalGap = 5;
			form27.enabledPercentSize = true
			form27.leftWidth = 100;
			this.addChild(form27);

			tableNameTi = new UITextInput();
			tableNameTi.formLabel = "Table name"
			tableNameTi.id="tableNameTi"
			tableNameTi.width = 150;
			form27.addFormItem(tableNameTi);
			
			var label30:UILabel = new UILabel();
			label30.text="First Field"
			form27.addFormItem(label30);

			colNameTi = new UITextInput();
			colNameTi.formLabel = "Field Name"
			colNameTi.width = 150;
			colNameTi.text= tableNameTi.text+'id' .toString()
			form27.addFormItem(colNameTi);
			
			dataTypeTi = new UICombobox();
			dataTypeTi.formLabel = "Field Type"
			dataTypeTi.width = 150;
			dataTypeTi.height = 25;
			dataTypeTi.dataProvider= SQLType.AFFINITY_TYPES;
			dataTypeTi.dropDownHeight = 140
			form27.addFormItem(dataTypeTi);
			dataTypeTi.selectedIndex = 0;

			primaryCb = new UICheckBox();
			primaryCb.id="primaryCb"
			primaryCb.label="Primary Key"
			primaryCb.selected=true
			form27.addFormItem(primaryCb);

			incrementCb = new UICheckBox();
			incrementCb.id="incrementCb"
			incrementCb.label="Auto increment"
			//incrementCb.selected=true
			form27.addFormItem(incrementCb);

			createBt = new UIButton();
			createBt.id="createBt"
			createBt.label="Create"
			form27.addFormItem(createBt);

			//dispatchEvent creationComplete
			initComplete();
		}

		
		
		override protected function __init__() : void
		{
			//useDefaultBotButton = true
			enabledDestroy 	= true;
			enabledDrag    	= true;
			popupSign  		= PopupwinSign.CreateTablePopWin_sign
			isModel    		= true;
			super.__init__()
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin()
			registerMediator(new CreateTablePopWinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(CreateTablePopWinMediator.NAME);
		}
		
	}
}