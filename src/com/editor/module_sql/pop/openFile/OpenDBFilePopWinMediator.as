package com.editor.module_sql.pop.openFile
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.manager.DataManager;
	import com.editor.module_sql.model.presentation.MainPM;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class OpenDBFilePopWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "OpenDBFilePopWinMediator"
		public function OpenDBFilePopWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);	
		}
		public function get packWin():OpenDBFilePopWin 
		{
			return viewComponent as OpenDBFilePopWin
		}
		public function get fileListCmb():UICombobox
		{
			return packWin.fileListCmb;
		}
		public function get pathTi():UILabel
		{
			return packWin.pathTi;
		}
		public function get keyLbl():UILabel
		{
			return packWin.keyLbl;
		}
		public function get hashTi():UITextInput
		{
			return packWin.hashTi;
		}
		public function get button49():UIButton
		{
			return packWin.button49;
		}
		public function get button46():UIButton
		{
			return packWin.button46;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			recentlyOpenedFiles = pm.recentlyOpenedFiles;
			fileListCmb.dataProvider= recentlyOpenedFiles 
			fileListCmb.addEventListener('change',fileListChange);
			fileListCmb.selectedIndex = 0;
			
			button49.addEventListener('click',function(e:*):void{ openFile(hashTi.text);});
			
			button46.addEventListener('click',function(e:*):void{ promptOpen();});
			
			onCreationComplete()
			hashTi.text = DataManager.pass;
		}
		
		private function fileListChange(e:ASEvent):void
		{
			if(fileListCmb.selectedItem == null) return;
			selectedFile = new File( fileListCmb.selectedItem.path);
			pathTi.text = selectedFile.nativePath;
		}
		
		private var recentlyOpenedFiles:Array;
		public var closable:Boolean = true ;
		
		
		public function get pm():MainPM
		{
			return MainPM.instance;
		}
		
		
		private var selectedFile:File;
		
		private var selectedFilePath:String;
		
		private function onCreationComplete():void
		{
			if(pm.recentlyOpenedFiles.length>0)
			{
				var f:File = new File(pm.recentlyOpenedFiles[0].path);
				if(f.exists) selectFile(f);
			}
		}
		
		private function promptOpen():void
		{
			var f:File = new File();
			f.addEventListener(Event.SELECT, onFileSelected);
			f.browseForOpen("Select a database file");
		}
		private function onFileSelected(pEvt:Event):void
		{
			var pFile:File = pEvt.target as File;
			recentlyOpenedFiles.unshift({name:pFile.name, path: pFile.nativePath});
			fileListCmb.dataProvider = recentlyOpenedFiles;
			fileListCmb.selectedIndex = 0;
			selectFile(pFile);
		}
		
		private function selectFile(pFile:File):void
		{
			selectedFile = pFile;
			selectedFilePath = selectedFile.nativePath;				
		}
		
		private function openFile(pHash:String):void
		{
			if( selectedFile==null) return ;
			pm.closeDB();
			pm.openDBFile( selectedFile, pHash);
			closeMe();			
		}
		
		private function closeMe():void
		{ 
			pm.onOpenFileDialogClosed(null);
			closeWin();
		}
		
	}
}