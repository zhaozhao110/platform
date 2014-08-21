package com.editor.module_gdps.pop.dataManageHistory
{
	import com.editor.component.controls.UILinkButton;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;
	
	public class GdpsDataManageHistoryPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsDataManageHistoryPopupwinMediator";
		
		public function GdpsDataManageHistoryPopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get historyWin():GdpsDataManageHistoryPopupwin
		{
			return viewComponent as GdpsDataManageHistoryPopupwin;
		}
		public function get historyBtn():UILinkButton
		{
			return historyWin.history_btn;
		}
		public function get publishBtn():UILinkButton
		{
			return historyWin.publish_btn;
		}
		public function get hostoryList():GdpsModuleDataGrid
		{
			return historyWin.hostoryList;
		}
		public function get listVersion_datagrid():SandyDataGrid
		{
			return hostoryList.tableSpace_grid;
		}
		public function get listVersion_page_bar():GdpsPageBar
		{
			return hostoryList.tableSpace_page_bar;
		}
		
		private var confItem:AppModuleConfItem;
		private var historyTableId:int = -1;
		private var relatedId:String = "";
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:OpenPopwinData = OpenPopwinData(historyWin.item);//获取上层窗口的传值对象
			confItem = dat.data.confItem;
			if(confItem == null || confItem.extend == ""){
				showError("缺少必要传值参数");  
				return;
			}
			listVersion_page_bar.pageLimit = 15;
			historyTableId = confItem.extend.historyTableId;
			relatedId = confItem.extend.queryTableId;
			listVersion_page_bar.pageNoChangeFun = onPageChange;
			
			findDataGridColumn();
		}
		
		public function reactToHistoryBtnClick(e:MouseEvent):void
		{
			closeWin();
		}
		
		public function reactToPublishBtnClick(e:MouseEvent):void
		{
			publish_link_evt_handler();
		}
		
		/**
		 * 历史版本明细数据查询
		 * 
		 * @param event
		 * @param vno 查询的版本号
		 */
		public function publish_link_evt_handler(vno:String = ""):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = GDPSPopupwinSign.GdpsDataManagePreviewPopwin_sign;
			dat.data = {"vno" : vno, "confItem" : confItem};
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
			if(historyTableId <= 0){
				showError("获取查询表id失败");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": historyTableId };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url, "POST");
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			
			var cols:Array = listVersion_datagrid.columns || [];
			for(var i:int = 0; i < columns.length; i++){
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				if(i === 0){//对版本号进行事件处理
					dg.renderer = GdpsHistoryItemRenderer;
					dg.editable = true;
					dg.columnWidth = 120;
				}else{
					dg.columnWidth = columns[i].NWidth;
				}
				dg.sortable = true;
				cols.push(dg);
			}
			listVersion_datagrid.columns = cols;
			
			findDataVersionRecordByPage(1, listVersion_page_bar.pageLimit, null);
		}
		
		/**
		 * 加载基础数据版本记录表数据
		 */
		private function findDataVersionRecordByPage(pageNo:int, pageLimit:int, params:*):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit, "dataType":  GDPSDataManager.tableDataType, "rid":relatedId};
			http.sucResult_f = showDataVersionRecord;
			http.conn(GDPSServices.getDataVersionRecord_url,  "POST");
		}
		
		private function showDataVersionRecord(a:*):void
		{
			var value:* = a;
			listVersion_datagrid.dataProvider = value.data;
			//设置分页参数
			listVersion_page_bar.pageData = value.data.length;
			listVersion_page_bar.totalCount = value.page.totalRowCount;
			listVersion_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findDataVersionRecordByPage(pageNo, pageLimit, null);
		}
	}
}