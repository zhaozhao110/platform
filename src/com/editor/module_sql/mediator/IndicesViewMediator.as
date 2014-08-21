package com.editor.module_sql.mediator
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_sql.model.presentation.IndicesPM;
	import com.editor.module_sql.view.IndicesView;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	public class IndicesViewMediator extends AppMediator
	{
		public static const NAME:String = "IndicesViewMediator"
		public function IndicesViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get indicesView():IndicesView
		{
			return viewComponent as IndicesView;
		}
		public function get datagrid36():SandyDataGrid
		{
			return indicesView.datagrid36;
		}
		
		public function get pm():IndicesPM
		{
			return indicesView.pm;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
		}
		
		/*public function respondToSelectTableEvent(noti:Notification):void
		{
			datagrid36.dataProvider = pm.dbIndices;
		}*/
		
	}
}