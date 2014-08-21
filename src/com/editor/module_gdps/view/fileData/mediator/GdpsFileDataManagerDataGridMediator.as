package com.editor.module_gdps.view.fileData.mediator
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;

	public class GdpsFileDataManagerDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsFileDataManagerDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsFileDataManagerDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME+ _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get dataGridContainer():GdpsModuleDataGrid
		{
			return viewComponent as GdpsModuleDataGrid;
		}
		public function get dataManage_grid():SandyDataGrid
		{
			return dataGridContainer.tableSpace_grid;
		}
		
		public function get dataManage_page_bar():GdpsPageBar
		{
			return dataGridContainer.tableSpace_page_bar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			findDataGridColumn();
			dataManage_page_bar.pageNoChangeFun = onPageChange;
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
			var queryTableId:int = confItem.extend.queryTableId;
			if(queryTableId <= 0){
				showError("获取查询表id失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": queryTableId };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			
			var cols:Array = dataManage_grid.columns || [];
			var dgc:ASDataGridColumn = new ASDataGridColumn();
			dgc.headerText = "Row#";
			dgc.columnWidth = 40;
			dgc.labelFunction = lfRowNum;
			cols.push(dgc);
			for(var i:int = 0; i < columns.length; i++){
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				dg.columnWidth = columns[i].NWidth;
				dg.sortable = true;
				cols.push(dg);
			}
			dataManage_grid.columns = cols;
			
			findDataManageDataByPage(1,20,null);
		}
		
		/**
		 * 创建行索引
		 * 
		 * @param oItem
		 * @param iCol
		 * @return 
		 */
		private function lfRowNum(oItem:Object,iCol:int):String
		{
			var len:int = dataManage_grid.dataProvider.length;
			var index:int = 0;
			for(var i:int = 0 ;i < len ;i++)
			{
				var obj:Object = dataManage_grid.dataProvider[i] as Object;
				if(obj == oItem){
					index = i;
					break;
				}
			}
			var iIndex:int = index + 1;
			return iIndex.toString();
		}
		
		/**
		 * 从服务器端加载表数据
		 */
		public function findDataManageDataByPage(pageNo:int, pageLimit:int, params:*):void
		{
	 		var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit , "tableId": confItem.extend.queryTableId};
			http.sucResult_f = showDataManageData;
			
			 var _url:String = GDPSServices.getPrepareTableData_url;
			http.conn(_url, "POST");
		}
		
		private function showDataManageData(a:*):void
		{
			var value:* = a;
			
			dataManage_grid.dataProvider = value.data;
			
			//设置分页参数
			dataManage_page_bar.pageData = value.data.length;
			dataManage_page_bar.totalCount = value.page.totalRowCount;
			dataManage_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findDataManageDataByPage(pageNo, pageLimit, null);
		}
	}
}