package com.editor.module_sql.mediator
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_sql.SqlMamModule;
	import com.editor.module_sql.model.presentation.SQLStructureViewPM;
	import com.editor.module_sql.view.SQLStructureView;
	import com.editor.module_sql.view.TableListView;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	public class SQLStructureViewMediator extends AppMediator
	{
		public static const NAME:String = "SQLStructureViewMediator"
		public function SQLStructureViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get strucView():SQLStructureView
		{
			return viewComponent as SQLStructureView;
		}
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function get pm():SQLStructureViewPM
		{
			return strucView.pm;
		}
		
		public var tableSelectedIndex:int=-1;
		
		public function respondToSelectTableEvent(noti:Notification=null):void
		{
			if(strucView.columnsDG.numChildren > 0 ){
				if(SqlMamModule.tabNavSelectedIndex != 0) return ;
			//	if(TableListView.tableSelectedIndex == tableSelectedIndex) return ;
				if(pm.selectedTable == null) return ;
			}
			tableSelectedIndex = TableListView.tableSelectedIndex;
			strucView.tableNameTi.text = pm.selectedTable.name.toString();
			strucView.columnsDG.dataProvider = pm.selectedTable.columns;
		}
		
		public function respondToSqlMamNavTabChangeEvent(noti:Notification):void
		{
			respondToSelectTableEvent();
		}
		
		public function respondToSelectedColumnEvent(noti:Notification):void
		{
			if(pm.selectedColumn == null) return ;
			strucView.selectedColNameTi.text= pm.selectedColumn.name.toString();
			strucView.dataTypeLabel.text	= pm.selectedColumn.dataType.toString()
			strucView.checkbox96.selected	= pm.selectedColumn.allowNull;
			strucView.checkbox98.selected	= pm.selectedColumn.primaryKey;
			strucView.checkbox100.selected	= pm.selectedColumn.autoIncrement;
		}
		
	}
}