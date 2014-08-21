package com.editor.module_gdps.view.packaging.mediator
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
	import com.sandy.utils.StringTWLUtil;

	public class GdpsPackagingDataGridMediator extends AppMediator
	{
		public static const NAME:String = "GdpsPackagingDataGridMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsPackagingDataGridMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME+ _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get dataGridContainer():GdpsModuleDataGrid
		{
			return viewComponent as GdpsModuleDataGrid;
		}
		public function get packaging_grid():SandyDataGrid
		{
			return dataGridContainer.tableSpace_grid;
		}
		public function get packaging_page_bar():GdpsPageBar
		{
			return dataGridContainer.tableSpace_page_bar;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			packaging_page_bar.pageNoChangeFun = onPageChange;
			
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
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			var cols:Array = packaging_grid.columns || [];
			var dgc:ASDataGridColumn = new ASDataGridColumn();
			dgc.headerText = "Row#";
			dgc.labelFunction = lfRowNum;
			dgc.columnWidth = 40;
			cols.push(dgc);
			for (var i:int = 0; i < columns.length; i++)
			{
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.columnWidth = columns[i].NWidth;
				if(columns[i].SField == "SOprid"){
					dg.labelFunction = opridFunc;
					dg.columnWidth = 140;
				}else if(columns[i].SField == "SState"){
					dg.labelFunction = stateFunc;
				}else if(columns[i].SField == "SScope"){
					dg.labelFunction = scopeFunc;
				}else{
					dg.dataField = columns[i].SField;
				}
				dg.headerText = columns[i].SName;
				cols.push(dg);
			}
			packaging_grid.columns = cols;
			
			findPackagingDataByPage( 1, packaging_page_bar.pageLimit, null);
		}
		
		private function stateFunc(oItem:Object,iCol:int):String
		{
			return GDPSDataManager.getInstance().getStateName(oItem.SState);
		}
		
		private function scopeFunc(oItem:Object,iCol:int):String
		{
			return GDPSDataManager.getInstance().getCropeName(oItem.SScope);
		}
		
		private function opridFunc(oItem:Object,iCol:int):String
		{
			var a1:Array = oItem.SOprid.toString().split(",");
			var out:String = "";
			
			for(var i:int = 0;i < a1.length;i++)
			{
				if(a1[i]){
					out += GDPSDataManager.getInstance().getServerList[a1[i]] + ",";
				}
			}
			out = StringTWLUtil.delStringLastChar(out , ",");
			return out;
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
			var len:int = packaging_grid.dataProvider.length;
			var index:int = 0;
			for(var i:int = 0 ;i < len ;i++)
			{
				var obj:Object = packaging_grid.dataProvider[i] as Object;
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
		public function findPackagingDataByPage(pageNo:int, pageLimit:int, params:*):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit, "SScope" : GDPSDataManager.base_data_type};/*, "tableId": confItem.extend.queryTableId */
			http.sucResult_f = showPackagingData;
			var _url:String = GDPSServices.getBatchRecord_url;
			http.conn(_url, "POST");
		}
		
		private function showPackagingData(a:*):void
		{
			var value:* = a;
			
			packaging_grid.dataProvider = value.data;
			
			packaging_page_bar.pageData = value.data.length;
			packaging_page_bar.totalCount = value.page.totalRowCount;
			packaging_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findPackagingDataByPage(pageNo, pageLimit, null);
		}
	}
}