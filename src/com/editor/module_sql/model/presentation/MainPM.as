package com.editor.module_sql.model.presentation
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import com.air.sql.SQLType;
	import com.air.sql.SQLiteErrorEvent;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_sql.SqlMamModule;
	import com.editor.module_sql.SqlMamModuleMediator;
	import com.editor.module_sql.events.EncryptionErrorEvent;
	import com.editor.module_sql.events.SqlModEvent;
	import com.editor.module_sql.model.FileManager;
	import com.editor.module_sql.model.MainModel;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.data.SQLColumnSchema;
	import flash.data.SQLIndexSchema;
	import flash.data.SQLResult;
	import flash.data.SQLTableSchema;
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.getTimer;
	
	public class MainPM extends AbstractPM
	{
		public static var instance:MainPM;
		
		public static const TAB_STRUCTURE:int=0;
		public static const TAB_DATA:int=1;
		public static const TAB_INDICES:int=2;
		public static const TAB_SQL:int=3;

		
		public var isValidDBOpen:Boolean=true;
		public var docTitle:String;
		public var fileInfos:String;
		public var lastExecTime:int;
		public var selectedTab:int=0;
		
		// Presentation models
		public var sqlStatementPM:SQLStatementPM ;
		public var tableListPM:TableListPM ;
		public var sqldataViewPM:SQLDataViewPM ;
		public var sqlStructureViewPM:SQLStructureViewPM ;
		public var indicesPM:IndicesPM;

		public var selectedTable:SQLTableSchema;		
		public var selectedColumn:SQLColumnSchema;
		public var selectedRecord:Object;

		
		private var mainModel:MainModel ;
		private var fileManager:FileManager; 		
		private var isOpenedOpenRecentDialog:Boolean = false;
		private var isOpenedOpenDialog:Boolean = false;
		
		public var app:SqlMamModuleMediator;

		public function MainPM(pNativeApp:SqlMamModuleMediator)
		{
			if(instance != null) return ;
			instance = this;
			app = pNativeApp;
			
			mainModel = new MainModel();
			mainModel.addEventListener( SQLiteErrorEvent.EVENT_ERROR, onSQLiteError);
			mainModel.addEventListener( EncryptionErrorEvent.EVENT_ENCRYPTION_ERROR, onEncryptionError);
			
			fileManager = new FileManager();
			fileManager.addEventListener(FileManager.EVENT_IMPORT_FILE_SELECTED, onSQLFileImported);
			
			tableListPM = new TableListPM( this);
			indicesPM = new IndicesPM( this);
			sqldataViewPM = new SQLDataViewPM( this);
			sqlStatementPM = new SQLStatementPM(this);			
			sqlStructureViewPM = new SQLStructureViewPM(this); 
		}
		
		public function get recentlyOpenedFiles():Array
		{
			return fileManager.recentlyOpened;
		}
		
		public function closeDB():void
		{
			mainModel.closeDB();
		}
		
		public function openDBFile(pFile:File, pPassword:String=""):void
		{
			var success:Boolean = mainModel.openDBFile(pFile, false, pPassword);
			if (success){
				onDBOpened(pFile);
				if (pPassword == SQLType.LEGACY_ENCRYPTION_KEY_HASH){
					promptUpgradeEncryption();
				}				
				reflashDatabase();
			}
		}
		
		private function reflashDatabase():void
		{
			tableListPM.dbTables = mainModel.dbTables;
			indicesPM.dbIndices = mainModel.dbIndices;
			app.sendNotification(SqlModEvent.reflashDatabase_event);
		}
		
		public function createDBFile(pFile:File, pPwd:String=""):void
		{
			var success:Boolean = mainModel.createDBFile(pFile, pPwd);
			if(success){
				onDBOpened(pFile);
				tableListPM.createNewTable();
				if(pPwd) showGeneratedKey();
			}
		}
		
		private function showGeneratedKey():void
		{
			var msg:String = "Here's your database's encryption key (Base64 encoded). You can use this key to open your database in other applications. (Use your password to open your DB in Lita.)\n";
			msg+= mainModel.base64Key;
			app.showMessage(msg);
		}

		private function onDBOpened(pFile:File):void
		{
			fileManager.addRecentlyOpened(pFile);
			isValidDBOpen =true;
			updateFileInfos();
			refreshDB();
		}
		
		private function updateFileInfos():void
		{
			docTitle = mainModel.dbFile.name+ " ("+ (mainModel.dbFile.size/1024) +" Kb)";
			fileInfos = mainModel.dbFile.nativePath;			
		}
						
		public function promptCreateNewTable():void
		{
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.CreateTablePopWin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			app.openPopupwin(open);
		}
		
		public function promptOpenFile(pEvt:Event=null):void
		{
			if( isOpenedOpenRecentDialog || isOpenedOpenDialog) return ;
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.OpenDBFilePopWin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			app.openPopupwin(open);
		}

		public function promptCreateDBFile(pEvt:Event=null):void
		{
			if( isOpenedOpenRecentDialog || isOpenedOpenDialog) return ;			
			var open:OpenPopwinData = new OpenPopwinData();
			open.popupwinSign = PopupwinSign.CreateDBDialog_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			app.openPopupwin(open);
		}
		
		public function promptReencrypt():void
		{
			if( mainModel.dbFile==null){
				app.showMessage("Database does not exist !");
				return;
			}
			//mainView.promptReencryptDialog();
		}	
		
		private function promptUpgradeEncryption():void
		{
			//mainView.promptUpgradeEncryptionDialog();
		}

		public function onOpenFileDialogClosed(pEvt:Event):void
		{
			isOpenedOpenRecentDialog = false ;
		}

		private function firstTimeGreetings():void
		{
			//mainView.promptCommercialDialog();
		}
		
		private function refreshDB():void
		{
			tableListPM.dbTables = mainModel.dbTables;
			indicesPM.dbIndices = mainModel.dbIndices;
			
			if( mainModel.dbTables && mainModel.dbTables.length>0) selectTable(mainModel.dbTables[0] );
		}
		
		public function selectTable(pTable:SQLTableSchema):void
		{			
			selectedTable = pTable ;
			selectColumn( null );
			selectRecord( null );
			
			sqlStructureViewPM.selectedTable = selectedTable;	
			sqldataViewPM.selectedTable = selectedTable;		
			tableListPM.selectedTable = selectedTable;
			sqldataViewPM.tableRecords = mainModel.tableRecords;	
			
			refreshRecords();			
		}
		
		public function emptyTable():void
		{			
			mainModel.emptyTable(selectedTable);			
			selectedRecord = null ;
			sqldataViewPM.tableRecords = mainModel.tableRecords;
		}
		
		public function renameTable(pName:String):void
		{	
			var table:SQLTableSchema = mainModel.renameTable(selectedTable,  pName);
			tableListPM.dbTables = mainModel.dbTables;
			selectTable(table);
		}		

		public function createTable(pName:String, pDefinition:String):void
		{
			var table:SQLTableSchema = mainModel.createTable(pName, pDefinition);
			tableListPM.dbTables = mainModel.dbTables;
			if(table) selectTable(table);
			selectedTab = TAB_STRUCTURE;
			reflashDatabase();
		}
		
		public function copyTable(pName:String, pCopyData:Boolean):void
		{
			var table:SQLTableSchema = mainModel.copyTable(selectedTable, pName, pCopyData);
			tableListPM.dbTables = mainModel.dbTables;
			if(table) selectTable(table);	
		}
				
		public function dropTable():void
		{
			mainModel.dropTable(selectedTable);
			selectTable(null);
			selectColumn(null);
			selectRecord(null);
			
			tableListPM.dbTables = mainModel.dbTables;
			reflashDatabase();
			app.sendNotification(SqlModEvent.dropTable_event);
		}
		
		public function exportTable():void
		{
			if(selectedTable == null) return ;
			var createString:String = selectedTable.sql;
			fileManager.createExportFile(createString);			
		}
			
		public function selectRecord(pData:Object):void
		{
			selectedRecord = pData;
			sqldataViewPM.selectedRecord = selectedRecord;
			app.sendNotification(SqlModEvent.selectRecord_event,pData);
		}
		
		public function createRecord(pRecord:Object):void
		{
			var obj:Object = mainModel.createRecord(selectedTable, pRecord);	
			sqldataViewPM.tableRecords = mainModel.tableRecords;
			selectRecord(obj);	
		}
		
		public function updateRecord(pRecord:Object):void
		{			
			var obj:Object = mainModel.updateRecord(selectedTable, selectedRecord, pRecord);
			sqldataViewPM.tableRecords = mainModel.tableRecords;
			selectRecord(obj);	
			reflashSelectTable();
		}
		
		public function reflashSelectTable():void
		{
			app.sendNotification(SqlModEvent.selectTable_event);
		}
						
		public function deleteRecord():void
		{
			mainModel.deleteRecord(selectedTable, selectedRecord);
			sqldataViewPM.tableRecords = mainModel.tableRecords;
			selectRecord(null);	
			reflashSelectTable();
		}
				
		public function exportRecords():void
		{
			var str:String = mainModel.exportRecords(selectedTable);
			fileManager.createExportFile(str);	
		}
		
		public function refreshRecords():void
		{
			mainModel.refreshRecords(selectedTable);
			sqldataViewPM.tableRecords = mainModel.tableRecords;
			reflashSelectTable();
		}
		
		public function addIndex(pName:String):void
		{
			mainModel.addIndex(selectedTable, selectedColumn, pName);
			//indicesPM.dbIndices = mainModel.dbIndices;
			selectedTab=TAB_INDICES;			
		}
			
		public function removeIndex(pIndex:SQLIndexSchema):void
		{
			mainModel.removeIndex(pIndex);
			//indicesPM.dbIndices = mainModel.dbIndices;
		}
		
		public function selectColumn(pCol:SQLColumnSchema):void
		{
			selectedColumn = pCol;
			sqlStructureViewPM.selectedColumn = pCol;
			app.sendNotification(SqlModEvent.selectedColumn_event);		
		}
		
		public function renameColumn(pName:String):void
		{
			if(selectedTable == null) return ;
			var i:int = selectedTable.columns.indexOf(selectedColumn);
			var table:SQLTableSchema = mainModel.renameColumn(selectedTable, selectedColumn, pName);
			tableListPM.dbTables = mainModel.dbTables;
			selectTable(table);
			if(selectedTable == null) return ;
			selectColumn(selectedTable.columns[i]);
			reflashDatabase();
		}
		
		public function createColumn(pName:String, pDataType:String, pAllowNull:Boolean, pUnique:Boolean, pDefault:String):void
		{			
			var table:SQLTableSchema = mainModel.addColumn(selectedTable, pName, pDataType, pAllowNull, pUnique, pDefault);
			selectTable(table);
			selectColumn( selectedTable.columns[ selectedTable.columns.length-1 ]);		
			reflashDatabase();
		}
		
		public function dropColumn():void
		{
			var table:SQLTableSchema = mainModel.removeColumn(selectedTable, selectedColumn.name);
			selectTable(table);
			selectColumn(null);		
			reflashDatabase();
		}
				
		public function executeStatement(pStatement:String):void
		{			
			if(StringTWLUtil.isWhitespace(pStatement)) return ;
			var sqlResult:SQLResult =  mainModel.executeStatement(pStatement);
			if( sqlResult==null) sqlStatementPM.results=[];
			
			else {
				 sqlStatementPM.results = sqlResult.data;
				if( ! sqlStatementPM.persoStatementHist.contains(pStatement))  sqlStatementPM.persoStatementHist.addItem( pStatement );			
			}			
			app.sendNotification(SqlModEvent.reflashStatementData_event);
		}
		
		public function importStatementFromFile():void
		{
			fileManager.importFromFile();
		}
		
		private function onSQLFileImported(pEvt:Event):void
		{
			sqlStatementPM.statement = fileManager.importedSQL;
		}
		
		public function exportStatements(pStatement:String):void
		{
			fileManager.createExportFile(pStatement );
		}
				
		public function compact():void
		{
			if(!isValidDBOpen){
				app.showMessage("Database does not exist !");
				return;
			}
						
			var done:Boolean = mainModel.compact();
			if( done){
				app.showMessage("Database compacting done !");
				updateFileInfos();
			} 
			else app.showMessage("Unable to compact database");
		}
		
		public function exportDB():void
		{
			if(!isValidDBOpen){
				app.showMessage("Database does not exist !");
				return ;
			}
			var createString:String = mainModel.exportDB();
			fileManager.createExportFile( createString );
		}
		
		public function reencrypt(pPwd:String):void
		{
			if(!isValidDBOpen){
				app.showMessage("Database does not exist !");
				return;
			}
			mainModel.reencrypt( pPwd);
			showGeneratedKey();
		}
		
		private function onSQLiteError(pEvt:SQLiteErrorEvent):void
		{
			var msg:String = pEvt.error.message;
			app.showMessage(pEvt.error.toString());
		}
		
		private function onEncryptionError(pEvt:EncryptionErrorEvent):void
		{
			var msg:String = pEvt.error.message;
			app.showMessage(msg);
		}

	}
}