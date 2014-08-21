package com.editor.module_gdps.pop.packageEdit
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.event.GDPSAppEvent;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.pop.packageAddDetail.GdpsAddDetailItemRenderer;
	import com.editor.module_gdps.pop.packageDetail.GdpsPackageDetailPopupwinMediator;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.services.GdpsXmlSocketConst;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.view.packaging.mediator.GdpsPackagingDataGridMediator;
	import com.editor.module_gdps.vo.GDPSXmlSocketData;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.puremvc.patterns.observer.Notification;
	
	import flash.events.MouseEvent;

	public class GdpsPackageEditDetailPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPackageEditDetailPopupwinMediator";
		
		public function GdpsPackageEditDetailPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get addEditDetailPopwin():GdpsPackageEditDetailPopupwin
		{
			return viewComponent as GdpsPackageEditDetailPopupwin;
		}
		public function get list():GdpsModuleDataGrid
		{
			return addEditDetailPopwin.list;
		}
		public function get list_tablenamedefine_datagrid():SandyDataGrid
		{
			return list.tableSpace_grid;
		}
		public function get list_tablenamedefine_page_bar():GdpsPageBar
		{
			return list.tableSpace_page_bar;
		}
		public function get local_batchno_tip():UILabel
		{
			return addEditDetailPopwin.local_batchno_tip;
		}
		public function get saveBtn():UIButton
		{
			return addEditDetailPopwin.saveBtn;
		}
		
		private var selectedBoxTableIdArray:Array = []; //存放选中的表记录id
		private var selectedBoxTableNameArray:Array = []; //存放选中的表名信息
		private var tableDefineId:String//查询基础数据记录表ID
		private var menuId:String;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:OpenPopwinData = addEditDetailPopwin.item as OpenPopwinData; //获取上层窗口的传值对象
			tableDefineId = dat.data.tableDefineId;
			menuId = dat.data.menuId;
			GDPSDataManager.msgInfo = "";
			//注册检测类型xmlsocket
			list_tablenamedefine_page_bar.pageLimit = 15;
			list_tablenamedefine_page_bar.pageNoChangeFun = onPageChange;
			GDPSDataManager.getInstance().registerXMLSocket(GdpsXmlSocketConst.client_type_adddetail);
			
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			cache_dg_data = null;
			selectedBoxTableIdArray = null;
			selectedBoxTableNameArray = null;
		}
		
		private function get dataGridMediator():GdpsPackagingDataGridMediator
		{
			return retrieveMediator(GdpsPackagingDataGridMediator.NAME + menuId) as GdpsPackagingDataGridMediator;
		}
		
		private function get detailDataGridMediator():GdpsPackageDetailPopupwinMediator
		{
			return retrieveMediator(GdpsPackageDetailPopupwinMediator.NAME) as GdpsPackageDetailPopupwinMediator;
		}
		
		private function initView():void
		{
			var grid:SandyDataGrid = dataGridMediator.packaging_grid;
			local_batchno_tip.text = "当前批次号【" + grid.selectedItem.SBid + "】";
			
			list_tablenamedefine_datagrid.dataProvider = [];
			findTableNameDefineDataByPage(1, list_tablenamedefine_page_bar.pageLimit, null)
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": tableDefineId };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			
			var cols:Array = list_tablenamedefine_datagrid.columns || [];
			
			var dg1:ASDataGridColumn = new ASDataGridColumn();
			dg1.renderer = GdpsAddDetailItemRenderer;
			dg1.headerText = "#";
			dg1.columnWidth = 35;
			dg1.sortable = false;
			dg1.editable = true;
			cols.push(dg1);
			
			for (var i:int = 0; i < columns.length; i++)
			{
				var dgc:ASDataGridColumn = new ASDataGridColumn();
				if (columns[i].SField != 'NId' && columns[i].SField != 'SName' 
					&& columns[i].SField != 'SField' && columns[i].SField != 'DUpdate' 
					&& columns[i].SField != 'NUpdate') 
				{// 只展示几项常用的字段
					continue;
				}
				dgc.dataField = columns[i].SField;
				dgc.headerText = columns[i].SName;
				dgc.columnWidth = 150;
				dgc.sortable = false;
				cols.push(dgc);
			}
			list_tablenamedefine_datagrid.columns = cols;
			
			initView();
		}
		
		public function findTableNameDefineDataByPage(pageNo:int, pageLimit:int, params:*):void
		{
			cache_dg_data = [];
			list_tablenamedefine_datagrid.dataProvider = [];
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit };
			http.sucResult_f = showTableNameDefineData;
			http.conn(GDPSServices.getPublishTableData_url, "POST" );
		}
		
		private var cache_dg_data:Array;
		
		private function showTableNameDefineData(a:*):void
		{
			var value:* = a;
			cache_dg_data = value.data
			for (var i:int = 0; i < cache_dg_data.length; i++)
			{
				Object(cache_dg_data[i]).cbSelect = false;
			}
			list_tablenamedefine_datagrid.dataProvider = cache_dg_data;
			
			//设置分页参数
			list_tablenamedefine_page_bar.pageData = value.data.length;
			list_tablenamedefine_page_bar.totalCount = value.page.totalRowCount;
			list_tablenamedefine_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findTableNameDefineDataByPage(pageNo, pageLimit, null);
		}
		
		public function reactToSaveBtnClick(evt:MouseEvent):void
		{
			selectedBoxTableIdArray = [];
			selectedBoxTableNameArray = [];
			if(cache_dg_data == null || cache_dg_data.length === 0)
			{
				showError("请先选择需要添加的表数据记录");
				return;
			}
			for (var i:int = 0; i < cache_dg_data.length; i++)
			{
				var obj:Object = Object(cache_dg_data[i]);
				if (obj.cbSelect == true)
				{
					var indexOf:int = selectedBoxTableIdArray.indexOf(int(obj.NId));
					if(indexOf >= 0)
					{
						showError("每个批次中同一张数据表的版本数据只允许存在一份，请勿重复多选。");
						return;
					}
					selectedBoxTableIdArray.push(int(obj.NId));//表ID
					selectedBoxTableNameArray.push(String(obj.SName));//表名
				}
			}
			if (selectedBoxTableIdArray.length === 0)
			{
				showError("请先选择需要添加的表数据记录");
				return;
			}
			var detailGridData:Array = detailDataGridMediator.get_ache_dg_data();
			for (var n:int = 0; n < detailGridData.length; n++)
			{
				var _obj:Object = Object(detailGridData[n]);
				var _indexOf:int = selectedBoxTableIdArray.indexOf(int(_obj.SRid));
				if(_indexOf >= 0)
				{
					showError( "【" + selectedBoxTableNameArray[_indexOf] + "】在批次明细中已经存在，请勿重复添加。");
					return;
				}
			}
			
			var mes:OpenMessageData = new OpenMessageData();
			mes.info = "您确认需要将当前选择的记录添加至更新批次吗？";
			mes.okFunction = saveBtnFunc;
			mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
			showConfirm(mes);
		}
		
		private function saveBtnFunc():Boolean
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid":dataGridMediator.packaging_grid.selectedItem.SBid, "tableIdList": selectedBoxTableIdArray.join(",") };
			http.sucResult_f = saveBtnCallback;
			http.conn(GDPSServices.getSaveEditDetail2BatchRecord_url, "POST");
			
			return true;
		}
		
		private function saveBtnCallback(a:*):void
		{
			sendNotification(GDPSAppEvent.showMsgProgressBarGdps_event);
			showError("直接添加编辑表数据成功");
			detailDataGridMediator.findRecordByPage();
			detailDataGridMediator.selectedBoxHandler(false);
			closeWin();
			closePoupwin(GDPSPopupwinSign.GdpsPackageDetailPopupwin_sign);
		}
		
	}
}