package com.editor.module_sql.pop.createTable
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_sql.model.presentation.MainPM;
	import com.editor.view.popup.AppDestroyPopupwinMediator;

	public class CreateTablePopWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "CreateTablePopWinMediator"
		public function CreateTablePopWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);	
		}
		public function get win():CreateTablePopWin
		{
			return viewComponent as CreateTablePopWin;
		}
		override public function onRegister():void
		{
			super.onRegister();
			createBt.addEventListener('click',function(e:*):void{ createTable();});
		}
		
		public function get tableNameTi():UITextInput
		{
			return win.tableNameTi;
		}
		public function get colNameTi():UITextInput
		{
			return win.colNameTi;
		}
		public function get dataTypeTi():UICombobox
		{
			return win.dataTypeTi;
		}
		public function get primaryCb():UICheckBox
		{
			return win.primaryCb;
		}
		public function get incrementCb():UICheckBox
		{
			return win.incrementCb;
		}
		public function get createBt():UIButton
		{
			return win.createBt;
		}
		
		public function get mainPM():MainPM
		{
			return MainPM.instance;
		}
				
		private function createTable():void
		{
			var colDef:String=colNameTi.text + ' ' + dataTypeTi.htmlText;
			if(primaryCb.selected){
				colDef+=" PRIMARY KEY";
			}
			if(incrementCb.selected){
				colDef+=" AUTOINCREMENT";
			}
			mainPM.createTable(tableNameTi.text, colDef);
			closeWin();
		}
		
	}
}