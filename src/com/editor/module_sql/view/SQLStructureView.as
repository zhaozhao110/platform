package com.editor.module_sql.view
{
	import com.air.sql.SQLType;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_sql.mediator.SQLStructureViewMediator;
	import com.editor.module_sql.model.presentation.SQLStructureViewPM;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.data.SQLColumnSchema;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class SQLStructureView extends UIVBox
	{
		public function SQLStructureView()
		{
			super()
			
		}
		
		
		public var tableNameTi:UITextInput;
		public var columnsDG:SandyDataGrid
		public var selectedColNameTi:UITextInput;
		public var dataTypeLabel:UILabel
		public var indexNameTi:UITextInput;
		public var colNameTi:UITextInput;
		public var typeACTI:UICombobox;
		public var defaultTi:UITextInput;
		public var nullCB:UICheckBox;
		public var uniqueCb:UICheckBox;
		public var addFiledBt:UIButton;
		public var checkbox96:UICheckBox;
		public var checkbox98:UICheckBox;
		public var checkbox100:UICheckBox
		
		//程序生成
		public function create_init():void
		{
			padding = 10;
			verticalGap = 5;
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
			hb.paddingLeft = 10;
			hb.verticalAlign = ASComponentConst.verticalAlign_middle;
			hb.percentWidth = 100;
			hb.horizontalGap =5;
			addChild(hb);
			
			var label77:UILabel = new UILabel();
			label77.text="Table Name"
			
			hb.addChild(label77);
			
			tableNameTi = new UITextInput();
			tableNameTi.id="tableNameTi"
			tableNameTi.enterKeyDown_proxy= function():void{pm.renameTable( tableNameTi.text);};
			tableNameTi.width=118
			hb.addChild(tableNameTi);
			
			var button78:UIButton = new UIButton();
			button78.label="Rename"
			button78.addEventListener('click',function(e:*):void{pm.renameTable( tableNameTi.text);});
			hb.addChild(button78);
			
			var button79:UIButton = new UIButton();
			button79.label="Export Structure"
			button79.addEventListener('click',function(e:*):void{ pm.exportTable();});
			hb.addChild(button79);
			
			var button80:UIButton = new UIButton();
			button80.label="Delete Table"
			button80.addEventListener('click',function(e:*):void{ pm.askDropCurrentTable();});
			hb.addChild(button80);
			
			var compactBtn:UIButton = new UIButton();
			compactBtn.label = "compactDB"
			compactBtn.addEventListener('click',function(e:*):void{ pm.mainPM.compact();});
			hb.addChild(compactBtn);
			
			
			columnsDG = new SandyDataGrid();
			columnsDG.id="columnsDG"
			columnsDG.addEventListener('change',function(e:*):void{ pm.selectColumn( columnsDG.selectedItem as SQLColumnSchema );});
			columnsDG.enabledPercentSize = true;
			this.addChild(columnsDG);
			
			var columns82:Array = [];
						
			var datagridcolumn83:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn83.headerText="Field Name"
			datagridcolumn83.dataField="name"
			datagridcolumn83.columnWidth = 200
			columns82.push(datagridcolumn83);
			
			var datagridcolumn84:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn84.headerText="Data Type"
			datagridcolumn84.dataField="dataType"
			datagridcolumn84.columnWidth=100
			columns82.push(datagridcolumn84);
			
			var datagridcolumn85:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn85.headerText="Type Affinity"
			datagridcolumn85.dataField="dataType"
			datagridcolumn85.labelFunction=getAffinity
			datagridcolumn85.columnWidth=100
			columns82.push(datagridcolumn85);
			
			var datagridcolumn86:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn86.headerText="Primary Key"
			datagridcolumn86.dataField="primaryKey"
			datagridcolumn86.columnWidth=100
			columns82.push(datagridcolumn86);
			
			var datagridcolumn87:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn87.headerText="Allow Null"
			datagridcolumn87.dataField="allowNull"
			datagridcolumn87.columnWidth=100
			columns82.push(datagridcolumn87);
			
			var datagridcolumn88:ASDataGridColumn = new ASDataGridColumn();
			datagridcolumn88.headerText="Auto Increment"
			datagridcolumn88.dataField="autoIncrement"
			datagridcolumn88.columnWidth=100
			columns82.push(datagridcolumn88);
			
			columnsDG.columns = columns82;
			
			
			
			
			
			var hbox89:UIHBox = new UIHBox();
			hbox89.height=273
			hbox89.percentWidth = 100;		
			hbox89.horizontalGap = 10;
			this.addChild(hbox89);
			
			
			var form90:UIForm = new UIForm();
			form90.styleName = "uicanvas"
			form90.leftWidth = 150
			form90.percentHeight=100
			form90.width = 400
			form90.paddingLeft = 5;
			form90.paddingTop = 5;
			form90.verticalGap = 10;
			hbox89.addChild(form90);
			
			var formheading91:UILabel = new UILabel();
			formheading91.formLabel="Selected Field"
			form90.addFormItem(formheading91);
			
			var hb1:UIHBox = new UIHBox();
			hb1.formLabel = "Field Name";
			form90.addFormItem(hb1);
			
			selectedColNameTi = new UITextInput();
			selectedColNameTi.label="Field Name"
			selectedColNameTi.id="selectedColNameTi"
			selectedColNameTi.width = 150;
			hb1.addChild(selectedColNameTi);
			
			var button93:UIButton = new UIButton();
			button93.label="Rename"
			button93.addEventListener('click',function(e:*):void{ pm.renameColumn( selectedColNameTi.text);;});
			hb1.addChild(button93);
			
			dataTypeLabel = new UILabel();
			dataTypeLabel.formLabel = "Field Type";
			dataTypeLabel.id="dataTypeLabel"
			form90.addFormItem(dataTypeLabel);
			
			checkbox96 = new UICheckBox();
			checkbox96.formLabel="Allow null"
			form90.addFormItem(checkbox96);
			
			checkbox98 = new UICheckBox();
			checkbox98.formLabel="Is Primary key"
			form90.addFormItem(checkbox98);
			
			checkbox100 = new UICheckBox();
			checkbox100.formLabel="Auto increment"
			form90.addFormItem(checkbox100);
			
			/*var hb2:UIHBox = new UIHBox();
			hb2.formLabel = "Add Index"
			form90.addFormItem(hb2);
			
			indexNameTi = new UITextInput();
			indexNameTi.id="indexNameTi"
			hb2.addChild(indexNameTi);
			
			var button102:UIButton = new UIButton();
			button102.label="Add"
			button102.addEventListener('click',function(e:*):void{ pm.addIndex( indexNameTi.text); indexNameTi.text='';});
			hb2.addChild(button102);*/
			
			var button105:UIButton = new UIButton();
			button105.formLabel="Delete Field"
			button105.label = "Delete Field"
			button105.addEventListener('click',function(e:*):void{ pm.askDropColumn();});
			form90.addFormItem(button105);
						
			
			var form106:UIForm = new UIForm();
			form106.percentHeight=100
			form106.width = 400
			form106.leftWidth =150;
			form106.styleName = "uicanvas"
			form106.paddingLeft = 5;
			form106.paddingTop = 5;
			form106.verticalGap = 10;
			hbox89.addChild(form106);
			
			var formheading107:UILabel = new UILabel();
			formheading107.formLabel="New Field"
			form106.addFormItem(formheading107);
			
			colNameTi = new UITextInput();
			colNameTi.formLabel="Field Name"
			colNameTi.id="colNameTi"
			colNameTi.width = 150;
			form106.addFormItem(colNameTi);
			
			typeACTI = new UICombobox();
			typeACTI.id="typeACTI"
			typeACTI.formLabel="Field Type"
			typeACTI.selectedIndex=0
			typeACTI.width = 150;
			typeACTI.height = 20;
			typeACTI.dataProvider=SQLType.AFFINITY_TYPES;
			form106.addFormItem(typeACTI);
			typeACTI.selectedIndex = 0;
			
			defaultTi = new UITextInput();
			defaultTi.formLabel="Default Value"
			defaultTi.id="defaultTi"
			defaultTi.width = 150;
			form106.addFormItem(defaultTi);
			
			nullCB = new UICheckBox();
			nullCB.id="nullCB"
			nullCB.formLabel="Allow null"
			nullCB.selected=true
			form106.addFormItem(nullCB);
			
			uniqueCb = new UICheckBox();
			uniqueCb.id="uniqueCb"
			uniqueCb.formLabel="Unique"
			form106.addFormItem(uniqueCb);
			
			addFiledBt = new UIButton();
			addFiledBt.id="addFiledBt"
			addFiledBt.formLabel="Create Field"
			addFiledBt.label="Create Field"
			addFiledBt.addEventListener('click',function(e:*):void{ addField();;});
			form106.addFormItem(addFiledBt);
			
			//dispatchEvent creationComplete
			initComplete();
		}
		
		
		public var pm:SQLStructureViewPM;
		
		private function getAffinity(pItem:Object, pCol:ASDataGridColumn):String
		{
			var col:SQLColumnSchema = pItem as  SQLColumnSchema;
			return SQLType.getAffinity( col.dataType);
		}
		
		private function addField():void
		{				
			if(StringTWLUtil.isWhitespace(colNameTi.text)) return ;
			if(typeACTI.htmlText=="") typeACTI.htmlText="TEXT";	
			SQLStructureViewMediator(bindingMediator).tableSelectedIndex = -1;
			pm.addColumn(colNameTi.text, typeACTI.htmlText, nullCB.selected, uniqueCb.selected, defaultTi.text);
			colNameTi.text="";
			colNameTi.setFocus();
		}	
		
		
	}
}