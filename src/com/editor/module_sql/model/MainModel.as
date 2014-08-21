package com.editor.module_sql.model
{
	
	import com.air.encrypt.Base64Decoder;
	import com.air.encrypt.Base64Encoder;
	import com.air.sql.SQLType;
	import com.air.sql.SQLiteDBHelper;
	import com.air.sql.SQLiteErrorEvent;
	import com.editor.module_sql.events.EncryptionErrorEvent;
	import com.sandy.encrypt.SimpleEncryptionKeyGenerator;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.data.SQLColumnSchema;
	import flash.data.SQLIndexSchema;
	import flash.data.SQLResult;
	import flash.data.SQLSchemaResult;
	import flash.data.SQLTableSchema;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class MainModel extends EventDispatcher
	{		
		public var dbFile:File ;
		public var base64Key:String;
		public var dbTables:Array ;
		public var dbIndices:Array;
		public var dbViews:Array;
		public var tableRecords:Array;		
				
		private var db:SQLiteDBHelper;
		private var schemas:SQLSchemaResult;
						
		public function MainModel()
		{
			db = new SQLiteDBHelper();
			//db.addEventListener(SQLiteErrorEvent.EVENT_ERROR, onSQliteError);
		}
		
		private function onSQliteError(pEvt:SQLiteErrorEvent):void
		{
			dispatchEvent(pEvt);
		}
		
		public function closeDB():void
		{
			if(db!=null){
				db.close();
			}
		}
				
		public function openDBFile(pFile:File, isNew:Boolean=false, pPassword:String=""):Boolean
		{
			dbFile = pFile ;
			var key:ByteArray;
			// First, if we have a password, we'll generate a key
			if(pPassword && pPassword.length > 0){
				// if they entered the Base64 encryption key instead of a password
				if (pPassword.length == 24 && pPassword.lastIndexOf("==") == 22)
				{
					var decoder:Base64Decoder = new Base64Decoder();
					decoder.decode(pPassword);
					key = decoder.toByteArray();
				}
				// if it's a legacy encrypted db
				else if (pPassword == SQLType.LEGACY_ENCRYPTION_KEY_HASH) 
				{
					key = legacyGenerateEncryptionKey(pPassword);
				}				
				// for every other cases
				else
				{
					try{
						key = new SimpleEncryptionKeyGenerator().getEncryptionKey(pPassword);					
					}catch(e:ArgumentError){
						dispatchEvent( new EncryptionErrorEvent(EncryptionErrorEvent.EVENT_ENCRYPTION_ERROR, e));
						return false;
					}					
				}
			}

			var success:Boolean = db.openDBFile(dbFile, key);
			if(success==false) return false;
			loadSchema(); 
			return true;				
		}
		
		public function createDBFile(pFile:File, pPassword:String=""):Boolean
		{
			dbFile = pFile ;
			var key:ByteArray;
			if(pPassword && pPassword.length>0){
				try{
					key = new SimpleEncryptionKeyGenerator().getEncryptionKey(pPassword);					
				}catch(e:ArgumentError){
					dispatchEvent( new EncryptionErrorEvent(EncryptionErrorEvent.EVENT_ENCRYPTION_ERROR, e));
					return false;
				}
			}
			
			var success:Boolean = db.openDBFile(dbFile, key);
			if(success==false) return false;			
			if(key!=null) getBase64EncryptionKey(key);
			return true;
		}
				
		public function reencrypt(pPassword:String):void
		{
			if( dbFile==null ) return;
			
			try{
				var key:ByteArray = new SimpleEncryptionKeyGenerator().getEncryptionKey(pPassword);					
			}catch(e:ArgumentError){
				dispatchEvent( new EncryptionErrorEvent(EncryptionErrorEvent.EVENT_ENCRYPTION_ERROR, e));
				return;
			}			
			
			var success:Boolean = db.reencrypt(key);
			if(success==false) return;
			getBase64EncryptionKey(key);
		}

		// Borrowed from Paul Roberston's EncryptionKeyGenerator
		private function legacyGenerateEncryptionKey(hash:String):ByteArray
		{
			var result:ByteArray = new ByteArray();
			// select a range of 128 bits (32 hex characters) from the hash
			// In this case, we'll use the bits starting from position 17
			for (var i:uint = 0; i < 32; i += 2)
			{
				var position:uint = i + 17;
				var hex:String = hash.substr(position, 2);
				var byte:int = parseInt(hex, 16);
				result.writeByte(byte);
			}
			return result;
		}

		private function getBase64EncryptionKey(key:ByteArray):void
		{
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(key);
			base64Key = encoder.toString();
		}
	
		public function getBase64FromPassword(pPassword:String):String
		{
			var key:ByteArray = new SimpleEncryptionKeyGenerator().getEncryptionKey(pPassword);
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(key);
			return encoder.toString();
		}

		private function loadSchema():void
		{
			schemas =  db.getSchemas();				
			
			if(schemas==null) return;
			
			dbTables = schemas.tables;
			dbIndices = schemas.indices;
			dbViews = schemas.views;
			
			if(dbTables) dbTables.sortOn("name", Array.CASEINSENSITIVE);
			if(dbIndices) dbIndices.sort(sortIndices);
		}
		
		private function sortIndices(a:SQLIndexSchema, b:SQLIndexSchema):Number
		{
			var aTable:String = a.table.toLowerCase();
			var bTable:String = b.table.toLowerCase();
			
			if(aTable < bTable){
				return -1;
			}
			if(aTable > bTable){
				return 1;
			}
			var aName:String = a.name.toLowerCase();
			var bName:String = b.name.toLowerCase();
			if(aName < bName){
				return -1;
			}
			if(aName > bName){
				return 1;
			}
			return 0;
		}
		
		public function compact():Boolean
		{
			if(dbFile==null) return false;
			db.compact();				
			return true;
		}
		
		public function exportDB(pExportData:Boolean=true):String
		{
			var str:String="";
			for(var i:int=0;i<dbTables.length;i++){
				var table:SQLTableSchema = dbTables[i];
				str+= table.sql + ";" +File.lineEnding+File.lineEnding;
				if(pExportData){
					 str+= db.exportTableRecords( table)+File.lineEnding+File.lineEnding;										
				}
			}
			return str;
		}
		
		public function executeStatement(pStatement:String):SQLResult
		{
			if(StringTWLUtil.isWhitespace(pStatement)) return null;
			return db.executeStatement(pStatement);
		}
		
		public function createTable(pTableName:String, pDefaultCol:String):SQLTableSchema
		{
			db.createTable(pTableName, [ pDefaultCol]);
			loadSchema();
			return getTableByName( pTableName);
		}
				
		public function copyTable(pTable:SQLTableSchema, pNewName:String, pCopyData:Boolean=true):SQLTableSchema
		{
			db.copyTable( pTable, pNewName, pCopyData);			
			loadSchema();
			return getTableByName( pNewName);
		}

		public function dropTable(pTable:SQLTableSchema):void
		{
			db.dropTable(pTable);	
			loadSchema();
			tableRecords = [];
		}
		
		public function emptyTable(pTable:SQLTableSchema):void
		{			
			db.emptyTable(pTable);			
			tableRecords = [];
		}
		
		public function renameTable(pTable:SQLTableSchema, pName:String):SQLTableSchema
		{
			db.renameTable( pTable, pName);	
			loadSchema();
			return getTableByName(pName);
		}
				
		public function getTableByName(pName:String):SQLTableSchema
		{
			for(var i:int=0;i<dbTables.length;i++){
				var t:SQLTableSchema = dbTables[i];
				if(t.name == pName) return t;
			}
			return null ;
		}
		
		public function addColumn(pTable:SQLTableSchema, pName:String, pDataType:String, pAllowNull:Boolean, pUnique:Boolean, pDefault:String):SQLTableSchema
		{
			var tableName:String = pTable.name;
			db.addColumn(pTable, pName, pDataType, pAllowNull, pUnique, pDefault);
			loadSchema();
			return getTableByName(tableName);
		}
		
		public function removeColumn(pTable:SQLTableSchema, pColName:String):SQLTableSchema
		{			
			var tableName:String = pTable.name;
			db.removeColumn(pTable, pColName);
			loadSchema();
			return getTableByName(tableName);
		}

		public function renameColumn(pTable:SQLTableSchema, pCol:SQLColumnSchema, pName:String):SQLTableSchema
		{
			if(pCol == null) return null;
			var tableName:String = pTable.name;
			db.renameColumn(pTable, pCol.name, pName);
			loadSchema();
			return getTableByName(tableName);
		}
		
		public function addIndex(pTable:SQLTableSchema, pCol:SQLColumnSchema, pName:String):void
		{
			db.createIndex(pName, pTable, pCol);
			loadSchema();
		}
		
		public function removeIndex(pIndex:SQLIndexSchema):void
		{
			db.removeIndex(pIndex.name);
			loadSchema();
		}
		
		public function updateRecord(pTable:SQLTableSchema, pOriginal:Object, pVo:Object):Object
		{			
			if(tableRecords == null) return null;
			if(pOriginal == null) return null;
			var i:int = tableRecords.indexOf(pOriginal);
			db.updateRecord(pTable, pOriginal, pVo);
			refreshRecords(pTable);
			return  tableRecords[i];
		}
		
		public function createRecord(pTable:SQLTableSchema, pVo:Object):Object
		{
			db.createRecord(pTable, pVo);
			refreshRecords(pTable);
			
			if(tableRecords && tableRecords.length>0){
				return tableRecords[tableRecords.length-1];
			}
			return null;
		}
		
		public function deleteRecord(pTable:SQLTableSchema, pObj:Object):void
		{
			db.deleteRecord( pTable, pObj);
			refreshRecords(pTable);
		}
		
		public function refreshRecords(pTable:SQLTableSchema):void
		{
			if(pTable!=null){
				tableRecords = db.getTableRecords(pTable);
			}else{
				tableRecords=[];
			}
		}
		
		public function exportRecords(pTable:SQLTableSchema):String
		{
			return db.exportTableRecords( pTable);
		}
		
	}
}