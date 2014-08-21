package com.editor.module_gdps.pop.dataManageHistory2
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
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

	public class GdpsDataManageHistory2PopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsDataManageHistory2PopupwinMediator";
		
		public function GdpsDataManageHistory2PopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get historyWin():GdpsDataManageHistory2Popupwin
		{
			return viewComponent as GdpsDataManageHistory2Popupwin;
		}
		public function get prepare_cbox():UICheckBox
		{
			return historyWin.prepare_cbox;
		}
		public function get publish_cbox():UICheckBox
		{
			return historyWin.publish_cbox;
		}
		public function get comparisonBtn():UIButton
		{
			return historyWin.comparisonBtn;
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
		
		public static const PREPARE_CBOX_PROPERTY:String = "0";
		public static const PUBLISH_CBOX_PROPERTY:String = "1";
		
		private var cboxNumber:int = 0;
		private var cboxArray:Array = [];
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
			listVersion_page_bar.pageNoChangeFun = onPageChange;
			historyTableId = confItem.extend.historyTableId;
			relatedId = confItem.extend.queryTableId;
			prepare_cbox.selected = true;
			
			findDataGridColumn();
			initView();
		}
		
		override public function callDelPopWin():void
		{
			super.callDelPopWin();
			
			cboxArray = [];
			cboxNumber = 0;
			
			prepare_cbox.removeEventListener(MouseEvent.CLICK, prepare_cbox_evt_handler);
			publish_cbox.removeEventListener(MouseEvent.CLICK, publish_cbox_evt_handler);
			listVersion_datagrid.dispose();
		}
		
		private function initView():void
		{
			var hcs:Boolean = prepare_cbox.selected;
			var pcs:Boolean = publish_cbox.selected;
			if (hcs)
			{
				setCurrentSelectedCbox(PREPARE_CBOX_PROPERTY, prepare_cbox);
			}
			if (pcs)
			{
				setCurrentSelectedCbox(PUBLISH_CBOX_PROPERTY, publish_cbox);
			}
			
			prepare_cbox.addEventListener(MouseEvent.CLICK, prepare_cbox_evt_handler);
			publish_cbox.addEventListener(MouseEvent.CLICK, publish_cbox_evt_handler);
		}
		
		private function prepare_cbox_evt_handler(event:MouseEvent):void
		{
			var hcs:Boolean = prepare_cbox.selected;
			if (!hcs)
			{
				removeCurrentSelectedCbox(PREPARE_CBOX_PROPERTY);
			}
			else
			{
				setCurrentSelectedCbox(PREPARE_CBOX_PROPERTY, prepare_cbox);
			}
		}
		
		private function publish_cbox_evt_handler(event:MouseEvent):void
		{
			var pcs:Boolean = publish_cbox.selected;
			if (!pcs)
			{
				removeCurrentSelectedCbox(PUBLISH_CBOX_PROPERTY);
			}
			else
			{
				setCurrentSelectedCbox(PUBLISH_CBOX_PROPERTY, publish_cbox);
			}
		}
		
		public function reactToComparisonBtnClick(e:MouseEvent):void
		{
			comparison_btn_evt_handler();
		}
		
		private function comparison_btn_evt_handler():void
		{
			if (cboxNumber != 2 || cboxArray.length != 2)
			{
				showError("必须选择两个版本才可以对比");
				return;
			}
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.popupwinSign = GDPSPopupwinSign.GdpsDataManageComparePopwin_sign;
			dat.data = {"compVno" : cboxArray, "confItem" : confItem};
			dat.openByAirData = new OpenPopByAirOptions();
			openPopupwin(dat);
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findVersionRecordByPage(pageNo, pageLimit, null);
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
					dg.renderer = GdpsHistory2ItemRenderer;
					dg.editable = true;
					dg.columnWidth = 130;
				}else{
					dg.columnWidth = columns[i].NWidth;
				}
				cols.push(dg);
			}
			listVersion_datagrid.columns = cols;
			
			findVersionRecordByPage( 1, listVersion_page_bar.pageLimit, null);
		}
		
		/**
		 * 加载版本记录表数据
		 */
		private function findVersionRecordByPage(pageNo:int, pageLimit:int, params:*):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "pageNo": pageNo, "pageLimit": pageLimit, "dataType":  GDPSDataManager.tableDataType, "rid":relatedId};
			http.sucResult_f = showVersionRecordData;
			http.conn(GDPSServices.getDataVersionRecord_url);
		}
		
		private function showVersionRecordData(a:*):void
		{
			var value:* = a;
			listVersion_datagrid.dataProvider = value.data;
			
			//设置分页参数
			listVersion_page_bar.pageData = value.data.length;
			listVersion_page_bar.totalCount = value.page.totalRowCount;
			listVersion_page_bar.setBtnStatus();
		}
		
		public function getCurrentSelectedCboxNumber():int
		{
			return cboxNumber;
		}
		
		public function setCurrentSelectedCbox(vno:String, obj:Object):void
		{
			if (cboxArray.length === 2)
			{
				obj.selected = false;
				showError("只可以选择两个版本进行比较哦");
				return;
			}
			cboxArray.push(vno);
			cboxNumber = cboxArray.length;
		}
		
		public function removeCurrentSelectedCbox(vno:String):void
		{
			for (var i:int = 0; i < cboxArray.length; ++i)
			{
				if (cboxArray[i] === vno)
				{
					cboxArray.splice(i, 1);
					break;
				}
			}
			cboxNumber = cboxArray.length;
		}
	}
}