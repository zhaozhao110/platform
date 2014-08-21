package com.editor.module_gdps.view.productManage.mediator
{
	import com.editor.component.controls.UIButton;
	import com.editor.mediator.AppMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.component.GdpsProductManagerToolBar;
	import com.editor.module_gdps.component.GdpsRoleManagerToolBar;
	import com.editor.module_gdps.component.GdpsServerManagerToolBar;
	import com.editor.module_gdps.manager.GDPSPopupwinSign;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.events.MouseEvent;
	
	public class GdpsProductManagerToolBarMediator extends AppMediator
	{
		public static const NAME:String = "GdpsProductManagerToolBarMediator";
		
		/**
		 * GdpsTableSpaceContainerMediator传递的左侧菜单节点数据对象
		 * @default
		 */
		private var confItem:AppModuleConfItem;
		
		public function GdpsProductManagerToolBarMediator(viewComponent:Object = null, _confItem:AppModuleConfItem = null)
		{
			super(NAME + _confItem.menuId, viewComponent);
			
			this.confItem = _confItem;
		}
		public function get toolBar():GdpsProductManagerToolBar
		{
			return viewComponent as GdpsProductManagerToolBar;
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
		
		override public function onRegister():void
		{
			super.onRegister();
		}
		
		private function get dataGridMediator():GdpsProductManagerDataGridMediator
		{
			return retrieveMediator(GdpsProductManagerDataGridMediator.NAME + confItem.menuId) as GdpsProductManagerDataGridMediator;
		}
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			menuClick(addBtn.name);
		}
		public function reactToModifyBtnClick(e:MouseEvent):void
		{
			menuClick(modifyBtn.name);
		}
		public function reactToDeleteBtnClick(e:MouseEvent):void
		{
			menuClick(deleteBtn.name);
		}
		
		private function menuClick(s:String):void
		{
			var btnName:String = s;
			var menuId:int = confItem.menuId;
			
			var dat:OpenPopwinData = new OpenPopwinData();
			dat.data = { "btnName": btnName, "confItem": confItem };
			
			var grid:SandyDataGrid = dataGridMediator.list;
			
			if (btnName == "add" || btnName == "modify")
			{
				if (btnName == "modify")
				{
					if (grid.selectedItem == null || grid.selectedItem.NId == null)
					{
						showError("请先选择一条修改记录！");
						return;
					}
				}
				dat.popupwinSign = GDPSPopupwinSign.GdpsProductManageAddPopupwin_sign;
				dat.openByAirData = new OpenPopByAirOptions();
				openPopupwin(dat);
				return;
			}
			if (btnName == "delete")
			{
				if (grid.selectedItem == null || grid.selectedItem.NId == null)
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
		}
		
		private function successFunc():Boolean
		{
			var grid3:SandyDataGrid = dataGridMediator.list;
			//后台删除操作
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = { "NId": grid3.selectedItem.NId };
			http.sucResult_f = deleteSuccessHandlerCallBack;
			http.fault_f = deleteFaultHandlerCallBack;
			http.conn(GDPSServices.getProductMamangeDelete_url,"POST" );
			return true;
		}
		
		private function deleteFaultHandlerCallBack():void
		{
			showError("操作失败");
		}
		
		private function deleteSuccessHandlerCallBack(a:*):void
		{
			showError("操作成功");
			dataGridMediator.findTableSpaceDataByPage(dataGridMediator.pageBar.pageNo, 20, null);
		}
	}
}