package com.editor.module_gdps.view.dataBase.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsDataBaseToolBar;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;

	public class GdpsDataBaseToolBarMediator extends AppMediator
	{
		public static const NAME:String = "GdpsDataBaseToolBarMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsDataBaseToolBarMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsDataBaseToolBar
		{
			return viewComponent as GdpsDataBaseToolBar;
		}
		public function get addBtn():UIButton
		{
			return toolBar.addBtn;
		}
		public function get deleteBtn():UIButton
		{
			return toolBar.deleteBtn;
		}
		public function get submitBtn():UIButton
		{
			return toolBar.submitBtn;
		}
		public function get versionBtn():UIButton
		{
			return toolBar.versionBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			menuHandler(addBtn.name);
		}
		
		public function reactToDeleteBtnClick(e:MouseEvent):void
		{
			menuHandler(deleteBtn.name);
		}
		
		public function reactToSubmitBtnClick(e:MouseEvent):void
		{
			menuHandler(submitBtn.name);
		}
		
		public function reactToVersionBtnClick(e:MouseEvent):void
		{
			menuHandler(versionBtn.name);
		}
		
		private var selectedBoxRidArray:Array = []; //存放选中的表相关记录id
		
		/**
		 * 点击菜单
		 *
		 * @param btnName
		 * @param btnId
		 */
		private function menuHandler(s:String):void
		{
			var btnName:String = s;
			var menuId:int = confItem.menuId;
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = {"btnName": btnName, "confItem": confItem };
			
			if (btnName == "add" || btnName == "update")
			{
				if (btnName == "update")
				{
					var grid:SandyDataGrid = dataGridMediator.databaseFile_grid
					if (grid.selectedItem == null || grid.selectedItem.NId == null)
					{
						showError("请先选择一条修改记录！");
						return;
					}
				}
				
				dat.popupwinSign = GDPSPopupwinSign.GdpsDataBaseAddPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if(btnName == "version")
			{
				dat.popupwinSign = GDPSPopupwinSign.GdpsDataBaseHistoryPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
			else if (btnName == "delete")
			{
				var grid2:SandyDataGrid = dataGridMediator.databaseFile_grid
				if (grid2.selectedItem == null || grid2.selectedItem.n_rid == null)
				{
					showError("请先选择一条记录！");
					return;
				}
				var message:OpenMessageData = new OpenMessageData();
				message.info = "确认需要删除当前数据吗？";
				message.okFunction = successFunc;
				message.showButtonType = OpenMessageData.BUTTON_ALL_SHOW;
				showConfirm(message);
			}
			else if(btnName == "submit")
			{
				selectedBoxRidArray = [];
				var getCacheGridData:Array = dataGridMediator.getCacheGridData;
				if(getCacheGridData == null || getCacheGridData.length == 0){
					return;
				}
				for (var i:int = 0; i < getCacheGridData.length; i++)
				{
					var obj:Object = Object(getCacheGridData[i]);
					if (obj.cbSelect == true)
					{
						if(String(obj.s_state) != "1")
						{
							showError("只有“未更新至版本表”的db记录才可以提交");
							return;
						}
						selectedBoxRidArray.push(int(obj.n_rid));//记录ID
					}
				}
				if (selectedBoxRidArray.length === 0)
				{
					showError("请先选择需要添加的db数据记录");
					return;
				}
				var submitUrl:String = GDPSServices.submitSqlData2Version_url;
				dat.popupwinSign = GDPSPopupwinSign.GdpsDataBaseSubmitPopupwin_sign;
				Object(dat.data).ridArray = selectedBoxRidArray;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
			}
		}
		
		private function successFunc():Boolean
		{
			var grid3:SandyDataGrid = dataGridMediator.databaseFile_grid;
			//后台删除操作
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "rid": grid3.selectedItem.n_rid };
			http.sucResult_f = deleteSuccessHandlerCallBack;
			http.fault_f = deleteFaultHandlerCallBack;
			http.conn(GDPSServices.deleteSqlDataRecord_url, "POST");
			return true;
		}
		
		private function deleteFaultHandlerCallBack():void
		{
			showError("操作失败");
		}
		
		private function deleteSuccessHandlerCallBack(a:*):void
		{
			showError("操作成功");
			dataGridMediator.findDatabaseFileDataByPage(dataGridMediator.databaseFile_page_bar.pageNo, 20, null);
		}
		
		private function get dataGridMediator():GdpsDataBaseDataGridMediator
		{
			return retrieveMediator(GdpsDataBaseDataGridMediator.NAME + confItem.menuId) as GdpsDataBaseDataGridMediator;
		}
	}
}