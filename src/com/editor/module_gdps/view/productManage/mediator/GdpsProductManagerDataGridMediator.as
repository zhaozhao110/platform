package com.editor.module_gdps.view.productManage.mediator
{
	import com.editor.mediator.AppMediator;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;

	public class GdpsProductManagerDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsProductManagerDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsProductManagerDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
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
			dg.headerText = "项目ID";
			dg.columnWidth = 80;
			dg.sortable = true;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SName";
			dg.headerText = "项目名称";
			dg.columnWidth = 130;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SAlias";
			dg.headerText = "项目别名";
			dg.columnWidth = 130;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "NGid";
			dg.headerText = "所属游戏ID";
			dg.columnWidth = 80;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SState";
			dg.headerText = "状态";
			dg.columnWidth = 80;
			dg.labelFunction = stateLabel;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SClient";
			dg.headerText = "客户端SVN地址";
			dg.columnWidth = 250;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SServer";
			dg.headerText = "服务端SVN地址";
			dg.columnWidth = 250;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SRes";
			dg.headerText = "资源SVN地址";
			dg.columnWidth = 250;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SSvnName";
			dg.headerText = "SVN用户名";
			dg.columnWidth = 120;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SSvnPwd";
			dg.headerText = "SVN密码";
			dg.columnWidth = 100;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SType";
			dg.headerText = "产品类型";
			dg.columnWidth = 100;
			dg.labelFunction = productTypeLabel;
			cols.push(dg);
			
			dg = new ASDataGridColumn();
			dg.dataField = "SDesc";
			dg.headerText = "扩展描述";
			dg.columnWidth = 250;
			cols.push(dg);
			
			list.columns = cols;
			
			findTableSpaceDataByPage(1, 20,null);
		}
		
		private function stateLabel(oItem:Object, iCol:int = 0):String
		{
			var list:Array = GDPSDataManager.statusList;
			for each(var vo:Object in list){
				
				if(vo.value == oItem.SState){
					return vo.label;
				}
			}
			
			return oItem.SState || "";
		}
		
		private function productTypeLabel(oItem:Object, iCol:int = 0):String
		{
			var list:Array = GDPSDataManager.typeList;
			for each(var vo:Object in list){
				
				if(vo.value == oItem.SType){
					return vo.label;
				}
			}
			
			return oItem.SType || "";
		}
		
		/**
		 * 创建行索引
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
			
			var url:String = GDPSServices.getProductMamangeList_url ;
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