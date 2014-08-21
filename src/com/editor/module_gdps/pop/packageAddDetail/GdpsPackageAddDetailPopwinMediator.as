package com.editor.module_gdps.pop.packageAddDetail
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.pop.packageDetail.GdpsPackageDetailPopupwinMediator;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.view.packaging.mediator.GdpsPackagingDataGridMediator;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	
	import flash.events.MouseEvent;

	public class GdpsPackageAddDetailPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsPackageAddDetailPopwinMediator";
		
		public function GdpsPackageAddDetailPopwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get dataVersionRecord():GdpsPackageAddDetailPopwin
		{
			return viewComponent as GdpsPackageAddDetailPopwin;
		}
		public function get versionList():GdpsModuleDataGrid
		{
			return dataVersionRecord.versionList;
		}
		public function get listVersion_datagrid():SandyDataGrid
		{
			return versionList.tableSpace_grid;
		}
		public function get listVersion_page_bar():GdpsPageBar
		{
			return versionList.tableSpace_page_bar;
		}
		public function get chooseTip():UILabel
		{
			return dataVersionRecord.choose_tip;
		}
		public function get sourceTypeList():UIVlist
		{
			return dataVersionRecord.sourceTypeList;	
		}
		public function get saveBtn():UIButton
		{
			return dataVersionRecord.saveBtn;
		}
		
		private var SBid:String = null;//当前批次号
		private var selectedBoxRidArray:Array = []; //存放选中的表相关记录id
		private var selectedBoxTableNameArray:Array = []; //存放选中的表名信息
		private var selectedBoxVidArray:Array = []; //存放选中的版本号
		private var historyTableId:String = null;//查询版本记录表ID
		private var menuId:String;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var dat:OpenPopwinData = dataVersionRecord.item as OpenPopwinData; //获取上层窗口的传值对象
			SBid = dat.data.SBid;
			historyTableId = dat.data.historyTableId;
			menuId = dat.data.menuId;
			
			listVersion_page_bar.pageLimit = 15;
			listVersion_page_bar.pageNoChangeFun = onPageChange;
			sourceTypeList.addEventListener(ASEvent.CHANGE , doubleClickHandler);
			
			initView();
			findDataGridColumn();
		}
		
		override public function delPopwin():void
		{
			super.delPopwin();
			cache_dg_data = [];
			selectedBoxRidArray = [];
			selectedBoxVidArray = [];
			selectedBoxTableNameArray = [];
			sourceTypeList.removeEventListener(ASEvent.CHANGE, doubleClickHandler);
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
			chooseTip.text = "当前批次号【" + grid.selectedItem.SBid + "】";
			
			listVersion_datagrid.dataProvider = [];
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn():void
		{
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "queryTableId": historyTableId };
			http.sucResult_f = showDataGridColumn;
			http.conn(GDPSServices.getDataGridColumn_url);
		}
		
		/**
		 * 动态创建column
		 */
		private function showDataGridColumn(a:*):void
		{
			var columns:Array = a.data;
			
			var cols:Array = listVersion_datagrid.columns || [];
			
			var dg1:ASDataGridColumn = new ASDataGridColumn();
			dg1.renderer = GdpsAddDetailItemRenderer;
			dg1.headerText = "#";
			dg1.columnWidth = 35;
			dg1.sortable = false;
			dg1.editable = true;
			cols.push(dg1);
			
			for (var i:int = 0; i < columns.length; i++)
			{
				if(i == 1)
				{
					var _dgc:ASDataGridColumn = new ASDataGridColumn();
					_dgc.dataField = "STableName";
					_dgc.headerText = "数据表名";
					_dgc.columnWidth = 100;
					_dgc.sortable = false;
					cols.push(_dgc);
				}
				var dgc:ASDataGridColumn = new ASDataGridColumn();
				dgc.dataField = columns[i].SField;
				dgc.headerText = columns[i].SName;
				dgc.columnWidth = columns[i].NWidth;
				dgc.sortable = false;
				cols.push(dgc);
			}
			listVersion_datagrid.columns = cols;
		}
		
		private function doubleClickHandler(evt:ASEvent):void
		{
			if(evt.isDoubleClick){
				findListVersionDataByPage(1, listVersion_page_bar.pageLimit, null);
			}
		}
		
		public function findListVersionDataByPage(pageNo:int, pageLimit:int, params:*):void
		{
			cache_dg_data = [];
			listVersion_datagrid.dataProvider = [];
			var dataType:String = sourceTypeList.selectedItem.data;
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "dataType": dataType, "pageNo": pageNo, "pageLimit": pageLimit };
			http.sucResult_f = showDataVersionRecord;
			http.conn(GDPSServices.getDataVersionRecord_url, "POST");
		}
		
		private var cache_dg_data:Array;
		
		private function showDataVersionRecord(a:*):void
		{
			var value:* = a;
			cache_dg_data = value.data
			for (var i:int = 0; i < cache_dg_data.length; i++)
			{
				Object(cache_dg_data[i]).cbSelect = false;
			}
			listVersion_datagrid.dataProvider = cache_dg_data;
			
			//设置分页参数
			listVersion_page_bar.pageData = value.data.length;
			listVersion_page_bar.totalCount = value.page.totalRowCount;
			listVersion_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findListVersionDataByPage(pageNo, pageLimit, null);
		}
		
		public function reactToSaveBtnClick(evt:MouseEvent):void
		{
			selectedBoxRidArray = [];
			selectedBoxVidArray = [];
			selectedBoxTableNameArray = [];
			if(cache_dg_data == null || cache_dg_data.length === 0)
			{
				showError("请先选择需要添加的版本数据记录");
				return;
			}
			for (var i:int = 0; i < cache_dg_data.length; i++)
			{
				var obj:Object = Object(cache_dg_data[i]);
				if (obj.cbSelect == true)
				{
					var indexOf:int = selectedBoxRidArray.indexOf(int(obj.SRid));
					if(indexOf >= 0)
					{
						showError("每个批次中同一张数据表的版本数据只允许存在一份，请勿重复多选。");
						return;
					}
					selectedBoxRidArray.push(int(obj.SRid));//表ID
					selectedBoxVidArray.push(String(obj.SVid));//版本号
					selectedBoxTableNameArray.push(String(obj.STableName));//表名
				}
			}
			if (selectedBoxRidArray.length === 0 || selectedBoxVidArray.length === 0)
			{
				showError("请先选择需要添加的版本数据记录");
				return;
			}
			var detailGridData:Array = detailDataGridMediator.get_ache_dg_data();
			for (var n:int = 0; n < detailGridData.length; n++)
			{
				var _obj:Object = Object(detailGridData[n]);
				var _indexOf:int = selectedBoxRidArray.indexOf(int(_obj.SRid));
				if(_indexOf >= 0)
				{
					showError( selectedBoxTableNameArray[_indexOf] + " 在批次明细中已经存在，请勿重复添加。");
					return;
				}
			}
			
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "SBid":dataGridMediator.packaging_grid.selectedItem.SBid, 
				"SVid": selectedBoxVidArray.join(",") };
			http.sucResult_f = saveBtnCallback;
			http.conn(GDPSServices.getSaveDetailBatchRecord_url, "POST");
		}
		
		private function saveBtnCallback(a:*):void
		{
			showError("添加批次明细成功");
			detailDataGridMediator.findRecordByPage();
			detailDataGridMediator.selectedBoxHandler(false);
			closeWin();
		}
	}
}