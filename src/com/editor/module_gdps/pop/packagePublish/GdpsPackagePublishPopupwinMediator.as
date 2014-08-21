package com.editor.module_gdps.pop.packagePublish
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

	public class GdpsPackagePublishPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPackagePublishPopupwinMediator";
		
		public function GdpsPackagePublishPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get batchRecord():GdpsPackagePublishPopupwin
		{
			return viewComponent as GdpsPackagePublishPopupwin; 
		}
		public function get chooseTip():UILabel
		{
			return batchRecord.choose_tip;
		}
		public function get dataPublishBtn():UIButton
		{
			return batchRecord.dataPublishBtn;
		}
		public function get updateBatchRecordDetail_datagrid():SandyDataGrid
		{
			return batchRecord.updateBatchRecordDetail_datagrid;
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
			GDPSDataManager.msgInfo = "";
			GDPSDataManager.getInstance().registerXMLSocket(GdpsXmlSocketConst.client_type_config);
			findDataGridColumn();
		}
		
		private function get dataGridMediator():GdpsPackagingDataGridMediator
		{
			return retrieveMediator(GdpsPackagingDataGridMediator.NAME + confItem.menuId) as GdpsPackagingDataGridMediator;
		}
		
		private function initView():void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			batchNo = grid.selectedItem.SBid;
			chooseTip.text = "当前批次号【" + batchNo + "】";
			updateBatchRecordDetail_datagrid.dataProvider = [];
			findRecordByPage();
		}
		
		private function findDataGridColumn():void
		{
			if(detailTableId <= 0)
			{
				showError("获取查询表id失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = {"queryTableId": detailTableId, "SState": "1"};
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
		}
		
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			var cols:Array = updateBatchRecordDetail_datagrid.columns || [];
			var dg:ASDataGridColumn = new ASDataGridColumn();
			dg.dataField = "STableName";
			dg.headerText = "更新主题";
			dg.columnWidth = 100;
			dg.sortable = false;
			cols.push(dg);
			
			for(var i:int = 0; i < columns.length; i++)
			{
				var dgc:ASDataGridColumn = new ASDataGridColumn();
				dgc.dataField = columns[i].SField;
				dgc.headerText = columns[i].SName;
				dgc.columnWidth = columns[i].NWidth;
				dgc.sortable = false;
				cols.push(dgc);
			}
			updateBatchRecordDetail_datagrid.columns = cols;
			
			initView();
		}
		
		/**
		 * 加载批次明细数据
		 */
		public function findRecordByPage():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = {"SBid": batchNo};
			http.sucResult_f = showTotalBatchRecord;
			http.conn(GDPSServices.getBatchDetail_url, "POST");
		}
		
		private function showTotalBatchRecord(a:*):void
		{
			var out:Array = a.data;
			
			updateBatchRecordDetail_datagrid.dataProvider = out;
		}
		
		public function reactToDataPublishBtnClick(evt:MouseEvent):void
		{
			var mes:OpenMessageData = new OpenMessageData();
			mes.info = "您确认需要对当前批次进行对外发布吗？";
			mes.okFunction = dataPublishBtnFunc;
			mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			showConfirm(mes);
		}
		
		private function dataPublishBtnFunc():Boolean
		{
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": batchNo };
			http.sucResult_f = dataPublishBtnFuncCallback;
			http.conn(GDPSServices.get_baseData_publish_url);
			
			return true;
		}
		
		private function dataPublishBtnFuncCallback(a:*):void
		{
			sendNotification(GDPSAppEvent.showMsgProgressBarGdps_event);
			dataGridMediator.findPackagingDataByPage(1, dataGridMediator.packaging_page_bar.pageNo, null);
			closeWin();
		}
	}
}