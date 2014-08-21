package com.editor.module_gdps.pop.publishTiyan
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.view.publish.mediator.GdpsPublishDataGridMediator;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class GdpsPublishTiyanPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String  = "GdpsPublishTiyanPopupwinMediator";
		
		public function GdpsPublishTiyanPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get publishTiyanPopwin():GdpsPublishTiyanPopupwin
		{
			return viewComponent as GdpsPublishTiyanPopupwin;
		}
		public function get server_execute_datagrid():SandyDataGrid
		{
			return publishTiyanPopwin.server_execute_datagrid;
		}
		public function get chooseTip():UILabel
		{
			return publishTiyanPopwin.choose_tip;
		}
		public function get submitBtn():UIButton
		{
			return publishTiyanPopwin.submitBtn;
		}
		public function get resetBtn():UIButton
		{
			return publishTiyanPopwin.resetBtn;
		}
		
		private var confItem:AppModuleConfItem; //左侧菜单请求的信息
		private var detailTableId:int; //批次明细表id
		private var selectedId:String; //当前批次号
		
		override public function onRegister():void
		{
			super.onRegister();
			var dat:OpenPopwinData = publishTiyanPopwin.item as OpenPopwinData; //获取上层窗口的传值对象
			confItem = dat.data.confItem;
			detailTableId = confItem.extend.detailTableId;
			
			GDPSDataManager.msgInfo = "";
			GDPSDataManager.getInstance().registerXMLSocket(GdpsXmlSocketConst.client_type_server);
			
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			submitBtn.enabled = true;
			selectedId = "";
			
		}
		
		private function get dataGridMediator():GdpsPublishDataGridMediator
		{
			return retrieveMediator(GdpsPublishDataGridMediator.NAME + confItem.menuId) as GdpsPublishDataGridMediator;
		}
		
		private function initView():void
		{
			var grid:SandyDataGrid = dataGridMediator.publish_grid;
			selectedId = grid.selectedItem.SBid;
			chooseTip.text = "当前批次号【" + selectedId + "】";
			publishTiyanPopwin.add_tip.text = "默认更新当前项目的所有体验测试服务器。";
			publishTiyanPopwin.client_text.text = grid.selectedItem.NClientRevision;
			publishTiyanPopwin.server_text.text = grid.selectedItem.NServerRevision;
			publishTiyanPopwin.res_text.text = grid.selectedItem.NResRevision;
			server_execute_datagrid.dataProvider = [];
			findRecordByPage();
		}
		
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
			http.conn(GDPSServices.getDataGridColumn_url);
		}
		
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data; //服务端的ColumnNameDefine对象
			var cols:Array = server_execute_datagrid.columns || [];
			for (var i:int = 0; i < columns.length; i++)
			{
				var dgc:ASDataGridColumn = new ASDataGridColumn();
				dgc.dataField = columns[i].SField;
				dgc.headerText = columns[i].SName;
				dgc.columnWidth = columns[i].NWidth;
				dgc.sortable = false;
				cols.push(dgc);
			}
			server_execute_datagrid.columns = cols;
			
			initView();
		}
		
		/**
		 * 加载批次明细数据
		 */
		public function findRecordByPage():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": selectedId };
			http.sucResult_f = showTotalBatchRecord;
			http.conn(GDPSServices.getBatchDetail_url);
		}
		
		private function showTotalBatchRecord(a:*):void
		{
			var value:* = a;
			server_execute_datagrid.dataProvider = value.data;
		}
		
		public function reactToSubmitBtnClick(evt:MouseEvent):void
		{
			if (selectedId == null || selectedId == "")
			{
				showError("请先选择需要更新的批次号！");
				return;
			}
			var mes:OpenMessageData = new OpenMessageData();
			mes.info = "您确认需要更新当前批次【" + selectedId + "】到体验测试服吗？";
			mes.okFunction = submitBtnFunc;
			mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			showConfirm(mes);
		}
		
		private function submitBtnFunc():Boolean
		{
			submitBtn.enabled = false;
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid": selectedId };
			http.sucResult_f = submitBtnFuncCallback;
			http.conn(GDPSServices.getPublishTiyan_url);
			return true;
		}
		
		private function submitBtnFuncCallback(a:*):void
		{
			sendNotification(GDPSAppEvent.showMsgProgressBarGdps_event);
			dataGridMediator.findPublishDataByPage(dataGridMediator.publish_page_bar.pageNo, 20, null);
			closeWin();
		}
		
		public function reactToResetBtnClick(evt:MouseEvent):void
		{
			closeWin();
		}
	}
}