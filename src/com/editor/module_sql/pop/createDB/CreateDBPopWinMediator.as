package com.editor.module_sql.pop.createDB
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.manager.DataManager;
	import com.editor.module_sql.model.presentation.MainPM;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.encrypt.SimpleEncryptionKeyGenerator;
	
	import flash.events.Event;
	import flash.filesystem.File;

	public class CreateDBPopWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "CreateDBPopWinMediator"
		public function CreateDBPopWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);	
		}
		public function get dbWin():CreateDBPopWin
		{
			return viewComponent as CreateDBPopWin
		}
		public function get pathTi():UITextInput
		{
			return dbWin.pathTi;
		}
		public function get pwdTi():UITextInput
		{
			return dbWin.pwdTi;
		}
		public function get button22():UIButton
		{
			return dbWin.button22;
		}
		public function get button26():UIButton
		{
			return dbWin.button26;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			pathTi.addEventListener('change',function(e:*):void{ filePath = pathTi.text;});
			button22.addEventListener('click',function(e:*):void{ browse();});
			pwdTi.addEventListener('change',function(e:*):void{ pwd = pwdTi.text;});
			button26.addEventListener('click',function(e:*):void{ submit();});
			pwd = DataManager.pass
			pwdTi.text = DataManager.pass
		}
		
		
		
		public function get pm():MainPM
		{
			return MainPM.instance;
		}
		
		
		private var filePath:String;
		
		private var pwd:String="";
		
		
		private function browse():void
		{
			var f:File = new File();
			f.addEventListener(Event.SELECT, onFileSelected);
			f.browseForSave("Create a DB file");				
		}
		
		private function onFileSelected(pEvt:Event):void
		{
			var f:File = pEvt.target as File;
			filePath = f.nativePath;
			pathTi.text = filePath;
		}
		
		private function submit():void
		{
			var testGen:SimpleEncryptionKeyGenerator = new SimpleEncryptionKeyGenerator();
			if(pwd=="")
			{
				pm.createDBFile( new File(filePath), pwd);
				closeWin();
			}
			else if(testGen.validateStrongPassword(pwd))
			{
				pm.createDBFile( new File(filePath), pwd);
				closeWin();					
			}
			else
			{
				trace( SimpleEncryptionKeyGenerator.PASSWORD_WARNING);
			}
		}
		
		
	}
}