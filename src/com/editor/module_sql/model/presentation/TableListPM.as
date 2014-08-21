package com.editor.module_sql.model.presentation
{
	import flash.data.SQLTableSchema;
	
	public class TableListPM extends AbstractPM
	{
		
		public var selectedTable:SQLTableSchema;
		public var dbTables:Array
		
		private var mainPM:MainPM;
		
		public function TableListPM(pMainPM:MainPM)
		{
			mainPM = pMainPM;
		}
		

		public function selectTable(pTable:SQLTableSchema):void
		{							
			mainPM.selectTable(pTable);
		}		
		
		public function createNewTable():void
		{
			mainPM.promptCreateNewTable();
		}	

				
	}
}