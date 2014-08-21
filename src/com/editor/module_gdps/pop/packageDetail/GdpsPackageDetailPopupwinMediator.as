package com.editor.module_gdps.pop.packageDetail
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.view.packaging.mediator.GdpsPackagingDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsPackageDetailPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPackageDetailPopupwinMediator";
		
		public function GdpsPackageDetailPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get batchRecord():GdpsPackageDetailPopupwin
		{
			return viewComponent as GdpsPackageDetailPopupwin;
		}
		public function get listBatchRecordDetail_datagrid():SandyDataGrid
		{
			return batchRecord.listBatchRecordDetail_datagrid;
		}
		public function get chooseTip():UILabel
		{
			return batchRecord.choose_tip;
		}
		public function get addDetailBtn():UIButton
		{
			return batchRecord.addDetailBtn;
		}
		public function get addEditDetailBtn():UIButton
		{
			return batchRecord.addEditDetailBtn;
		}
		public function get deleteBtn():UIButton
		{
			return batchRecord.deleteBtn;
		}
		
		private var confItem:AppModuleConfItem; //左侧菜单请求的信息
		private var detailTableId:int; //批次明细表id
		private var historyTableId:int; //版本记录表ID
		private var tableDefineId:int; //基础编辑表定义ID
		private var selectedBoxArray:Array; //存放选中的批次明细记录id
		
		override public function onRegister():void
		{
			super.onRegister();
			
			selectedBoxArray = [];
			cache_dg_data = [];
			
			var dat:OpenPopwinData = OpenPopwinData(batchRecord.item); //获取上层窗口的传值对象
			confItem = dat.data.confItem;
			detailTableId = confItem.extend.detailTableId;
			historyTableId = confItem.extend.historyTableId;
			tableDefineId = confItem.extend.tableDefineId;
			
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			selectedBoxArray = null;
			cache_dg_data = null;
		}
		
		private function get dataGridMediator():GdpsPackagingDataGridMediator
		{
			return retrieveMediator(GdpsPackagingDataGridMediator.NAME + confItem.menuId) as GdpsPackagingDataGridMediator;
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
			
			var dg1:ASDataGridColumn = new ASDataGridColumn();
			dg1.renderer = GdpsDetailItemRenderer;
			dg1.head_renderer = GdpsDetailHeaderRenderer;
			dg1.columnWidth = 35;
			dg1.sortable = false;
			dg1.editable = true;
			cols.push(dg1);
			
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
		
		private function initView():void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			chooseTip.text = "当前批次号【" + grid.selectedItem.SBid + "】";
			
			listBatchRecordDetail_datagrid.dataProvider = [];
			
			findRecordByPage();
		}
		
		/**
		 * 加载总批次记录表数据
		 */
		public function findRecordByPage():void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": grid.selectedItem.SBid };
			http.sucResult_f = showTotalBatchRecord;
			http.conn(GDPSServices.getBatchDetail_url, "POST");
		}
		
		private var cache_dg_data:Array;
		
		public function get_ache_dg_data():Array
		{
			return cache_dg_data;
		}
		
		private function showTotalBatchRecord(a:*):void
		{
			cache_dg_data = [];
			
			var value:* = a;
			cache_dg_data = value.data
			listBatchRecordDetail_datagrid.dataProvider = cache_dg_data;
		}
		
		public function selectedBoxHandler(selected:Boolean):void
		{
			for (var i:int = 0; i < cache_dg_data.length; i++)
			{
				if (Object(cache_dg_data[i]).SStateId === '1')
				{ 
					Object(cache_dg_data[i]).cbSelect = selected;
				}
			}
			listBatchRecordDetail_datagrid.dataProvider = cache_dg_data;
		}
		
		public function reactToAddDetailBtnClick(evt:MouseEvent):void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "SBid": grid.selectedItem.SBid, "historyTableId": historyTableId ,"menuId":confItem.menuId};
			dat.popupwinSign = GDPSPopupwinSign.GdpsPackageAddDetailPopwin_sign;
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
		
		public function reactToDeleteBtnClick(evt:MouseEvent):void
		{
			if (cache_dg_data == null || cache_dg_data.length == 0)
			{
				showError("请先选择需要删除的明细记录");
				return;
			}
			selectedBoxArray = [];
			for (var i:int = 0; i < cache_dg_data.length; i++)
			{
				var obj:Object = Object(cache_dg_data[i]);
				if (obj.cbSelect == true)
				{
					selectedBoxArray.push(obj.NId);
				}
			}
			if (selectedBoxArray == null || selectedBoxArray.length === 0)
			{
				showError("请先选择需要删除的明细记录");
				return;
			}
			
			var mes:OpenMessageData = new OpenMessageData();
			mes.info = "您确认需要删除当前选择的记录吗？";
			mes.okFunction = deleteBtnFunc;
			mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			showConfirm(mes);
		}
		
		private function deleteBtnFunc():Boolean
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "NId": selectedBoxArray.join(",") };
			http.sucResult_f = deleteBtnFuncCallback;
			http.conn(GDPSServices.getDeleteBatchDetail_url);
			
			return true;
		}
		
		private function deleteBtnFuncCallback(a:*):void
		{
			showError("删除成功");
			
			findRecordByPage();
			
			selectedBoxHandler(false);
		}
		
		/**
		 * 直接添加编辑表数据操作
		 */
		public function reactToAddEditDetailBtnClick(evt:MouseEvent):void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "SBid": grid.selectedItem.SBid, "tableDefineId": tableDefineId ,"menuId":confItem.menuId};
			dat.popupwinSign = GDPSPopupwinSign.GdpsPackageEditDetailPopwin_sign;
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
	}
}