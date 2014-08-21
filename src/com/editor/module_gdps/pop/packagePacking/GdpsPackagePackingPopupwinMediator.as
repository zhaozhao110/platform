package com.editor.module_gdps.pop.packagePacking
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.view.packaging.mediator.GdpsPackagingDataGridMediator;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class GdpsPackagePackingPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPackagePackingPopupwinMediator";
		
		public function GdpsPackagePackingPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get batchRecord():GdpsPackagePackingPopupwin
		{
			return viewComponent as GdpsPackagePackingPopupwin; 
		}
		public function get chooseTip():UILabel
		{
			return batchRecord.choose_tip;
		}
		public function get packagingBtn():UIButton
		{
			return batchRecord.packagingBtn;
		}
		public function get listBatchRecordDetail_datagrid():SandyDataGrid
		{
			return batchRecord.listBatchRecordDetail_datagrid;
		}
		
		private var confItem:AppModuleConfItem; //左侧菜单请求的信息
		private var detailTableId:int; //批次明细表id
		private var historyTableId:int; //版本记录表ID
		private var batchNo:String;//当前批次号
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:OpenPopwinData = batchRecord.item as OpenPopwinData;//获取上层窗口的传值对象
			confItem = dat.data.confItem;
			detailTableId = confItem.extend.detailTableId;
			historyTableId = confItem.extend.historyTableId;
			GDPSDataManager.msgInfo = "";
			GDPSDataManager.getInstance().registerXMLSocket(GdpsXmlSocketConst.client_type_packaging);
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			cache_dg_data = null;
		}
		
		private function get dataGridMediator():GdpsPackagingDataGridMediator
		{
			return retrieveMediator(GdpsPackagingDataGridMediator.NAME + confItem.menuId) as GdpsPackagingDataGridMediator;
		}
		
		private function initView():void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			if(grid.selectedItem != null)
			{
				batchNo = grid.selectedItem.SBid
			}
			chooseTip.text = "当前批次号【" + batchNo + "】";
			
			listBatchRecordDetail_datagrid.dataProvider = [];
			findRecordByPage();
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
			if (detailTableId <= 0)
			{
				showError("获取查询表id失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": detailTableId, "SState": "1" };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			
			var cols:Array = listBatchRecordDetail_datagrid.columns || [];
			
			var dg:ASDataGridColumn = new ASDataGridColumn();
			dg.dataField = "STableName";
			dg.headerText = "更新主题";
			dg.columnWidth = 100;
			dg.sortable = false;
			cols.push(dg);
			
			for (var i:int = 0; i < columns.length; i++)
			{
				var dgc:ASDataGridColumn = new ASDataGridColumn();
				dgc.dataField = columns[i].SField;
				dgc.headerText = columns[i].SName;
				dgc.columnWidth = columns[i].NWidth;
				dgc.sortable = false;
				cols.push(dgc);
			}
			listBatchRecordDetail_datagrid.columns = cols;
			
			initView();
		}
		
		/**
		 * 加载总批次记录表数据
		 */
		public function findRecordByPage():void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			if(grid.selectedItem != null)
			{
				batchNo = grid.selectedItem.SBid;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": batchNo };
			http.sucResult_f = showTotalBatchRecord;
			http.conn(GDPSServices.getBatchDetail_url, "POST" );
		}
		
		private var cache_dg_data:Array;
		
		private function showTotalBatchRecord(a:*):void
		{
			var value:* = a.data;
			
			cache_dg_data = value;
			listBatchRecordDetail_datagrid.dataProvider = cache_dg_data;
		}
		
		public function reactToPackagingBtnClick(evt:MouseEvent):void
		{
			if (cache_dg_data == null || cache_dg_data.length == 0)
			{
				showError("请先选择需要打包的版本记录");
				return;
			}
			
			var mes:OpenMessageData = new OpenMessageData();
			mes.info = "您确认需要对当前批次进行打包吗？";
			mes.okFunction = packagingBtnFunc;
			mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			showConfirm(mes);
		}
		
		private function packagingBtnFunc():Boolean
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": batchNo };
			http.sucResult_f = packagingBtnFuncCallback;
			http.conn(GDPSServices.getPackagingBatchDetail_url, "POST");
			
			return true;
		}
		
		private function packagingBtnFuncCallback(a:*):void
		{
			sendNotification(GDPSAppEvent.showMsgProgressBarGdps_event);
			dataGridMediator.findPackagingDataByPage(dataGridMediator.packaging_page_bar.pageNo, 20, null);
			closeWin();
		}
	}
}