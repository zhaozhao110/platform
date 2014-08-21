package com.editor.module_gdps.pop.tableSpace
{
	import com.editor.component.controls.UIButton;
	import com.editor.model.OpenPopwinData;
	import com.editor.module_gdps.manager.GDPSDataManager;
	import com.editor.module_gdps.services.GDPSServices;
	import com.editor.module_gdps.services.GdpsHttpServiceLocator;
	import com.editor.module_gdps.view.tableSpace.mediator.GdpsTabSpaceDataGridMediator;
	import com.editor.module_gdps.vo.module.AppModuleConfItem;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.component.containers.SandyDataGrid;
	import com.sandy.math.HashMap;
	
	import flash.events.MouseEvent;

	public class GdpsTableSpacePupupwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "GdpsTableSpacePupupwinMediator";
		
		public function GdpsTableSpacePupupwinMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		public function get tableWin():GdpsTableSpacePopupwin
		{
			return viewComponent as GdpsTableSpacePopupwin;
		}
		public function get saveTableBtn():UIButton
		{
			return tableWin.saveTableBtn;
		}
		public function get resetTableBtn():UIButton
		{
			return tableWin.resetTableBtn;
		}
		
		private var menuId:Number;
		private var btnName:String;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			resetForm();
			
			var dat:Object = OpenPopwinData(tableWin.item).data;
			var confItem:AppModuleConfItem = dat.confItem;
			btnName = dat.btnName;
			menuId = confItem.menuId;
			if (menuId < 0)
			{
				showError("缺少必要参数menuId");
			}
			initForm(btnName);
		}
		
		private function resetForm():void
		{
			tableWin.NId.text = "";
			tableWin.SField.text = "";
			tableWin.SName.text = "";
			tableWin.SSchema.text = "";
			tableWin.SExtend.text = "";
			tableWin.SDesc.text = "";
		}
		
		/**
		 * 初始化表单数据
		 *
		 * @param btnName
		 */
		private function initForm(btnName:String):void
		{
			if (btnName == "update")
			{
				tableWin.title = "修改表名对象"
				tableWin.NId.visible = true;
				tableWin.NId.includeInLayout = true;
				
				var grid:SandyDataGrid = dataGridMediator.tableSpace_grid
				var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
				http.args2 = { "menuId": menuId, "NId": grid.selectedItem.NId };
				http.sucResult_f = showTableDataCallBack;
				http.conn(GDPSServices.getTableData_url, "POST");
			}
			else
			{
				tableWin.title = "添加表名对象"
				tableWin.NId.visible = false;
				tableWin.NId.includeInLayout = false;
			}
		}
		
		/**
		 * 修改按钮 显示表单数据回调方法
		 */
		private function showTableDataCallBack(a:*):void
		{
			//服务端的TableNameDefine对象
			var columns:Array = a.data;
			tableWin.NId.text = columns[0].NId;
			tableWin.SField.text = columns[0].SField;
			tableWin.SName.text = columns[0].SName;
			tableWin.SSchema.text = columns[0].SSchema;
			tableWin.SExtend.text = columns[0].SExtend;
			tableWin.SDesc.text = columns[0].SDesc;
		}
		
		public function reactToSaveTableBtnClick(evt:MouseEvent):void
		{
			if(tableWin.NId.visible && tableWin.NId.text == ""){
				showError("表名ID不能为空！");
				return;
			}
			if(tableWin.SField.text == ""){
				showError("表对象英文名不能为空！");
				return;
			}
			if(tableWin.SName.text == ""){
				showError("表对象中文名不能为空！");
				return;
			}
			//添加表单参数
			var formMap:HashMap = new HashMap();
			formMap.put("menuId", menuId);
			formMap.put("NId", tableWin.NId.text);
			formMap.put("SField", tableWin.SField.text);
			formMap.put("SName", tableWin.SName.text);
			formMap.put("SSchema", tableWin.SSchema.text);
			formMap.put("SExtend", tableWin.SExtend.text);
			formMap.put("SDesc", tableWin.SDesc.text);
			//请求后台
			var http:GdpsHttpServiceLocator = new GdpsHttpServiceLocator();
			http.args2 = formMap.getContent();
			http.sucResult_f = saveHandlerCallBack;
			http.fault_f = faultHandlerCallBack;
			http.conn(GDPSServices.getSaveTableData_url, "POST");
		}
		
		private function faultHandlerCallBack(a:*):void
		{
			showError("保存失败|" + a.msg);
		}
		
		private function saveHandlerCallBack(a:*):void
		{
			showMessage("保存成功!");
			dataGridMediator.findTableSpaceDataByPage(dataGridMediator.tableSpace_page_bar.pageNo, 20, null);
			closeWin();
		}
		
		public function reactToResetTableBtnClick(evt:MouseEvent):void
		{
			resetForm();
		}
		
		private function get dataGridMediator():GdpsTabSpaceDataGridMediator
		{
			return retrieveMediator(GdpsTabSpaceDataGridMediator.NAME + menuId) as GdpsTabSpaceDataGridMediator;
		}
	}
}