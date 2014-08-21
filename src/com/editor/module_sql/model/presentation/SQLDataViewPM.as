package com.editor.module_sql.model.presentation
{
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.data.SQLTableSchema;
	import flash.events.Event;
	
	public class SQLDataViewPM extends AbstractPM
	{
		public static const EVENT_TABLE_SELECTED:String= "tableSelected";
		
		public var tableRecords:Array
		public var selectedRecord:Object;
		
		public var mainPM:MainPM;
		private var _selectedTable:SQLTableSchema;

		public function get selectedTable():SQLTableSchema
		{
			return _selectedTable;
		}
		
		public function set selectedTable(pTable:SQLTableSchema):void
		{
			_selectedTable = pTable;
			dispatchEvent(new Event(EVENT_TABLE_SELECTED));
		}
		
		public function SQLDataViewPM(pMainPM:MainPM)
		{
			mainPM = pMainPM;
		}

		public function selectRecord(pData:Object):void
		{
			if(pData!=selectedRecord) mainPM.selectRecord(pData);			
		}	

		public function updateRecord(pModifiedItem:Object):void
		{			
			if(pModifiedItem == null) return ;
			mainPM.updateRecord(pModifiedItem);
		}

		public function createRecord(pNewItem:Object):void
		{
			mainPM.createRecord(pNewItem);
		}

		public function refresh():void
		{
			mainPM.refreshRecords();
		}

		public function exportRecords():void
		{
			if( tableRecords == null){
				trace("Nothing to export !", "Error");
				return;
			}
			mainPM.exportRecords();
		}
		
		public function deleteRecord():void
		{
			var d:OpenMessageData = new OpenMessageData();
			d.info = "Are you sure you want to delete this record ?"
			d.okFunction = deleteRecordAnswer;
			mainPM.app.showConfirm(d);
		}
		
		private function deleteRecordAnswer(pEvt:*=null):Boolean
		{
			mainPM.deleteRecord();
			return true
		}		
	}
}