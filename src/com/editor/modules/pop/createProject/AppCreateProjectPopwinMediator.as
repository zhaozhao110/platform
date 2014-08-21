package com.editor.modules.pop.createProject
{
	import com.air.component.SandySelectFileButton;
	import com.editor.component.controls.UISelectFileButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.event.AppEvent;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class AppCreateProjectPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppCreateProjectPopwinMediator"
		public function AppCreateProjectPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():AppCreateProjectPopupwin
		{
			return viewComponent as AppCreateProjectPopupwin
		}
		public function get pathButton():UISelectFileButton
		{
			return createWin.pathButton;
		}
		public function get pathForm():UITextInput
		{
			return createWin.pathForm;
		}
		public function get nameForm():UITextInput
		{
			return createWin.nameForm;
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
			if(StringTWLUtil.isWhitespace(nameForm.text)){
				return ;
			}
			
			var fl:File = new File(pathForm.text + File.separator + nameForm.text);
			addLog("创建项目: " + fl.nativePath);
			
			var tool:CreateProjectTool = new CreateProjectTool();
			tool.create(fl);
			
			/*sendAppNotification(AppEvent.changeProject_event,fl);
			closeWin();*/
		}
		
		
	}
}