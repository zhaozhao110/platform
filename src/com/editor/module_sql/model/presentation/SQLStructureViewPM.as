package com.editor.module_sql.model.presentation
{
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.data.SQLColumnSchema;
	import flash.data.SQLTableSchema;
	
	public class SQLStructureViewPM extends AbstractPM
	{
		
		
		public var selectedColumn:SQLColumnSchema;
		public var selectedTable:SQLTableSchema;
		
		public var isNewFieldFormEnabled:Boolean=true;
		
		public var mainPM:MainPM;
		
		public function SQLStructureViewPM(pMainPM:MainPM)
		{
			mainPM = pMainPM;
		}
		
		public function addIndex(pName:String):void
		{
			mainPM.addIndex(pName);
		}
		
		public function selectColumn(pCol:SQLColumnSchema):void
		{
			mainPM.selectColumn(pCol);
		}
		
		public function renameColumn(pName:String):void
		{
			mainPM.renameColumn(pName);
		}
		
		
		public function addColumn(pName:String, pType:String, pNull:Boolean, pUnique:Boolean, pDefault:String):void
		{
			mainPM.createColumn(pName, pType, pNull, pUnique, pDefault);
		}
		
		public function renameTable(pNewName:String):void
		{
			mainPM.renameTable(pNewName);
		}
		
		public function exportTable():void
		{
			mainPM.exportTable();
		}

		public function copyTable(pNewName:String, pCopyData:Boolean):void
		{
			mainPM.copyTable(pNewName, pCopyData);
		}
		
		public function askDropCurrentTable():void
		{				
			var d:OpenMessageData = new OpenMessageData();
			d.info = "Are you sure you want to drop this table?", 
			d.okFunction = dropTableAnswer;
			mainPM.app.showConfirm(d);
		}
		
		private function dropTableAnswer(pEvt:*=null):Boolean
		{
			mainPM.dropTable();
			return true
		}

		public function askDropColumn():void
		{
			if(selectedColumn == null) return 
			var d:OpenMessageData = new OpenMessageData();
			d.info = "Are you sure you want to drop this field ("+ selectedColumn.name+")?", 
			d.okFunction = dropColumnAnswer;
			mainPM.app.showConfirm(d);
		}

		private function dropColumnAnswer(pEvt:*=null):Boolean
		{
			mainPM.dropColumn();
			return true
		}		

		
	}
}