package com.editor.module_sql.mediator
{
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.module_sql.SqlMamModule;
	import com.editor.module_sql.model.presentation.SQLDataViewPM;
	import com.editor.module_sql.view.SQLDataView;
	import com.editor.module_sql.view.TableListView;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	
	public class SQLDataViewMediator extends AppMediator
	{
		public static const NAME:String = "SQLDataViewMediator"
		public function SQLDataViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get dataView():SQLDataView
		{
			return viewComponent as SQLDataView;
		}
		public function get dataDG():SandyDataGrid
		{
			return dataView.dataDG;
		}
		public function get pm():SQLDataViewPM
		{
			return dataView.pm;
		}
		public function get exportXML():UIButton
		{
			return dataView.exportXML;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			dataView.exportJson.addEventListener(MouseEvent.CLICK , onToJson)
			
			respondToSelectTableEvent();
		}
		
		public var tableSelectedIndex:int=-1;
		
		public function respondToSelectTableEvent(noti:Notification=null):void
		{
			if(dataDG.numChildren > 0 ){
				if(SqlMamModule.tabNavSelectedIndex != 1) return ;
				//if(TableListView.tableSelectedIndex == tableSelectedIndex) return ;
				if(pm.selectedTable == null) return ;
			}
			tableSelectedIndex = TableListView.tableSelectedIndex;
			dataDG.removeHeader();
			dataView.prepareViewsForTable();
			dataDG.dataProvider=pm.tableRecords;
			if(dataDG.selectedIndex == -1){
				dataDG.setSelectIndex(0,true,true);
			}else{
				dataDG.setSelectIndex(dataDG.selectedIndex,true,true);
			}
		}
		
		public function respondToSqlMamNavTabChangeEvent(noti:Notification):void
		{
			respondToSelectTableEvent();
		}
		
		public function respondToSelectRecordEvent(noti:Notification):void
		{
			dataView.fillSelectionForm(noti.getBody());
		}
		
		public function reactToExportXMLClick(e:MouseEvent):void
		{
			if(pm.selectedTable == null) return ;
			var xml:String = '<?xml version="1.0" encoding="utf-8" ?>'+"\n";
			xml += "<l>"+"\n";
			var a:Array = pm.tableRecords;
			if(a == null) return ;
			for(var i:int=0;i<a.length;i++){
				var obj:Object = a[i];
				var cc:String = "<i ";
				for(var o:* in obj){
					if(StringTWLUtil.isWhitespace(obj[o])){
						cc += " " + o + '="' + "" + '"';
					}else{
						cc += " " + o + '="' + obj[o] + '"';
					}
				}
				cc += " />" + "\n"
				xml += cc;
			}
			xml += "</l>"
			var file:FileReference = new FileReference();
			file.save(xml,pm.selectedTable.name+".xml");
		}
		
		public function onToJson(e:MouseEvent):void
		{
			if(pm.selectedTable == null) return ;
			var a:Array = pm.tableRecords;
			if(a == null) return ;
			var file:FileReference = new FileReference();
			file.save(JSON.stringify(a),pm.selectedTable.name+".json");
		}
		
	}
}