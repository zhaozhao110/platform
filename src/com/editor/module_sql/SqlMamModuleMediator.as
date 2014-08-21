package com.editor.module_sql
{
	import com.editor.component.controls.UIButton;
	import com.editor.manager.DataManager;
	import com.editor.mediator.UIModule2Mediator;
	import com.editor.model.AppMainModel;
	import com.editor.module_sql.mediator.IndicesViewMediator;
	import com.editor.module_sql.mediator.SQLDataViewMediator;
	import com.editor.module_sql.mediator.SQLStatementViewMediator;
	import com.editor.module_sql.mediator.SQLStructureViewMediator;
	import com.editor.module_sql.mediator.TableListViewMediator;
	import com.editor.module_sql.model.presentation.MainPM;
	import com.editor.module_sql.view.IndicesView;
	import com.editor.module_sql.view.SQLDataView;
	import com.editor.module_sql.view.SQLStatementView;
	import com.editor.module_sql.view.SQLStructureView;
	import com.editor.module_sql.view.TableListView;
	import com.editor.services.Services;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class SqlMamModuleMediator extends UIModule2Mediator
	{
		public static const NAME:String = "SqlMamModuleMediator";
		public function SqlMamModuleMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		public function get sqlModule():SqlMamModule
		{
			return viewComponent as SqlMamModule
		}
		public function get button129():UIButton
		{
			return sqlModule.button129;
		}
		public function get button130():UIButton
		{
			return sqlModule.button130;
		}
		public function get tablelistview136():TableListView
		{
			return sqlModule.tablelistview136;
		}
		public function get structureTab():SQLStructureView
		{
			return sqlModule.structureTab;
		}
		public function get dataView():SQLDataView
		{
			return sqlModule.dataView;
		}
		public function get indicesview139():IndicesView
		{
			return sqlModule.indicesview139;
		}
		public function get sqlstatementview140():SQLStatementView
		{
			return sqlModule.sqlstatementview140;
		}
		public function get button():UIButton
		{
			return sqlModule.button;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			mainPM = new MainPM(this);
			sqlModule.mainPM = mainPM;
			sqlModule.create_init2();
			
			button129.addEventListener(MouseEvent.CLICK , button129Click);
			button130.addEventListener(MouseEvent.CLICK , button130Click);
			button.addEventListener(MouseEvent.CLICK,buttonClick);
			
			registerMediator(new TableListViewMediator(tablelistview136));
			registerMediator(new SQLStructureViewMediator(structureTab));
			registerMediator(new SQLDataViewMediator(dataView));
			//registerMediator(new IndicesViewMediator(indicesview139));
			registerMediator(new SQLStatementViewMediator(sqlstatementview140));
			
		}
		
		private var mainPM:MainPM;
		
		public function button129Click(e:MouseEvent):void
		{
			mainPM.promptOpenFile()
		}
		
		public function button130Click(e:MouseEvent):void
		{
			mainPM.promptCreateDBFile()
		}
		
		public function respondToDropTableEvent(noti:Notification):void
		{
			sqlModule.getRightContainer().enabled = false;
		}
		
		public function respondToSelectTableEvent(noti:Notification):void
		{
			sqlModule.getRightContainer().enabled = true;
		}
		
		public function buttonClick(e:MouseEvent):void
		{
			var db_url:String = Services.app_fold_url + "src\\assets\\db";
			mainPM.openDBFile(new File(db_url),DataManager.pass);
		}
		
	}
}