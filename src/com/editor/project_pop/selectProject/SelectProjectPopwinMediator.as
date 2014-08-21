package com.editor.project_pop.selectProject
{
	import com.editor.component.controls.UICombobox;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;

	public class SelectProjectPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "SelectProjectPopwinMediator"
		public function SelectProjectPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get selectWin():SelectProjectPopwin
		{
			return viewComponent as SelectProjectPopwin
		}
		public function get projectCB():UICombobox
		{
			return selectWin.projectCB;
		}
		
		private var winVO:SelectProjectPopwinVO;
				
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:OpenPopwinData = getOpenDataProxy(); 
			winVO = dat.data as SelectProjectPopwinVO;
			var a:Array = winVO.data;
			
			projectCB.labelField = winVO.labelField;
			projectCB.dataProvider = a;
			projectCB.addEventListener(ASEvent.CHANGE,projectCBChange)
			projectCB.selectedIndex = 0;
			
			selectWin.botButtonContainer.noButtonVisible = false;
		}
		
		private function projectCBChange(e:ASEvent):void
		{
			
		}
		
		override protected function okButtonClick():void
		{
			super.okButtonClick();
			winVO.callFun(projectCB.selectedItem);
			closeWin();
		}
		
		
	}
}