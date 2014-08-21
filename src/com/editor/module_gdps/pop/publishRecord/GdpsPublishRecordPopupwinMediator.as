package com.editor.module_gdps.pop.publishRecord
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILinkButton;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.pop.dataBaseSubmit.GdpsDataBaseSubmitPopupwin;
	import com.editor.module_gdps.pop.dataBaseSubmit.GdpsDataBaseSubmitPopwinMediator;
	import com.editor.module_gdps.pop.dataManageSubmit.GdpsDataManageSubmitPopupwinMediator;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;

	public class GdpsPublishRecordPopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPublishRecordPopupwinMediator";
		
		public function GdpsPublishRecordPopupwinMediator(view:Object = null)
		{
			super(NAME , view);
		}
		public function get publishWin():GdpsPublishRecordPopupwin
		{
			return viewComponent as GdpsPublishRecordPopupwin;
		}
		public function get previewList():GdpsModuleDataGrid
		{
			return publishWin.previewList;
		}
		public function get listBatchRecord_datagrid():SandyDataGrid
		{
			return previewList.tableSpace_grid;
		}
		public function get listBatchRecord_page_bar():GdpsPageBar
		{
			return previewList.tableSpace_page_bar;
		}
		
		private var queryTableId:int = 6; //table_name_define
		private var relatedId:String = ""; // 上层提交的表数据相关记录ID
		private var dataType:String = ""; // 上层提交的表数据类型
		private var batchNo:String = "";
		
		override public function onRegister():void
		{
			super.onRegister();
			
			listBatchRecord_page_bar.pageLimit = 15;
			
			listBatchRecord_page_bar.pageNoChangeFun = onPageChange;
			listBatchRecord_datagrid.doubleClickEnabled = true
			listBatchRecord_datagrid.addEventListener(ASEvent.CHANGE, batchRecordDoubleClickCallback);
			
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			
			resetView();
		}
		
		private function get dataManageSubmitMediator():GdpsDataManageSubmitPopupwinMediator
		{
			return retrieveMediator(GdpsDataManageSubmitPopupwinMediator.NAME) as GdpsDataManageSubmitPopupwinMediator;
		}
		
		private function get databaseFileSubmitMediator():GdpsDataBaseSubmitPopwinMediator
		{
			return retrieveMediator(GdpsDataBaseSubmitPopwinMediator.NAME) as GdpsDataBaseSubmitPopwinMediator;
		}
		
		private function resetView():void
		{
			batchNo = "";
			
			var sm:String = dataType;
			if (sm == GDPSDataManager.tableDataType)
			{
				resetDataManageSubmitMediatorItem();
			}
			else if(sm == GDPSDataManager.fileDataType)
			{
//				resetMapSubmitMediatorItem();
			}
			else if(sm == GDPSDataManager.sqlDataType)
			{
				resetDatabaseFileSubmitMediatorItem();
			}
			listBatchRecord_datagrid.dispose();
		}
		
		private function initView():void
		{
			var dat:OpenPopwinData = publishWin.item as OpenPopwinData; //获取上层窗口的传值对象
			relatedId = dat.data.rid;
			dataType = dat.data.dataType;
			if (relatedId == "" || dataType == "")
			{
				showError("获取上层表数据类型[rid|dataType]失败");
				return;
			}
			
			findRecordByPage(1, listBatchRecord_page_bar.pageLimit, null);
		}
		
		private function batchRecordDoubleClickCallback(event:ASEvent):void
		{
			if(event.isDoubleClick){
				var row:Object = listBatchRecord_datagrid.selectedItem;
				if (row && row.SBid != '')
				{
					batchNo = row.SBid;
					batchRecordDetailTypeUnique(row.SBid, relatedId); //判断当前选择的批次号是否可以再添加当前数据类型
				}
			}
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
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
			
			var cols:Array = listBatchRecord_datagrid.columns ||[];
			for (var i:int = 0; i < columns.length; i++)
			{
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				dg.columnWidth = columns[i].NWidth;
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
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit };
			http.sucResult_f = showTotalBatchRecord;
			http.conn(GDPSServices.getBatchRecord_url, "POST");
		}
		
		private function showTotalBatchRecord(a:*):void
		{
			var value:* = a;
			listBatchRecord_datagrid.dataProvider = value.data;
			listBatchRecord_page_bar.pageData = value.data.length;
			listBatchRecord_page_bar.totalCount = value.page.totalRowCount;
			listBatchRecord_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findRecordByPage(pageNo, pageLimit, null);
		}
		
		/**
		 * 查询指定批次号中是否含有指定的数据类型
		 *
		 * @param bid 批次号
		 * @param tableType 数据类型
		 */
		private function batchRecordDetailTypeUnique(bid:String, rid:String):void
		{
			if (bid == "" || rid == "")
			{
				showError("缺少请求参数");
				return;
			}
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "bid": bid, "rid": rid, "dataType": dataType };
			http.sucResult_f = batchRecordDetailTypeUniqueCallback;
			http.conn(GDPSServices.getBatchRecordDetail_url);
		}
		
		private function batchRecordDetailTypeUniqueCallback(a:*):void
		{
			if (a && a.data.length > 0)
			{
				showError("该批次号已添加过当前数据类型[一个批次号同一种数据类型只能有一个]");
				return;
			}
			var sm:String = dataType;
			if (sm == GDPSDataManager.tableDataType)
			{
				setDataManageSubmitMediatorItem(batchNo);
			}
			else if (sm == GDPSDataManager.fileDataType)
			{
//				setMapSubmitMediatorItem(batchNo);
			}
			else if (sm == GDPSDataManager.sqlDataType)
			{
				setDatabaseFileSubmitMediatorItem(batchNo);
			}
		}
		
		private function changeTotalBatchNoHandler(event:MouseEvent):void
		{
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = GDPSPopupwinSign.GdpsPublishRecordPopupwin_sign;
			dat.data = { "rid": relatedId, "dataType": dataType };
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
		
		private function setDataManageSubmitMediatorItem(batchNo:String):void
		{
			dataManageSubmitMediator.total_batchcbox.label = "是否需要添加至总更新批次 -【批次号: " + batchNo + "】";
			dataManageSubmitMediator.setBatchNo(batchNo);
			
			var tbt:UILinkButton = dataManageSubmitMediator.total_batchText;
			var formItem:UIHBox = dataManageSubmitMediator.hbox;
			if (tbt == null)
			{
				tbt = new UILinkButton();
				tbt.bold = true;
				tbt.text = "点此修改批次号";
				tbt.color = 0x0000FF;
				tbt.addEventListener(MouseEvent.CLICK,changeTotalBatchNoHandler);
				dataManageSubmitMediator.setTotalBatchText(tbt);
			}
			formItem.addChild(tbt);
			dataManageSubmitMediator.total_batchcbox.selected = true;
			closeWin();
		}
		
		private function resetDataManageSubmitMediatorItem():void
		{
			var formItem:UIHBox = dataManageSubmitMediator.hbox;
			var batchText:UILinkButton = dataManageSubmitMediator.total_batchText;
			if (batchText != null && !formItem.contains(batchText))
			{
				dataManageSubmitMediator.total_batchcbox.selected = false; 
			}
		}
		
//		private function setMapSubmitMediatorItem(batchNo:String):void
//		{
//			mapSubmitMediator.total_batchcbox.label = "是否需要添加至总更新批次 -【批次号: " + batchNo + "】";
//			mapSubmitMediator.setBatchNo(batchNo);
//			closeWin();
//			
//			var tbt:Text = mapSubmitMediator.total_batchText;
//			var formItem:FormItem = mapSubmitMediator.submit_Form_Item;
//			if (tbt == null)
//			{
//				tbt = new Text();
//				tbt.htmlText = "<a href='event:change_totalBatchNo_handler'><u>点此修改批次号</u></a>";
//				tbt.setStyle("color", "blue");
//				tbt.addEventListener(TextEvent.LINK, changeTotalBatchNoHandler);
//				mapSubmitMediator.setTotalBatchText(tbt);
//			}
//			formItem.height = _height;
//			formItem.addChild(tbt);
//			mapSubmitMediator.total_batchcbox.selected = true;
//		}
//		
//		private function resetMapSubmitMediatorItem():void
//		{
//			var formItem:FormItem = mapSubmitMediator.submit_Form_Item;
//			var batchText:Text = mapSubmitMediator.total_batchText;
//			if (batchText != null && !formItem.contains(batchText))
//			{
//				mapSubmitMediator.total_batchcbox.selected = false; //将批次号checkBox置空
//			}
//		}
//		
		private function setDatabaseFileSubmitMediatorItem(batchNo:String):void
		{
			databaseFileSubmitMediator.total_batchcbox.label = "是否需要添加至总更新批次 -【批次号: " + batchNo + "】";
			databaseFileSubmitMediator.setBatchNo(batchNo);
			
			var tbt:UILinkButton = databaseFileSubmitMediator.total_batchText;
			var formItem:UIHBox = databaseFileSubmitMediator.hbox;
			if (tbt == null)
			{
				tbt = new UILinkButton();
				tbt.text = "点此修改批次号";
				tbt.color = 0x0000FF;
				tbt.bold = true;
				tbt.addEventListener(MouseEvent.CLICK,changeTotalBatchNoHandler);
				databaseFileSubmitMediator.setTotalBatchText(tbt);
			}
			formItem.addChild(tbt);
			databaseFileSubmitMediator.total_batchcbox.selected = true;
			closeWin();
		}
		
		private function resetDatabaseFileSubmitMediatorItem():void
		{
			var formItem:UIHBox = databaseFileSubmitMediator.hbox;
			var batchText:UILinkButton = databaseFileSubmitMediator.total_batchText;
			if (batchText != null && !formItem.contains(batchText))
			{
				databaseFileSubmitMediator.total_batchcbox.selected = false; //将批次号checkBox置空
			}
		}
		
	}
}