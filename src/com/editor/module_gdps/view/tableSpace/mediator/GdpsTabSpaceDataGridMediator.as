package com.editor.module_gdps.view.tableSpace.mediator
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
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class GdpsTabSpaceDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsTabSpaceDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsTabSpaceDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME+ _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get dataGridContainer():GdpsModuleDataGrid
		{
			return viewComponent as GdpsModuleDataGrid;
		}
		public function get tableSpace_grid():SandyDataGrid
		{
			return dataGridContainer.tableSpace_grid;
		}
		public function get tableSpace_page_bar():GdpsPageBar
		{
			return dataGridContainer.tableSpace_page_bar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			findDataGridColumn();
			tableSpace_page_bar.pageNoChangeFun = onPageChange;
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
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
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
			var cols:Array = tableSpace_grid.columns || [];
			var dgc:ASDataGridColumn = new ASDataGridColumn();
			dgc.headerText = "Row#";
			dgc.columnWidth = 40;
			dgc.labelFunction = lfRowNum;
			cols.push(dgc);
			for (var i:int = 0; i < columns.length; i++)
			{
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				dg.columnWidth = columns[i].NWidth;
				dg.sortable = true;
				cols.push(dg);
			}
			tableSpace_grid.columns = cols;
			
			findTableSpaceDataByPage(1, 20,null);
		}
		
		/**
		 * 创建行索引
		 *
		 * @param oItem
		 * @param iCol
		 * @return
		 */
		private function lfRowNum(oItem:Object, iCol:int = 0):String
		{
			var len:int = tableSpace_grid.dataProvider.length;
			var index:int = 0;
			for(var i:int = 0 ;i < len ;i++)
			{
				var obj:Object = tableSpace_grid.dataProvider[i] as Object;
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
		public function findTableSpaceDataByPage(pageNo:int, pageLimit:int, params:*):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit };
			http.sucResult_f = showTableSpaceData;
			
			var url:String = GDPSServices.serverDomain + confItem.view ;
			http.conn(url, "POST");
		}
		
		private function showTableSpaceData(a:*):void
		{
			var value:* = a;
			tableSpace_grid.dataProvider = value.data;
			
			//设置分页参数
			tableSpace_page_bar.pageData = value.data.length;
			tableSpace_page_bar.totalCount = value.page.totalRowCount;
			tableSpace_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findTableSpaceDataByPage(pageNo, pageLimit, null);
		}
	}
}