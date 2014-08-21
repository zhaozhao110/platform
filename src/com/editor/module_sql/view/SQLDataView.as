package com.editor.module_sql.view
{
	import com.air.sql.SQLType;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_sql.mediator.SQLDataViewMediator;
	import com.editor.module_sql.model.presentation.SQLDataViewPM;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.data.SQLColumnSchema;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class SQLDataView extends UIVBox
	{
		public function SQLDataView()
		{
			super()
			//create_init()
		}
		
		
		public var dataDG:SandyDataGrid;
		public var dynForm:UIForm;
		public var dynForm2:UIForm;
		public var clearFormCB:UICheckBox;
		public var exportXML:UIButton;
		public var exportJson:UIButton;

		//程序生成
		public function create_init():void
		{
			padding = 10;
			verticalGap = 10;
			
			var hb:UIHBox = new UIHBox();
			hb.verticalAlign = ASComponentConst.verticalAlign_middle;
			hb.percentWidth = 100;
			hb.paddingLeft = 20;
			hb.height = 30;
			addChild(hb);
			
			var label55:UILabel = new UILabel();
			label55.x=10
			label55.y=12
			//label55.text= pm.tableRecords.length } record(s.toString()
			hb.addChild(label55);
			
			exportXML = new UIButton();
			exportXML.label="Export Data to xml"
			hb.addChild(exportXML);
			
			exportJson = new UIButton();
			exportJson.label="Export Data to json"
			hb.addChild(exportJson);
			
			var button57:UIButton = new UIButton();
			button57.label="Refresh"
			button57.addEventListener('click',function(e:*):void{ pm.refresh();});
			hb.addChild(button57);
			
			dataDG = new SandyDataGrid();
			dataDG.enabledPercentSize = true;
			dataDG.horizontalScrollPolicy="auto"
			dataDG.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			//dataDG.selectedItem= pm.selectedRecord
			dataDG.addEventListener('change',function(e:*):void{ selectRecord (dataDG.selectedItem);});
			
			addChild(dataDG);
			
			var hb2:UIHBox = new UIHBox();
			hb2.percentWidth = 100;
			hb2.horizontalGap = 20;
			hb2.height = 300;
			addChild(hb2);
			
			dynForm = new UIForm();
			dynForm.styleName = "uicanvas"
			dynForm.percentHeight = 100;
			dynForm.width = 450;
			dynForm.leftWidth = 100;
			dynForm.rowHeight = 50;
			dynForm.paddingLeft = 2;
			dynForm.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			hb2.addChild(dynForm);
			
			var formheading61:UILabel = new UILabel();
			formheading61.formLabel="Selected Record"
			dynForm.addFormItem(formheading61);
			
			var button63:UIButton = new UIButton();
			button63.formLabel="Save Record"
			button63.label = "Save Record"
			button63.addEventListener('click',saveRecord);
			dynForm.addFormItem(button63);
			
			var button65:UIButton = new UIButton();
			button65.formLabel="Delete record"
			button65.label = "Delete record"
			button65.addEventListener('click',function(e:*):void{ pm.deleteRecord();});
			dynForm.addFormItem(button65);
			
			dynForm2 = new UIForm();
			dynForm2.id="dynForm2"
			dynForm2.styleName = "uicanvas"
			dynForm2.percentHeight = 100;
			dynForm2.width = 450;
			dynForm2.leftWidth = 100;
			dynForm2.rowHeight = 50;
			dynForm2.paddingLeft = 2;
			dynForm2.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			hb2.addChild(dynForm2);
			
			var formheading66:UILabel = new UILabel();
			formheading66.formLabel="New Record"
			dynForm2.addFormItem(formheading66);
			
			var formitem67:UIHBox = new UIHBox();
			formitem67.formLabel="Add Record"
			formitem67.width = 300;
			dynForm2.addFormItem(formitem67);
			
			var button68:UIButton = new UIButton();
			button68.label="Add Record"
			button68.addEventListener('click',function(e:*):void{ createRecord(clearFormCB.selected);;});
			formitem67.addChild(button68);
			
			clearFormCB = new UICheckBox();
			//clearFormCB.selected=true
			clearFormCB.label="Add another record"
			formitem67.addChild(clearFormCB);
			
			initComplete();
			onCreationComplete()
		}
		
		public var pm:SQLDataViewPM;
		private var colToComponent:Object;			
		private var colToComponent2:Object;			
		private var defaultComp:ASComponent;
		
				
		private function onCreationComplete():void
		{
			pm.addEventListener(SQLDataViewPM.EVENT_TABLE_SELECTED, onTableSelected);		
		}	
				
		private function onTableSelected(pEvt:Event):void
		{
			prepareViewsForTable();	
		}
		
		public function prepareViewsForTable():void
		{
			if(pm.selectedTable == null) return ;
			clearForms();
						
			colToComponent = {};
			colToComponent2 = {};
			
			var coltab:Array = [] ;
			var totalCols:int = pm.selectedTable.columns.length;
			
			for(var i:int=totalCols-1;i>=0;i--){
				var col:SQLColumnSchema = pm.selectedTable.columns[i] as SQLColumnSchema;
								
				var comp:ASComponent = getCompByType( col.dataType);
				var comp2:ASComponent = getCompByType( col.dataType);
				
				comp.formLabel = col.name;
				comp2.formLabel = col.name;
				
				comp.width = 420;
				comp2.width = 420
				
				if(col.autoIncrement==false) defaultComp = comp2;
				
				/*if(col.autoIncrement) 
				{
					var cb:PKCheckBoxLock = new PKCheckBoxLock();
					cb.targetComp = comp2;
					comp2.enabled=false;
					formItem2.add(cb);
				}*/
				
				dynForm.addFormItem( comp, 1);
				dynForm2.addFormItem( comp2, 1);
				
				colToComponent[col.name] = comp;
				colToComponent2[col.name] = comp2;
				
				var dgc:ASDataGridColumn = new ASDataGridColumn(col.name);
				dgc.dataField = col.name;
				dgc.columnWidth = ( (this.width-20) / (totalCols) );
				coltab.push(dgc);
			}
			
			dataDG.columns = coltab.reverse() ;
		}		
		
		private function clearForms():void
		{
			defaultComp = null;
			
			for(var z:String in colToComponent){
				dynForm.removeFormItem(colToComponent[z].parent);				
			}
			for(var z2:String in colToComponent2){
				dynForm2.removeFormItem(colToComponent2[z2].parent);
			}
			
			dynForm.vscrollToUp(true);
			dynForm2.vscrollToUp(true);
		}
				
		private function selectRecord(pData:Object):void
		{
			pm.selectRecord(pData);
		}
		
		public function fillSelectionForm(pData:Object):void
		{
			if(pm.selectedTable==null) return;	
			for(var i:int=0;i<pm.selectedTable.columns.length;i++)
			{
				var col:SQLColumnSchema = pm.selectedTable.columns[i] as SQLColumnSchema;		
				var affinity:String = SQLType.getAffinity(col.dataType) ;	
				switch (affinity)
				{
					case SQLType.BOOLEAN:
						var cb:UICheckBox = colToComponent[col.name] as UICheckBox;
						cb.height = 25;
						if( pData==null) cb.selected = false ;
						else cb.selected = pData[col.name];
						break;
					/*
					case SQLType.DATE:
						var df:DateTimeEditor = colToComponent[col.name] as DateTimeEditor;
						if( pData==null)  df.selectedDate = null ;
						else df.selectedDate = pData[col.name];						
						break;*/	
					case SQLType.TEXT:
						var ta:UITextArea = colToComponent[col.name] as UITextArea;
						ta.width = 250;
						ta.height = 50;
						if( pData==null)  ta.text = "";
						else ta.text = pData[col.name];
						break;						
					case SQLType.XML:
					case SQLType.XMLLIST:
						var ta2:UITextArea = colToComponent[col.name] as UITextArea;
						ta2.width = 250;
						ta2.height = 50;
						if( pData==null)  ta2.text = "";
						else ta2.text = (pData[col.name] as XML).toXMLString();
						break;								
					case SQLType.OBJECT:						
						var lab:UILabel = colToComponent[col.name] as UILabel;
						lab.height = 25;
						if( pData==null)  lab.text = "";
						else lab.text = pData[col.name];
						break;						
					default:
						var ti:UITextInput = colToComponent[col.name] as UITextInput;
						ti.width = 250;
						ti.height = 25;
						if( pData==null)  ti.text = "";
						else ti.text = pData[col.name];						
						break;
				}					
			}			
		}	
		
		private function makeItemFrom(pCol2Comp:Object):Object
		{
			if(pm == null) return null;
			if(pm.selectedTable == null) return null;
			var vo:Object = {};
			for(var i:int=0;i<pm.selectedTable.columns.length;i++)
			{
				var col:SQLColumnSchema = pm.selectedTable.columns[i] as SQLColumnSchema;
				var affinity:String = SQLType.getAffinity(col.dataType) ;
				switch ( affinity)
				{
					case SQLType.BOOLEAN:
						var cb:UICheckBox = pCol2Comp[col.name] as UICheckBox;
						vo[ col.name ] = cb.selected ;
						break;		
					/*case SQLType.DATE:
						var df:DateTimeEditor = pCol2Comp[col.name] as DateTimeEditor;
						vo[ col.name ] = df.selectedDate;//DateField.dateToString( df.selectedDate, "YYYY-MM-DD" ) ;
						break;*/			
					case SQLType.TEXT:
						var ta:UITextArea = pCol2Comp[col.name] as UITextArea;
						vo[ col.name ] = ta.text; 
						break;						
					
					case SQLType.XML:
					case SQLType.XMLLIST:
						var ta2:UITextArea = pCol2Comp[col.name] as UITextArea;
						vo[ col.name ] = new XML(ta2.text); 
						break;									
					case SQLType.REAL:
					case SQLType.NUMERIC:
						var numTi:UITextInput = pCol2Comp[col.name] as UITextInput;
						vo[ col.name ] = Number(numTi.text); 
						break;									
					case SQLType.INTEGER:
						var intTi:UITextInput = pCol2Comp[col.name] as UITextInput;
						vo[ col.name ] = int(intTi.text); 
						break;								
					case SQLType.OBJECT:
						// you can't edit objects
						break;						
					case SQLType.NONE:
						var ti:UITextInput = pCol2Comp[col.name] as UITextInput;
						vo[ col.name ] = ti.text;						
						break;
				}			
			}	
			return vo;			
		}
		
		private function getCompByType(pType:String):ASComponent
		{
			var affinity:String = SQLType.getAffinity( pType);
			switch ( affinity)
			{
				case SQLType.BOOLEAN:
					return new UICheckBox();
					break;
				/*case SQLType.DATE:
					return new DateTimeEditor();
					break;*/
				case SQLType.INTEGER:
					var ti:UITextInput = new UITextInput();
					ti.restrict="-0123456789";
					return ti;
					break;
				case SQLType.REAL:
				case SQLType.NUMERIC:					
					var ti2:UITextInput = new UITextInput();
					ti2.restrict = "-0.123456789";
					return ti2; 
					break;		
				case SQLType.TEXT:
				case SQLType.XML:
				case SQLType.XMLLIST:
					var ta:UITextArea =new UITextArea();
					ta.percentWidth=100;
					ta.height=50;
					return ta;
					break;	
				case SQLType.OBJECT:
					return new UILabel();
					break;	
				case SQLType.NONE:
					return new UITextInput();
					break;
			}
			return null;
		}	
		
		private function createRecord(pClear:Boolean):void
		{
			var obj:Object = makeItemFrom( colToComponent2 );
			if(obj == null) return ;
			pm.createRecord(obj);
			if(pClear) {
				prepareViewsForTable();
				defaultComp.setFocus();
			}
			//fillSelectionForm( pm.selectedRecord);
			pm.mainPM.reflashSelectTable();
		}
		
		private function saveRecord(e:MouseEvent):void
		{
			SQLDataViewMediator(bindingMediator).tableSelectedIndex = -1;
			pm.updateRecord( makeItemFrom( colToComponent));
		}
		
	}
}