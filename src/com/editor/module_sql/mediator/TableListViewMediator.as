package com.editor.module_sql.mediator
{
	import com.editor.component.containers.UIVBox;
	import com.editor.mediator.AppMediator;
	import com.editor.module_sql.model.presentation.TableListPM;
	import com.editor.module_sql.view.TableListView;
	import com.sandy.puremvc.patterns.observer.Notification;

	public class TableListViewMediator extends AppMediator
	{
		public static const NAME:String = "TableListViewMediator"
		public function TableListViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get tableView():TableListView
		{
			return viewComponent as TableListView
		}
		public function get tableList():UIVBox
		{
			return tableView.tableList;
		}
		public function get pm():TableListPM
		{
			return tableView.pm;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToReflashDatabaseEvent(noti:Notification):void
		{
			tableList.dataProvider = pm.dbTables;
			tableList.setSelectIndex(tableList.selectedIndex,true,true);
		}
		
	}
}