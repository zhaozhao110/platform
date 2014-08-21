package com.editor.module_gdps.view.tableSpace.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.component.GdpsTableSpaceToolBar;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.utils.CacheDataUtil;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;

	public class GdpsTableSpaceToolBarMediator extends AppMediator
	{
		public static const NAME:String = "GdpsTableSpaceToolBarMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsTableSpaceToolBarMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsTableSpaceToolBar
		{
			return viewComponent as GdpsTableSpaceToolBar;
		}
		public function get addBtn():UIButton
		{
			return toolBar.addBtn;
		}
		public function get modifyBtn():UIButton
		{
			return toolBar.modifyBtn;
		}
		public function get deleteBtn():UIButton
		{
			return toolBar.deleteBtn;
		}
		public function get createExcelBtn():UIButton
		{
			return toolBar.createExcelBtn;
		}
		public function get excelModeBtn():UIButton
		{
			return toolBar.excelModeBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var menuId:int = confItem.menuId;
			
			if(menuId === 135)
			{
				createExcelBtn.visible = false;
				createExcelBtn.includeInLayout = false;
				
				excelModeBtn.visible = false;
				excelModeBtn.includeInLayout = false;
			}
		}
		
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			menuHandler(addBtn.name);
		}
		
		public function reactToModifyBtnClick(e:MouseEvent):void
		{
			menuHandler(modifyBtn.name);
		}
		
		public function reactToDeleteBtnClick(e:MouseEvent):void
		{
			menuHandler(deleteBtn.name);
		}
		
		public function reactToCreateExcelBtnClick(e:MouseEvent):void
		{
			menuHandler(createExcelBtn.name);
		}
		
		public function reactToExcelModeBtnClick(e:MouseEvent):void
		{
			menuHandler(excelModeBtn.name);
		}
		
		/**
		 * 点击菜单
		 *
		 * @param btnName
		 * @param btnId
		 */
		private function menuHandler(_btnName:String):void
		{
			var btnName:String = _btnName;
			var menuId:int = confItem.menuId;
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "btnName": btnName, "confItem": confItem };
			
			if (btnName == "add" || btnName == "update")
			{
				if (btnName == "update")
				{
					var grid:SandyDataGrid = dataGridMediator.tableSpace_grid;
					if (grid.selectedItem == null || grid.selectedItem.NId == null)
					{
						showError("请先选择一条修改记录！");
						return;
					}
				}
				
				if(menuId === 134)
				{
					dat.popupwinSign = GDPSPopupwinSign.GdpsTableSpacePopwin_sign;
				}
				else if(menuId === 135)
				{
					dat.popupwinSign = GDPSPopupwinSign.GdpsTableSpaceColumnPopupwin_sign;
				}
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
				return;
			}
			if (btnName == "delete")
			{
				var grid2:SandyDataGrid = dataGridMediator.tableSpace_grid
				if (grid2.selectedItem == null || grid2.selectedItem.NId == null)
				{
					showError("请先选择一条记录！");
					return;
				}
				
				var mes:OpenMessageData = new OpenMessageData();
				mes.info = "确认需要删除当前数据吗？";
				mes.okFunction = successFunc;
				mes.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				showConfirm(mes);
				return;
			}
			if(btnName == "create")
			{
				dat.popupwinSign = GDPSPopupwinSign.GdpsTableSpaceCreatePopwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
				return;
			}
			if(btnName == "templete")
			{
				var grid3:SandyDataGrid = dataGridMediator.tableSpace_grid
				if (grid3.selectedItem == null || grid3.selectedItem.NId == null)
				{
					showError("请先选择需要导出excel模板的表记录！");
					return;
				}
				var url:String = GDPSServices.getTableDataTemplete_url + "&srt=2&projectId=" + CacheDataUtil.getProjectId() 
					+ "&menuId=" + confItem.menuId + "&jsessionid=" + CacheDataUtil.getSessionId() + "&NId=" + grid3.selectedItem.NId
				var request:URLRequest = new URLRequest(url);
				request.method = URLRequestMethod.POST; 
				navigateToURL(request, "_blank"); 
			}
		}
		
		/**
		 * 导出成功
		 */
		private function exportSuccessHandlerCallBack():void
		{
			
		}
		
		/**
		 * 导出失败
		 */
		private function exportFaultHandlerCallBack():void
		{
			
		}
		
		private function successFunc():Boolean
		{
			
			var grid3:SandyDataGrid = dataGridMediator.tableSpace_grid;
			//后台删除操作
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "NId": grid3.selectedItem.NId };
			http.sucResult_f = deleteSuccessHandlerCallBack;
			http.fault_f = deleteFaultHandlerCallBack;
			var menuId:int = confItem.menuId;
			
			var _url:String = '';
			if(menuId === 134)
			{
				_url = GDPSServices.getDeleteTableData_url;
			}
			else if(menuId === 135)
			{
				_url = GDPSServices.getDeleteColumnData_url;
			}
			http.conn(_url);
			return true;
		}
		
		private function deleteFaultHandlerCallBack():void
		{
			showError("操作失败");
		}
		
		private function deleteSuccessHandlerCallBack():void
		{
			showError("操作成功");
			dataGridMediator.findTableSpaceDataByPage(dataGridMediator.tableSpace_page_bar.pageNo, 20, null);
		}
		
		private function get dataGridMediator():GdpsTabSpaceDataGridMediator
		{
			return retrieveMediator(GdpsTabSpaceDataGridMediator.NAME + confItem.menuId) as GdpsTabSpaceDataGridMediator;
		}
	}
}