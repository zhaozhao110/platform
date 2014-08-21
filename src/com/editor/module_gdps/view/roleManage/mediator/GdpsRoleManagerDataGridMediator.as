package com.editor.module_gdps.view.roleManage.mediator
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;

	public class GdpsRoleManagerDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsRoleManagerDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsRoleManagerDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME+ _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get dataGridContainer():GdpsModuleDataGrid
		{
			return viewComponent as GdpsModuleDataGrid;
		}
		public function get list():SandyDataGrid
		{
			return dataGridContainer.tableSpace_grid;
		}
		public function get pageBar():GdpsPageBar
		{
			return dataGridContainer.tableSpace_page_bar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			pageBar.pageNoChangeFun = onPageChange;
			
			showDataGridColumn();
		}
		
		private function showDataGridColumn():void
		{
			var cols:Array = list.columns || [];
			var dg:ASDataGridColumn = new ASDataGridColumn();
			dg.headerText = "Row#";
			dg.columnWidth = 40;
			dg.labelFunction = lfRowNum;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "NId";
			dg.headerText = "角色ID";
			dg.columnWidth = 100;
			dg.sortable = true;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SName";
			dg.headerText = "角色名称";
			dg.columnWidth = 260;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SDesc";
			dg.headerText = "备注";
			dg.columnWidth = 260;
			cols.push(dg);
			
			list.columns = cols;
			
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
			var len:int = list.dataProvider.length;
			var index:int = 0;
			for(var i:int = 0 ;i < len ;i++)
			{
				var obj:Object = list.dataProvider[i] as Object;
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
			
			var url:String = GDPSServices.getRoleMamangeList_url ;
			http.conn(url, "POST");
		}
		
		private function showTableSpaceData(a:*):void
		{
			var value:* = a;
			list.dataProvider = value.data;
			
			//设置分页参数
			pageBar.pageData = value.data.length;
			pageBar.totalCount = value.page.totalRowCount;
			pageBar.setBtnStatus();
		}
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findTableSpaceDataByPage(pageNo, pageLimit, null);
		}
	}
}