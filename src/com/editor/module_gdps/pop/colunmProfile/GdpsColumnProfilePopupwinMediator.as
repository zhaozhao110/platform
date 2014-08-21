package com.editor.module_gdps.pop.colunmProfile
{
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsModuleDataGrid;
	import com.editor.module_gdps.component.GdpsPageBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.GdpsXMLToObject;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.view.popup.AppNotDestroyPopupwinMediator;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.math.HashMap;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.events.MouseEvent;

	public class GdpsColumnProfilePopupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsColumnProfilePopupwinMediator";
		
		public function GdpsColumnProfilePopupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		public function get viewWin():GdpsColumnProfilePopupwin
		{
			return viewComponent as GdpsColumnProfilePopupwin;
		}
		public function get profileList():GdpsModuleDataGrid
		{
			return viewWin.profileList;
		}
		public function get tip_info():UILabel
		{
			return viewWin.tip_info;
		}
		public function get s_type():UICombobox
		{
			return viewWin.s_type;
		}
		public function get s_state():UICombobox
		{
			return viewWin.s_state;
		}
		public function get saveBtn():UIButton
		{
			return viewWin.saveBtn;
		}
		public function get resetBtn():UIButton
		{
			return viewWin.resetBtn;
		}
		public function get deleteBtn():UIButton
		{
			return viewWin.deleteBtn;
		}
		public function get profileList_datagrid():SandyDataGrid
		{
			return profileList.tableSpace_grid;
		}
		public function get profileList_page_bar():GdpsPageBar
		{
			return profileList.tableSpace_page_bar;
		}
		
		
		private var confItem:AppModuleConfItem = null;
		private var tableId:String = null; //需要请求数据的表id
		private var _url:String = "";
		
		public var profileTypes:Array = [ {lab:"INTEGER", value:"INTEGER"}, 
										  {lab:"STRING", value:"STRING"}, 
										  {lab:"CDATA", value:"CDATA"}, 
										  {lab:"DATE", value:"DATE"}, 
										  {lab:"TIMESTAMP", value:"TIMESTAMP"}, 
										  {lab:"DATETIME", value:"DATETIME"} ];
			
		
		public var profileStates:Array = [ {lab:"生成", value:"1"}, {lab:"不生成", value:"0"} ];
		
		override public function onRegister():void
		{
			super.onRegister();
			profileList_page_bar.pageLimit = 17;
			
			s_type.dataProvider = profileTypes;
			s_state.dataProvider = profileStates;
			profileList_page_bar.pageNoChangeFun = onPageChange;
			
			profileList_datagrid.dataProvider = null;
			viewWin.n_table_id.editable = true;
			viewWin.s_field.editable = true;
			resetForm();
			
			initView();
			
			viewWin.n_table_id.text = tableId;
		}
		
		private function resetForm():void
		{
			viewWin.n_table_id.text = "";
			viewWin.s_field.text = "";
			viewWin.s_annotation.text = "";
			viewWin.s_key.text = "";
			viewWin.n_order.text = "";
		}
		
		private function initView():void
		{
			var dat:OpenPopwinData = OpenPopwinData(viewWin.item); //获取上层窗口的传值对象
			confItem = dat.data.confItem;
			tableId = dat.data.tableId;
			_url = GDPSServices.profileData_url;
			var queryTableId:int = confItem.extend.queryTableId;
			if (confItem == null || tableId == null)
			{
				showError("缺少必要传值参数");
				return;
			}
			
			tip_info.htmlText = "当前操作表名：" + dat.data.tableName + " 【" + tableId + "】";
			
			findDataGridColumn(queryTableId);
			
			profileList_datagrid.addEventListener("change", changeHandler);
		}
		
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			saveBtnHandler();
		}
		
		public function reactToResetBtnClick(e:MouseEvent):void
		{
			resetBtnHandler();
		}
		
		public function reactToDeleteBtnClick(e:MouseEvent):void
		{
			deleteBtnHandler();
		}
		
		protected function saveBtnHandler():void
		{
			if (!validateData()) {
				showError("请先填写完整表单数据");
				return;
			}
			//添加表单参数
			var formMap:HashMap = new HashMap();
			formMap.put("NTableId", viewWin.n_table_id.text);
			formMap.put("SField", viewWin.s_field.text);
			formMap.put("SAnnotation", viewWin.s_annotation.text);
			formMap.put("SType", viewWin.s_type.selectedItem.data);
			formMap.put("SKey", viewWin.s_key.text);
			formMap.put("SState", viewWin.s_state.selectedItem.data);
			formMap.put("NOrder", viewWin.n_order.text);
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formMap.getContent();
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.profileSaveData_url, "POST");
		}
		
		private function validateData():Boolean
		{
			if (viewWin.n_table_id.text == "" || viewWin.s_field.text == ""
				|| viewWin.s_annotation.text == "" || viewWin.s_type.selectedItem == null
				|| viewWin.s_key.text == "" || viewWin.s_state.selectedItem == null || viewWin.n_order.text == "") {
				return false;
			}
			return true;
		}
		
		private function saveHandlerCallBack(a:*):void
		{
			showMessage("保存成功!");
			findProfileDataByPage(1, profileList_page_bar.pageLimit, tableId, _url);
		}
		
		private function faultHandlerCallBack(a:*):void
		{
			showError("保存失败|" + a.msg);
		}
		
		protected function resetBtnHandler():void
		{
			viewWin.n_table_id.editable = true;
			viewWin.s_field.editable = true;
			
			resetForm();
			
			viewWin.n_table_id.text = tableId;
		}
		
		protected function deleteBtnHandler():void
		{
			if (profileList_datagrid.selectedItem == null)
			{
				showError("请先选择一条记录！");
				return;
			}
			
			var data:OpenMessageData = new OpenMessageData();
			data.info = "确认需要删除当前数据吗？";
			data.okFunction = deleteBtnFunc;
			showConfirm(data);
		}
		
		private function deleteBtnFunc():Boolean
		{
			//后台删除操作
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "NTableId" : profileList_datagrid.selectedItem.n_table_id, 
				"SField" : profileList_datagrid.selectedItem.s_field };
			http.sucResult_f = deleteSuccessHandlerCallBack;
			http.fault_f = deleteFaultHandlerCallBack;
			http.conn(GDPSServices.profileDeleteData_url);
			return true;
		}
		
		private function deleteFaultHandlerCallBack(a:*):void
		{
			showError("操作失败");
		}
		
		private function deleteSuccessHandlerCallBack(a:*):void
		{
			showError("操作成功");
			findProfileDataByPage(1, profileList_page_bar.pageLimit, tableId, _url);
		}
		
		private function changeHandler(e:* = null):void
		{
			var selectedItem:Object = profileList_datagrid.selectedItem;
			if(selectedItem == null) return;
			var type_dataProvider:Object = s_type.dataProvider;
			var state_dataProvider:Object = s_state.dataProvider;
			var obj:Object;
			if(type_dataProvider != null)
			{
				for each (obj in type_dataProvider)
				{
					if (obj.value == String(selectedItem.s_type))
					{
						s_type.selectedItem = obj;
					}
				}
			}
			if(state_dataProvider != null)
			{
				for each (obj in state_dataProvider)
				{
					if (obj.value == String(selectedItem.s_state))
					{
						s_state.selectedItem = obj;
					}
				}
			}
			viewWin.n_table_id.text = selectedItem.n_table_id;
			viewWin.s_field.text = selectedItem.s_field;
			viewWin.s_annotation.text = selectedItem.s_annotation;
			viewWin.s_key.text = selectedItem.s_key;
			viewWin.n_order.text = selectedItem.n_order;
			viewWin.n_table_id.editable = false;
			viewWin.s_field.editable = false;
		}
		
		/**
		 * 根据查询的tableId 获取查询表的column
		 */
		private function findDataGridColumn(queryTableId:int):void
		{
			if (queryTableId <= 0)
			{
				showError("获取数据属性定义表id失败");
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
			
			var cols:Array = profileList_datagrid.columns || [];
			
			for (var i:int = 0; i < columns.length; i++)
			{
				var dg:ASDataGridColumn = new ASDataGridColumn();
				dg.dataField = columns[i].SField;
				dg.headerText = columns[i].SName;
				dg.columnWidth = columns[i].NWidth;
				dg.sortable = true;
				cols.push(dg);
			}
			profileList_datagrid.columns = cols;
			
			findProfileDataByPage(1, profileList_page_bar.pageLimit, tableId, _url);
		}
		
		private function findProfileDataByPage(pageNo:int, pageLimit:int, tableId:String, _url:String):void
		{
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			
			var map:HashMap = new HashMap();
			map.put("pageNo", pageNo);
			map.put("pageLimit", pageLimit);
			map.put("tableId", tableId);
			
			http.args2 = map.getContent();
			http.sucResult_f = showProfileDataByPage;
			http.conn(_url, "POST");
		}
		
		private function showProfileDataByPage(a:*):void
		{
			var value:* = a;
			profileList_datagrid.dataProvider = value.data;
			//设置分页参数
			profileList_page_bar.pageData = value.data.length;
			profileList_page_bar.totalCount = value.page.totalRowCount;
			profileList_page_bar.setBtnStatus();
		}
		
		//当页数发生变化时的处理函数
		private function onPageChange(pageNo:int, pageLimit:int):void
		{
			findProfileDataByPage(pageNo, pageLimit, tableId, _url);
		}
	}
}