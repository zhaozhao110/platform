package com.editor.module_gdps.pop.serverVersion
{
	import com.editor.component.controls.UILabel;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.pop.serverSave.GdpsServerSavePopupwinMediator;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;

	public class GdpsServerVersionPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsServerVersionPopupwinMediator";
		
		public function GdpsServerVersionPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get batchRecord():GdpsServerVersionPopupwin
		{
			return viewComponent as GdpsServerVersionPopupwin;
		}
		public function get hostoryList():GdpsModuleDataGrid
		{
			return batchRecord.hostoryList;
		}
		public function get listBatchRecord_datagrid():SandyDataGrid
		{
			return hostoryList.tableSpace_grid;
		}
		public function get listBatchRecord_page_bar():GdpsPageBar
		{
			return hostoryList.tableSpace_page_bar;
		}
		public function get choose_tip():UILabel
		{
			return batchRecord.choose_tip;
		}
		
		private var _height:int = 70;
		private var queryTableId:String = "5"; // table_name_define中data_version_record的表id
		private var dataType:String = "3"; // 上层提交的表数据类型
		private var batchNo:String = "";
		
		override public function onRegister():void
		{
			super.onRegister();
			
			batchNo = "";
			choose_tip.text = "请在结果列表中选择您需要添加的版本号 【双击记录返回】";
			
			listBatchRecord_page_bar.pageLimit = 15;
			listBatchRecord_page_bar.pageNoChangeFun = onPageChange;
			
			listBatchRecord_datagrid.addEventListener(ASEvent.CHANGE, batchRecordDoubleClickCallback);
			
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			listBatchRecord_datagrid.removeEventListener(ASEvent.CHANGE , batchRecordDoubleClickCallback);
		}
		
		private function get publishServerModuleSavePopwinMediator():GdpsServerSavePopupwinMediator
		{
			return retrieveMediator(GdpsServerSavePopupwinMediator.NAME) as GdpsServerSavePopupwinMediator;
		}
		
		private function initView():void
		{
			if(dataType == "")
			{
				showError("表数据类型[dataType]为空");
				return;
			}
			
			listBatchRecord_datagrid.dataProvider = [];
			
			findRecordByPage(1, 20, null);
		}
		
		private function batchRecordDoubleClickCallback(event:ASEvent):void
		{
			if(event.isDoubleClick)
			{
				var row:Object = listBatchRecord_datagrid.selectedItem;
				if(row && row.SVid != '')
				{
					batchNo = row.SVid;
				}
				
				publishServerModuleSavePopwinMediator.saveWin.server_db_version.text = batchNo;
				closeWin();
			}
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
			if(queryTableId == "")
			{
				showError("获取查询表id失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = {"queryTableId": queryTableId};
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url);
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data; //服务端的ColumnNameDefine对象
			
			var cols:Array = listBatchRecord_datagrid.columns || [];
			for(var i:int = 0; i < columns.length; i++)
			{
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				dg.columnWidth = columns[i].NWidth;
				dg.sortable = true;
				cols.push(dg);
			}
			listBatchRecord_datagrid.columns = cols;
			
			initView();
		}
		
		/**
		 * 加载总批次记录表数据
		 */
		private function findRecordByPage(pageNo:int, pageLimit:int, params:*):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = {"pageNo": pageNo, "pageLimit": pageLimit, "dataType":  GDPSDataManager.sqlDataType};
			http.sucResult_f = showDataVersionRecord;
			http.conn(GDPSServices.getDataVersionRecord_url);
		}
		
		private function showDataVersionRecord(a:*):void
		{
			var value:* = a;
			listBatchRecord_datagrid.dataProvider = value.data;
			//设置分页参数
			listBatchRecord_page_bar.pageData = value.data.length;
			listBatchRecord_page_bar.totalCount = value.page.totalRowCount;
			listBatchRecord_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findRecordByPage(pageNo, pageLimit, null);
		}
	}
}