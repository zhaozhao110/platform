package com.editor.d3.pop.createProject
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

	public class App3DCreateProjectPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "App3DCreateProjectPopwinMediator"
		public function App3DCreateProjectPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():App3DCreateProjectPopupwin
		{
			return viewComponent as App3DCreateProjectPopupwin
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
			
			if(nameForm.text.indexOf(".")!=-1){
				return ;
			}
			
			var fl:File = new File(pathForm.text + File.separator + nameForm.text);
			addLog("创建项目: " + fl.nativePath);
			
			var c:App3DCreateTool = new App3DCreateTool();
			c.create(fl,nameForm.text);
			
			closeWin();
		}
		
		
	}
}