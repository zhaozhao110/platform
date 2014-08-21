package com.editor.module_gdps.view.dataBase.mediator
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.view.dataBase.component.GdpsDataBaseRenderer;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;

	public class GdpsDataBaseDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsDataBaseDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsDataBaseDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME+ _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get dataGridContainer():GdpsModuleDataGrid
		{
			return viewComponent as GdpsModuleDataGrid;
		}
		public function get databaseFile_grid():SandyDataGrid
		{
			return dataGridContainer.tableSpace_grid;
		}
		public function get databaseFile_page_bar():GdpsPageBar
		{
			return dataGridContainer.tableSpace_page_bar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			databaseFile_page_bar.pageNoChangeFun = onPageChange;
			findDataGridColumn();
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
			var queryTableId:int = confItem.extend.queryTableId;
			if (queryTableId <= 0)
			{
				showError("获取查询表id失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": queryTableId };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url);
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			
			if(columns.length === 0){
				showError("请先配置表字段对象");
			}
			var cols:Array = databaseFile_grid.columns ||[];
			
			var dg1:ASDataGridColumn = new ASDataGridColumn();
			dg1.renderer = GdpsDataBaseRenderer;
			dg1.headerText = "选择";
			dg1.columnWidth = 35;
			dg1.sortable = false;
			dg1.editable = true;
			cols.push(dg1);
			
			for (var i:int = 0; i < columns.length; i++)
			{
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				dg.columnWidth = columns[i].NWidth;
				dg.sortable = false;
				cols.push(dg);
			}
			databaseFile_grid.columns = cols;
			
			findDatabaseFileDataByPage( 1, databaseFile_page_bar.pageLimit, null);
		}
		
		public function checkBoxDataChangeHandler(obj:GdpsDataBaseRenderer):void
		{
			if (obj.data != null && obj.data.hasOwnProperty("cbSelect"))
			{
				obj.checkBox.selected = obj.data.cbSelect;
			}
			if (obj.data != null && obj.data.hasOwnProperty("s_state"))
			{
				obj.checkBox.enabled = obj.data.s_state == '1';
			}
		}
		
		private var cache_dg_data:Array;
		
		public function get getCacheGridData():Array
		{
			return cache_dg_data;
		}
		
		/**
		 * 从服务器端加载表数据
		 */
		public function findDatabaseFileDataByPage(pageNo:int, pageLimit:int, params:*):void
		{
			cache_dg_data = [];
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit, "tableId": confItem.extend.queryTableId };
			http.sucResult_f = showDatabaseFileData;
			
			var _url:String = GDPSServices.getPrepareSqlData_url;
			http.conn(_url);
		}
		
		private function showDatabaseFileData(a:*):void
		{
			var value:* = a;
			
			cache_dg_data = value.data;
			
			databaseFile_grid.dataProvider = cache_dg_data;
			databaseFile_page_bar.pageData = value.data.length;
			databaseFile_page_bar.totalCount = value.page.totalRowCount;
			databaseFile_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findDatabaseFileDataByPage(pageNo, pageLimit, null);
		}
	}
}