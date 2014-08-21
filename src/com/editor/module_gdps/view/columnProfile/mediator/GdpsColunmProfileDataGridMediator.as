package com.editor.module_gdps.view.columnProfile.mediator
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

	public class GdpsColunmProfileDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsColunmProfileDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsColunmProfileDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME+ _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get dataGridContainer():GdpsModuleDataGrid
		{
			return viewComponent as GdpsModuleDataGrid;
		}
		public function get columnProfile_grid():SandyDataGrid
		{
			return dataGridContainer.tableSpace_grid;
		}
		
		public function get columnProfile_page_bar():GdpsPageBar
		{
			return dataGridContainer.tableSpace_page_bar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			columnProfile_page_bar.pageNoChangeFun = onPageChange;
			
			createRows();
		}
		
		private function createRows():void
		{
			var cols:Array = [];
			var dg:ASDataGridColumn = new ASDataGridColumn();
			dg.headerText = "Row#";
			dg.columnWidth = 40;
			dg.labelFunction = lfRowNum;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "tableId";
			dg.headerText = "数据表ID";
			dg.sortable = true;
			dg.columnWidth = 100;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "tableField";
			dg.headerText = "数据表";
			dg.columnWidth = 200;
			dg.sortable = true;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "tableName";
			dg.headerText = "表名称";
			dg.columnWidth = 200;
			dg.sortable = true;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "createTime";
			dg.headerText = "表创建时间";
			dg.columnWidth = 150;
			dg.sortable = true;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "hasProfile";
			dg.headerText = "是否定义表属性";
			dg.columnWidth = 120;
			dg.sortable = true;
			cols.push(dg);
			
			columnProfile_grid.columns = cols;
			
			findColumnProfileDataByPage(1,20,null);
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
			var len:int = columnProfile_grid.dataProvider.length;
			var index:int = 0;
			for(var i:int = 0 ;i < len ;i++)
			{
				var obj:Object = columnProfile_grid.dataProvider[i] as Object;
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
		public function findColumnProfileDataByPage(pageNo:int, pageLimit:int, params:*):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit };
			http.sucResult_f = showColumnProfileData;
			var _url:String = GDPSServices.serverDomain + confItem.view ;
			http.conn(_url);
		}
		
		private function showColumnProfileData(a:*):void
		{
			var value:* = a;
			columnProfile_grid.dataProvider = value.data;
			
			//设置分页参数
			columnProfile_page_bar.pageData = value.data.length;
			columnProfile_page_bar.totalCount = value.page.totalRowCount;
			columnProfile_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findColumnProfileDataByPage(pageNo, pageLimit, null);
		}
	}
}