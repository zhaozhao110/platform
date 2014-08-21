package com.editor.module_sql.model
{
	import com.editor.model.AppMainModel;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.data.EncryptedLocalStore;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class FileManager extends EventDispatcher
	{
		
		public static const EVENT_IMPORT_FILE_SELECTED:String="importFileSelected";
		
		public var recentlyOpened:Array;
		private var tmpExportString:String;
		public var importedSQL:String;
		
		
		public function FileManager()
		{
			getRecentlyOpened();		
		}

		private function getRecentlyOpened():void
		{
			if(recentlyOpened!=null) return ;
			recentlyOpened = [];
			var out:Array = [];
			var a:Array = AppMainModel.getInstance().applicationStorageFile.recentDatabase_ls;
			for(var i:int=0;i<a.length;i++){
				var fl:File = new File(a[i])
				if(fl.exists){
					out.push({name:fl.name,path:fl.nativePath});
				}
			}
			recentlyOpened = out;
		}
		
		public function addRecentlyOpened(pFile:File):void
		{
			for ( var i:int = 0 ; i < recentlyOpened.length ; i++){
				if(pFile.nativePath== recentlyOpened[i].path){
					recentlyOpened.splice(i, 1);
					break;
				}
			}				
			
			recentlyOpened.unshift({name:pFile.name, path: pFile.nativePath});
			saveRecentlyOpened();
		}
		
		public function importFromFile():void
		{
			var f:File = new File();				
			f.addEventListener(Event.SELECT, onImportFileSelected)		
			f.browseForOpen("Select an SQL file");
		}
		
		private function onImportFileSelected(pEvt:Event):void
		{
			var f:File = pEvt.target as File;
			var stream:FileStream = new FileStream();
			stream.open( f, FileMode.READ);
			importedSQL = stream.readMultiByte(stream.bytesAvailable, "UTF-8");
			stream.close();
			
			dispatchEvent( new Event( EVENT_IMPORT_FILE_SELECTED));
		}
		
		public function createExportFile(pStr:String):void
		{
			tmpExportString = pStr;
			var f:File = new File();						
			f.browseForSave("Export to file");
			f.addEventListener(Event.SELECT, onExportFileSelected);
		}
		
		private function onExportFileSelected(pEvt:Event):void
		{
			var f:File = pEvt.target as File;
			var stream:FileStream = new FileStream();
			stream.open( f, FileMode.WRITE);
			stream.writeMultiByte(tmpExportString, "UTF-8");
			stream.close();			
		}
		
		private function saveRecentlyOpened():void
		{
			var out:Array = [];
			for ( var i:int = 0 ; i < recentlyOpened.length ; i++){
				if(!StringTWLUtil.isWhitespace(recentlyOpened[i].path)){
					out.push(recentlyOpened[i].path)
				}
			}
			AppMainModel.getInstance().applicationStorageFile.putKey_recentDatabase(out.join("|"));	
		}

	}
}