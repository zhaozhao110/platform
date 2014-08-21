package com.editor.module_roleEdit.mediator
{
	import com.editor.component.controls.UILabel;
	import com.editor.mediator.AppMediator;
	import com.editor.module_roleEdit.facade.PeopleImageBindingData;
	import com.editor.module_roleEdit.view.PeopleImageContent;
	import com.editor.module_roleEdit.view.PeopleImageDataGrid;
	import com.editor.module_roleEdit.view.PeopleImageToolBar;
	import com.sandy.fabrication.IModuleFacade;
	import com.sandy.popupwin.PopupwinMangerContainer;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class PeopleImageContentMediator extends AppMediator
	{		
		public static const NAME:String = "PeopleImageContentMediator"
		public function PeopleImageContentMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get content():PeopleImageContent
		{
			return viewComponent as PeopleImageContent
		}
		public function get toolBar():PeopleImageToolBar
		{
			return content.toolBar;
		}
		public function get infoText():UILabel
		{
			return content.infoText;
		}
		public function get dataGridContainer():PeopleImageDataGrid
		{
			return content.dataGridContainer;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new PeopleImageToolBarMediator(toolBar));
			registerMediator(new PeopleImageDataGridMediator(dataGridContainer))
			
		}
		
		public function respondToRoleEditReflashTopInfoEvent(noti:Notification):void
		{
			infoText.text = PeopleImageBindingData.getInstance().topInfoTxt;
		}
		
	}
}