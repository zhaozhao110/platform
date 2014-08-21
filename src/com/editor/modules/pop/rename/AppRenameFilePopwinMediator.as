package com.editor.modules.pop.rename
{
	import com.asparser.ClsUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_ui.css.CreateCSSMainFile;
	import com.editor.tool.project.rename.ProjectFileRenameTool;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class AppRenameFilePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppRenameFilePopwinMediator"
		public function AppRenameFilePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get renameWin():AppRenameFilePopwin
		{
			return viewComponent as AppRenameFilePopwin
		}
		public function get pathForm():UITextInput
		{
			return renameWin.pathForm;
		}
		public function get nameForm():UITextInput
		{
			return renameWin.nameForm;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			file = (getOpenDataProxy() as OpenPopwinData).data as File;
			
			pathForm.text = file.name;
			pathForm.editable = false;
			pathForm.toolTip = file.nativePath;
		}
		
		private var file:File;
		private var read:ReadFile = new ReadFile();
		private var write:WriteFile = new WriteFile();
		private var tool:ProjectFileRenameTool = new ProjectFileRenameTool();
		
		override protected function okButtonClick():void
		{
			if(StringTWLUtil.isWhitespace(nameForm.text)){
				return ;
			}
			var oldName:String = pathForm.text;
			tool.rename(oldName,nameForm.text,file)
			//
			closeWin();
		}
		
		private function getNewName2():String
		{
			if(nameForm.text.indexOf(".")!=-1){
				return nameForm.text.split(".")[0];
			}
			return nameForm.text;
		}
		
		private function getNewName():String
		{
			if(nameForm.text.indexOf(".")==-1){
				return nameForm.text + "."+ file.extension;
			}
			return nameForm.text;
		}
	}
}