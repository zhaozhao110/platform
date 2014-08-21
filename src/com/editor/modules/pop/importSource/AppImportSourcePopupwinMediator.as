package com.editor.modules.pop.importSource
{
	import com.editor.component.controls.UISelectFileButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.event.AppEvent;
	import com.editor.model.AppMainModel;
	import com.editor.model.AppOpenMessageData;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.filesystem.File;

	public class AppImportSourcePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppImportSourcePopupwinMediator"
		public function AppImportSourcePopupwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get importWin():AppImportSourcePopupwin
		{
			return viewComponent as AppImportSourcePopupwin
		}
		public function get pathButton():UISelectFileButton
		{
			return importWin.pathButton;
		}
		public function get pathForm():UITextInput
		{
			return importWin.pathForm;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			pathButton.addEventListener(ASEvent.CHANGE,pathButtonChange)
		}
		
		private var selectedFile:File;
		
		private function pathButtonChange(evt:ASEvent):void
		{
			selectedFile = evt.data as File;
			pathForm.text = selectedFile.nativePath;
			
		}
		
		override protected function okButtonClick():void
		{
			if(selectedFile == null) return 
			super.okButtonClick();
						
			var _checkIsProject:Boolean;
			var a:Array = selectedFile.getDirectoryListing();
			for(var i:int=0;i<a.length;i++){
				var file:File = a[i] as File;
				if(file.name == ".actionScriptProperties" || file.name == ".project"){
					_checkIsProject = true
				}
			}
			
			/*if(!_checkIsProject){
				var mess:AppOpenMessageData = new AppOpenMessageData();
				mess.info = "请导入正确格式的目录,包括actionScriptProperties文件和project文件";
				showConfirm(mess);
				return ;
			}*/
			
			if(AppMainModel.getInstance().applicationStorageFile.curr_project == selectedFile.nativePath){
				return ;
			}
			
			sendAppNotification(AppEvent.changeProject_event,selectedFile);
			closeWin();
		}
		
		
	}
}