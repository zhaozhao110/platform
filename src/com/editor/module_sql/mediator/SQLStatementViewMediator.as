package com.editor.module_sql.mediator
{
	import com.editor.component.controls.UITextArea;
	import com.editor.mediator.AppMediator;
	import com.editor.module_sql.model.presentation.SQLStatementPM;
	import com.editor.module_sql.view.SQLStatementView;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.data.SQLColumnSchema;
	
	public class SQLStatementViewMediator extends AppMediator
	{
		public static const NAME:String = "SQLStatementViewMediator"
		public function SQLStatementViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get stateMentView():SQLStatementView
		{
			return viewComponent as SQLStatementView;
		}
		public function get statementTa():UITextArea
		{
			return stateMentView.statementTa;
		}
		public function get datagrid72():SandyDataGrid
		{
			return stateMentView.datagrid72;
		}
		public function get pm():SQLStatementPM
		{
			return stateMentView.pm;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		public function respondToReflashStatementDataEvent(noti:Notification):void
		{
			datagrid72.removeHeader();
			var coltab:Array = [];
			var totalCols:int = pm.mainPM.selectedTable.columns.length;
			for(var i:int=totalCols-1;i>=0;i--){
				var col:SQLColumnSchema = pm.mainPM.selectedTable.columns[i] as SQLColumnSchema;
				var dgc:ASDataGridColumn = new ASDataGridColumn(col.name);
				dgc.dataField = col.name;
				dgc.columnWidth = ( (stateMentView.width-20) / (totalCols) );
				coltab.push(dgc);
			}
			datagrid72.columns = coltab.reverse() ;
			
			datagrid72.dataProvider = pm.results;
		}
		
	}
}